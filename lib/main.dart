import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/compass_components.dart';
import 'ui/compass_home.dart';
import 'ui/compass_theme.dart';

const Size _normalWindowSize = Size(1280, 800);
const Size _minimumWindowSize = Size(1024, 700);
const String _lockdownTitle = 'Secure exam is active';
const String _lockdownMessage =
    'You cannot exit until the exam has been completed or timed out.';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  bool _examLockdownMode = false;
  bool _enteringSecureExam = false;
  bool _lockdownNoticeVisible = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
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
      _handleBlockedWindowAttempt();
    }
  }

  @override
  void onWindowLeaveFullScreen() {
    if (_examLockdownMode) {
      _handleBlockedWindowAttempt();
    }
  }

  Future<void> _handleBlockedWindowAttempt() async {
    await windowManager.restore();
    await windowManager.setFullScreen(true);
    await windowManager.focus();
    await _showLockdownNotice();
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

    await windowManager.setPreventClose(true);
    await windowManager.setResizable(false);
    await windowManager.setMinimizable(false);
    await windowManager.setMaximizable(false);
    await windowManager.setFullScreen(true);
    await windowManager.focus();

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
      home: CompassHome(
        examLockdownMode: _examLockdownMode,
        enteringSecureExam: _enteringSecureExam,
        onStartExam: _enterExamLockdownMode,
        onExitSecureWorkspace: _exitExamLockdownMode,
        onCloseWindow: _showExitSimulation,
        onBlockedExit: _showLockdownNotice,
      ),
    );
  }
}
