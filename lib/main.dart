import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'data/compass_models.dart';
import 'data/compass_repository.dart';
import 'data/supabase_compass_repository.dart';
import 'state/auth_cubit.dart';
import 'state/exam_session_cubit.dart';
import 'state/portal_cubit.dart';
import 'state/score_report_cubit.dart';
import 'ui/compass_components.dart';
import 'ui/compass_home.dart';
import 'ui/compass_theme.dart';

const Size _normalWindowSize = Size(1280, 800);
const Size _minimumWindowSize = Size(1024, 700);
const String _lockdownTitle = 'Secure exam is active';
const String _lockdownMessage =
    'You cannot exit until the exam has been completed or timed out.';
const String _switchBlockedMessage =
    'Switching to another application is not allowed while the exam is active.';
const Duration _lockdownGuardInterval = Duration(milliseconds: 700);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: CompassConfig.supabaseUrl,
    anonKey: CompassConfig.supabasePublishableKey,
  );
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: _normalWindowSize,
    minimumSize: _minimumWindowSize,
    center: true,
    title: 'Compass',
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitle('Compass');
    await windowManager.setResizable(true);
    await windowManager.setMinimizable(true);
    await windowManager.setMaximizable(true);
    await windowManager.setPreventClose(false);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const CompassApp());
}

class CompassApp extends StatefulWidget {
  const CompassApp({super.key});

  @override
  State<CompassApp> createState() => _CompassAppState();
}

class _CompassAppState extends State<CompassApp> with WindowListener {
  late final CompassRepository _repository = SupabaseCompassRepository();
  bool _examLockdownMode = false;
  bool _enteringSecureExam = false;
  bool _lockdownNoticeVisible = false;
  bool _enforcingLockdown = false;
  Timer? _lockdownGuardTimer;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    _stopLockdownGuard();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    if (!_examLockdownMode) {
      await windowManager.destroy();
      return;
    }

    await _handleBlockedWindowAttempt();
  }

  @override
  void onWindowMinimize() {
    if (_examLockdownMode) {
      unawaited(_handleBlockedWindowAttempt());
    }
  }

  @override
  void onWindowLeaveFullScreen() {
    if (_examLockdownMode) {
      unawaited(_handleBlockedWindowAttempt());
    }
  }

  @override
  void onWindowBlur() {
    if (_examLockdownMode) {
      unawaited(_handleBlockedWindowAttempt(message: _switchBlockedMessage));
    }
  }

  @override
  void onWindowUnmaximize() {
    if (_examLockdownMode) {
      unawaited(_handleBlockedWindowAttempt());
    }
  }

  @override
  void onWindowRestore() {
    if (_examLockdownMode) {
      unawaited(_enforceExamWindowState());
    }
  }

  Future<void> _handleBlockedWindowAttempt({String? message}) async {
    await _enforceExamWindowState();
    if (_examLockdownMode) {
      await _showLockdownNotice(message: message);
    }
  }

  void _startLockdownGuard() {
    _lockdownGuardTimer?.cancel();
    _lockdownGuardTimer = Timer.periodic(_lockdownGuardInterval, (_) {
      if (_examLockdownMode) {
        unawaited(_enforceExamWindowState());
      }
    });
  }

  void _stopLockdownGuard() {
    _lockdownGuardTimer?.cancel();
    _lockdownGuardTimer = null;
  }

  Future<void> _enforceExamWindowState() async {
    if (!_examLockdownMode || _enforcingLockdown) {
      return;
    }

    _enforcingLockdown = true;
    try {
      await windowManager.show();
      if (!_examLockdownMode) {
        return;
      }
      if (await windowManager.isMinimized()) {
        await windowManager.restore();
      }
      if (!_examLockdownMode) {
        return;
      }
      if (!await windowManager.isAlwaysOnTop()) {
        await windowManager.setAlwaysOnTop(true);
      }
      if (!_examLockdownMode) {
        return;
      }
      if (!await windowManager.isFullScreen()) {
        await windowManager.restore();
        await windowManager.unmaximize();
        await windowManager.setTitleBarStyle(
          TitleBarStyle.hidden,
          windowButtonVisibility: false,
        );
        await windowManager.setFullScreen(true);
      }
      if (!_examLockdownMode) {
        return;
      }
      if (!await windowManager.isFocused()) {
        await windowManager.focus();
      }
    } finally {
      _enforcingLockdown = false;
    }
  }

  Future<void> _activateExamWindowRestrictions() async {
    await windowManager.setTitle(_lockdownTitle);
    await windowManager.setPreventClose(true);
    await windowManager.setClosable(false);
    await windowManager.show();
    await windowManager.restore();
    await windowManager.unmaximize();
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setResizable(false);
    await windowManager.setMinimizable(false);
    await windowManager.setMaximizable(false);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setFullScreen(true);
    await windowManager.focus();
  }

  Future<void> _enterExamLockdownMode() async {
    if (_examLockdownMode || _enteringSecureExam) {
      return;
    }

    setState(() {
      _enteringSecureExam = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));

    if (!mounted) {
      return;
    }

    setState(() {
      _examLockdownMode = true;
    });

    await _activateExamWindowRestrictions();
    _startLockdownGuard();

    if (!mounted) {
      return;
    }

    setState(() {
      _enteringSecureExam = false;
    });
  }

  Future<void> _exitExamLockdownMode() async {
    if (!_examLockdownMode && !_enteringSecureExam) {
      return;
    }

    if (mounted) {
      setState(() {
        _examLockdownMode = false;
        _enteringSecureExam = false;
      });
    }

    _stopLockdownGuard();
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setClosable(true);
    await windowManager.setFullScreen(false);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await windowManager.restore();
    await windowManager.unmaximize();
    await windowManager.setPreventClose(false);
    await windowManager.setMinimumSize(_minimumWindowSize);
    await windowManager.setSize(_normalWindowSize);
    await windowManager.center();
    await windowManager.setResizable(true);
    await windowManager.setMinimizable(true);
    await windowManager.setMaximizable(true);
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setTitle('Compass');
    await windowManager.focus();
  }

  Future<void> _showLockdownNotice({String? title, String? message}) async {
    if (_lockdownNoticeVisible || !mounted) {
      return;
    }

    _lockdownNoticeVisible = true;
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return CompassModalDialog(
            icon: Icons.lock_outline,
            title: title ?? _lockdownTitle,
            message: message ?? _lockdownMessage,
            actions: [
              CompassPrimaryButton(
                label: 'OK',
                tone: CompassButtonTone.exam,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          );
        },
      );
    } finally {
      _lockdownNoticeVisible = false;
    }
  }

  Future<void> _showExitSimulation() {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CompassModalDialog(
          icon: Icons.logout,
          title: 'Close Window',
          message:
              'This would close the pre-exam Compass session and return the '
              'candidate to the sign-in flow. The prototype keeps the window '
              'open so the workflow can continue.',
          actions: [
            CompassSecondaryButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            CompassPrimaryButton(
              label: 'End Session',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compass',
      theme: buildCompassTheme(),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CompassRepository>.value(value: _repository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthCubit(_repository)),
            BlocProvider(create: (_) => PortalCubit(_repository)),
            BlocProvider(create: (_) => ExamSessionCubit(_repository)),
            BlocProvider(create: (_) => ScoreReportCubit()),
          ],
          child: CompassHome(
            examLockdownMode: _examLockdownMode,
            enteringSecureExam: _enteringSecureExam,
            onStartExam: _enterExamLockdownMode,
            onExitSecureWorkspace: _exitExamLockdownMode,
            onCloseWindow: _showExitSimulation,
            onBlockedExit: _showLockdownNotice,
          ),
        ),
      ),
    );
  }
}
