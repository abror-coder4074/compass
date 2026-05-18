import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/compass_models.dart';
import '../data/error_messages.dart';
import '../state/auth_cubit.dart';
import '../state/exam_session_cubit.dart';
import '../state/portal_cubit.dart';
import '../state/score_report_cubit.dart';
import 'compass_shells.dart';
import 'exam/exam_flow.dart';
import 'exam/exam_models.dart';
import 'portal_flow.dart';

const String _proctorUnlockPassword = 'Compass2026';
const String _verifyUnlockDefaultNotice =
    'Candidate, please verify that the following information is correct.';
const String _verifyUnlockInvalidProctorNotice =
    'Candidate, please verify the proctor username and password.';
const Duration _preExamLandingBlankDelay = Duration(seconds: 12);

class CompassHome extends StatefulWidget {
  const CompassHome({
    required this.examLockdownMode,
    required this.onStartExam,
    required this.onExitSecureWorkspace,
    required this.onCloseWindow,
    required this.onBlockedExit,
    this.enteringSecureExam = false,
    this.examTimerConfig = const ExamTimerConfig(),
    super.key,
  });

  final bool examLockdownMode;
  final bool enteringSecureExam;
  final Future<void> Function() onStartExam;
  final Future<void> Function() onExitSecureWorkspace;
  final Future<void> Function() onCloseWindow;
  final LockdownNoticeCallback onBlockedExit;
  final ExamTimerConfig examTimerConfig;

  @override
  State<CompassHome> createState() => _CompassHomeState();
}

class _CompassHomeState extends State<CompassHome> {
  final _loginUsernameController = TextEditingController(
    text: 'pochta@gmail.com',
  );
  final _loginPasswordController = TextEditingController(text: '@Certiport08');
  final _examGroupController = TextEditingController();
  final _voucherController = TextEditingController();
  final _examSearchController = TextEditingController();
  final _proctorUsernameController = TextEditingController();
  final _proctorPasswordController = TextEditingController();

  String _language = 'English';
  PortalFlowStep _portalStep = PortalFlowStep.login;
  bool _hasExamGroup = false;
  bool _hasVoucher = false;
  String _assignedExamGroup = 'Select';
  String _assignedVoucher = 'Select';
  String _activeExamTab = 'search';
  String _selectedProgram = 'All programs';
  String _selectedExam = 'IC3 Digital Literacy GS6 Level 1';
  String _candidateEmail = 'alex.morgan@example.com';
  int _examSessionSeed = 0;
  bool _showLoginError = false;
  String? _verifyUnlockNoticeMessage;
  Timer? _preExamLandingTimer;
  PortalCatalog? _catalog;
  LoginResult? _loginResult;
  ExamStartData? _examStartData;
  ScoreReportData? _scoreReport;

  bool get _canProctorContinue =>
      _proctorUsernameController.text.trim().isNotEmpty &&
      _proctorPasswordController.text.trim().isNotEmpty;

  CompassCandidate? get _candidate => _loginResult?.candidate;

  CompassTestCenter? get _testCenter => _loginResult?.testCenter;

  CompassExam? get _selectedExamData {
    final exams = _catalog?.exams ?? const <CompassExam>[];
    for (final exam in exams) {
      if (exam.title == _selectedExam) {
        return exam;
      }
    }
    return exams.isEmpty ? null : exams.first;
  }

  String get _selectedExamDurationText {
    final durationMinutes = _selectedExamData?.durationMinutes ?? 50;
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:00';
  }

  Map<String, String> get _programOptions {
    final programs = _catalog?.programs ?? const <CompassProgram>[];
    return {
      'All programs': 'All programs',
      for (final program in programs) program.name: program.name,
    };
  }

  Map<String, String> get _assignedVoucherOptions {
    final vouchers = _loginResult?.vouchers ?? const <CompassVoucher>[];
    return {for (final voucher in vouchers) voucher.code: voucher.code};
  }

  List<String> get _examTitles {
    final exams = _catalog?.exams ?? const <CompassExam>[];
    if (exams.isEmpty) {
      return const [
        'IC3 Digital Literacy GS6 Level 1',
        'IC3 GS5 SR - Computing Fundamentals',
        'IC3 GS5 SR - Key Applications',
        'IC3 GS5 SR - Living Online',
      ];
    }
    return [for (final exam in exams) exam.title];
  }

  List<String> get _systemCheckLabels {
    final checks = _catalog?.systemChecks ?? const <SystemCheckData>[];
    if (checks.isEmpty) {
      return const [
        'User Admin',
        'Hardware Requirements',
        'Printer Driver',
        'Running Processes',
        'Exam Up to Date',
        'VBScript',
      ];
    }
    return [for (final check in checks) check.label];
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadCatalog());
  }

  @override
  void dispose() {
    _preExamLandingTimer?.cancel();
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    _examGroupController.dispose();
    _voucherController.dispose();
    _examSearchController.dispose();
    _proctorUsernameController.dispose();
    _proctorPasswordController.dispose();
    super.dispose();
  }

  void _goTo(PortalFlowStep step) {
    _preExamLandingTimer?.cancel();
    setState(() {
      _portalStep = step;
    });
  }

  void _showPreExamBlankBeforeLanding() {
    _preExamLandingTimer?.cancel();
    setState(() {
      _portalStep = PortalFlowStep.preExamBlank;
    });
    _preExamLandingTimer = Timer(_preExamLandingBlankDelay, () {
      if (!mounted || _portalStep != PortalFlowStep.preExamBlank) {
        return;
      }
      setState(() {
        _portalStep = PortalFlowStep.preExamLanding;
      });
    });
  }

  Future<void> _loadCatalog() async {
    try {
      final catalog = await context.read<PortalCubit>().loadCatalog();
      if (!mounted) {
        return;
      }
      setState(() {
        _catalog = catalog;
        if (!_examTitles.contains(_selectedExam) && catalog.exams.isNotEmpty) {
          _selectedExam = catalog.exams.first.title;
        }
      });
    } catch (error) {
      _showSnackBar(
        'Supabase catalog loading failed: ${friendlyErrorMessage(error)}',
      );
    }
  }

  void _goToPreviousPortalStep() {
    _preExamLandingTimer?.cancel();
    setState(() {
      _portalStep = switch (_portalStep) {
        PortalFlowStep.login => PortalFlowStep.login,
        PortalFlowStep.readiness => PortalFlowStep.login,
        PortalFlowStep.examSelect => PortalFlowStep.readiness,
        PortalFlowStep.verifyUnlock => PortalFlowStep.examSelect,
        PortalFlowStep.systemCheck => PortalFlowStep.verifyUnlock,
        PortalFlowStep.preExamBlank => PortalFlowStep.systemCheck,
        PortalFlowStep.preExamLanding => PortalFlowStep.systemCheck,
        PortalFlowStep.scoreSummary => PortalFlowStep.preExamLanding,
        PortalFlowStep.fullScoreReport => PortalFlowStep.scoreSummary,
      };
    });
  }

  Future<void> _startExam() async {
    await _ensureExamSession();
    setState(() {
      _examSessionSeed += 1;
    });
    await widget.onStartExam();
  }

  Future<void> _completeExam() async {
    if (context.read<ExamSessionCubit>().state.examStartData == null) {
      final report = _fallbackScoreReport();
      context.read<ScoreReportCubit>().setReport(report);
      setState(() {
        _scoreReport = report;
        _candidateEmail = report.candidate.email;
        _portalStep = PortalFlowStep.scoreSummary;
      });
      await widget.onExitSecureWorkspace();
      return;
    }

    try {
      context.read<ScoreReportCubit>().setLoading();
      final report = await context.read<ExamSessionCubit>().finishExam();
      if (!mounted) {
        return;
      }
      context.read<ScoreReportCubit>().setReport(report);
      setState(() {
        _scoreReport = report;
        _candidateEmail = report.candidate.email;
        _portalStep = PortalFlowStep.scoreSummary;
      });
      await widget.onExitSecureWorkspace();
    } catch (error) {
      if (!mounted) {
        return;
      }
      context.read<ScoreReportCubit>().setError(error);
      _showSnackBar(
        'Could not finish exam session: ${friendlyErrorMessage(error)}',
      );
    }
  }

  ScoreReportData _fallbackScoreReport() {
    final exam =
        _selectedExamData ??
        const CompassExam(
          id: 'local-exam',
          programId: 'ic3',
          title: 'IC3 Digital Literacy GS6 Level 1',
          shortTitle: 'IC3 GS6 Level 1',
          code: 'IC3-GS6-L1-2026',
          durationMinutes: 50,
          questionCount: 45,
          passScore: 700,
          language: 'English',
        );
    final candidate =
        _candidate ??
        CompassCandidate(
          id: 'local-candidate',
          username: _loginUsernameController.text.trim(),
          email: _candidateEmail,
          displayName: 'Alex Morgan',
          candidateIdentifier: 'CP-842916',
          score: 700,
          addressLine1: '41 Amir Temur Street',
          addressLine2: 'Office 1205',
          city: 'Tashkent',
          postalCode: '100000',
          country: 'Uzbekistan',
        );
    final testCenter =
        _testCenter ??
        const CompassTestCenter(
          id: 'local-test-center',
          name: 'Edu Action LLC.',
          code: '90087882',
        );
    final candidateScore = candidate.score;
    return ScoreReportData(
      sessionId: 'local-session',
      requiredScore: exam.passScore,
      candidateScore: candidateScore,
      outcome: candidateScore >= exam.passScore ? 'Pass' : 'Fail',
      sectionScores: const [
        SectionScoreData(name: 'Technology Basics', score: 72),
        SectionScoreData(name: 'Digital Citizenship', score: 68),
        SectionScoreData(name: 'Information Management', score: 71),
        SectionScoreData(name: 'Content Creation', score: 69),
        SectionScoreData(name: 'Communication', score: 73),
        SectionScoreData(name: 'Collaboration', score: 70),
        SectionScoreData(name: 'Security', score: 71),
      ],
      candidate: candidate,
      exam: exam,
      testCenter: testCenter,
      pathways: _catalog?.pathways ?? const [],
    );
  }

  Future<void> _login() async {
    setState(() {
      _showLoginError = false;
    });

    late final LoginResult result;
    try {
      result = await context.read<AuthCubit>().login(
        username: _loginUsernameController.text.trim(),
        password: _loginPasswordController.text,
      );
      if (!mounted) {
        return;
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _showLoginError = true;
      });
      return;
    }

    await _loadCatalog();
    if (!mounted) {
      return;
    }
    setState(() {
      _loginResult = result;
      _candidateEmail = result.candidate.email;
      _portalStep = PortalFlowStep.readiness;
      _showLoginError = false;
    });
  }

  Future<void> _goToExamSelect() async {
    final candidate = _candidate;
    final voucherCode = _voucherController.text.trim();
    if (candidate != null && voucherCode.isNotEmpty) {
      final validation = await context.read<PortalCubit>().validateVoucher(
        candidateId: candidate.id,
        voucherCode: voucherCode,
      );
      if (!validation.valid) {
        _showSnackBar(validation.message ?? 'Voucher validation failed.');
        return;
      }
    }
    _goTo(PortalFlowStep.examSelect);
  }

  Future<void> _ensureExamSession() async {
    if (_examStartData != null) {
      return;
    }
    final candidate = _candidate;
    final exam = _selectedExamData;
    if (candidate == null || exam == null) {
      return;
    }
    final data = await context.read<ExamSessionCubit>().startSession(
      candidateId: candidate.id,
      examId: exam.id,
      voucherCode: _voucherController.text.trim().isEmpty
          ? null
          : _voucherController.text.trim(),
    );
    if (mounted) {
      setState(() {
        _examStartData = data;
      });
    }
  }

  Future<void> _unlockExam() async {
    try {
      await _ensureExamSession();
      if (!mounted) {
        return;
      }
      final unlocked = await context.read<ExamSessionCubit>().unlock(
        proctorUsername: _proctorUsernameController.text.trim(),
        proctorPassword: _proctorUnlockPassword,
      );
      if (!mounted) {
        return;
      }
      if (!unlocked) {
        setState(() {
          _verifyUnlockNoticeMessage = _verifyUnlockInvalidProctorNotice;
        });
        return;
      }
      setState(() {
        _verifyUnlockNoticeMessage = null;
      });
      _goTo(PortalFlowStep.systemCheck);
    } catch (error) {
      setState(() {
        _verifyUnlockNoticeMessage =
            'Could not unlock exam: ${friendlyErrorMessage(error)}';
      });
    }
  }

  void _persistQuestion(ExamQuestion question) {
    unawaited(
      context.read<ExamSessionCubit>().saveAnswer(question).catchError((error) {
        _showSnackBar('Could not save answer: ${friendlyErrorMessage(error)}');
      }),
    );
  }

  void _persistFeedback(String feedback) {
    unawaited(
      context.read<ExamSessionCubit>().saveFeedback(feedback).catchError((
        error,
      ) {
        _showSnackBar(
          'Could not save feedback: ${friendlyErrorMessage(error)}',
        );
      }),
    );
  }

  void _clearVoucher() {
    setState(() {
      _hasVoucher = false;
      _assignedVoucher = 'Select';
      _voucherController.clear();
    });
  }

  void _clearExamGroup() {
    setState(() {
      _hasExamGroup = false;
      _assignedExamGroup = 'Select';
      _examGroupController.clear();
    });
  }

  Widget _buildPortalScreen() {
    return switch (_portalStep) {
      PortalFlowStep.login => LoginScreen(
        usernameController: _loginUsernameController,
        passwordController: _loginPasswordController,
        onLogin: () => unawaited(_login()),
        showInvalidLogin: _showLoginError,
      ),
      PortalFlowStep.readiness => ReadinessScreen(
        userName:
            _candidate?.displayName ?? _loginUsernameController.text.trim(),
        hasExamGroup: _hasExamGroup,
        hasVoucher: _hasVoucher,
        assignedExamGroup: _assignedExamGroup,
        assignedVoucher: _assignedVoucher,
        examGroupController: _examGroupController,
        assignedVoucherOptions: _assignedVoucherOptions,
        voucherController: _voucherController,
        onExamGroupChanged: (value) {
          if (!value) {
            _clearExamGroup();
            return;
          }
          setState(() => _hasExamGroup = true);
        },
        onAssignedExamGroupChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() => _assignedExamGroup = value);
        },
        onExamGroupInputChanged: (value) {
          setState(() {
            final upperValue = value.toUpperCase();
            if (_examGroupController.text != upperValue) {
              _examGroupController.text = upperValue;
              _examGroupController.selection = TextSelection.collapsed(
                offset: upperValue.length,
              );
            }
          });
        },
        onVoucherChanged: (value) {
          if (!value) {
            _clearVoucher();
            return;
          }
          setState(() => _hasVoucher = true);
        },
        onAssignedVoucherChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _assignedVoucher = value;
            if (value == 'Select') {
              _voucherController.clear();
            } else {
              _voucherController.text = value;
            }
          });
        },
        onVoucherInputChanged: (value) {
          setState(() {
            final upperValue = value.toUpperCase();
            if (_voucherController.text != upperValue) {
              _voucherController.text = upperValue;
              _voucherController.selection = TextSelection.collapsed(
                offset: upperValue.length,
              );
            }
          });
        },
        onPrevious: _goToPreviousPortalStep,
        onNext: () => unawaited(_goToExamSelect()),
      ),
      PortalFlowStep.examSelect => ExamSelectScreen(
        activeTab: _activeExamTab,
        program: _selectedProgram,
        programOptions: _programOptions,
        examTitles: _examTitles,
        searchController: _examSearchController,
        voucherCode: _voucherController.text,
        selectedExam: _selectedExam,
        onTabChanged: (value) => setState(() => _activeExamTab = value),
        onProgramChanged: (value) {
          if (value != null) {
            setState(() => _selectedProgram = value);
          }
        },
        onSelectExam: (exam) {
          setState(() {
            _selectedExam = exam;
            _verifyUnlockNoticeMessage = null;
            _portalStep = PortalFlowStep.verifyUnlock;
          });
        },
        onPrevious: _goToPreviousPortalStep,
      ),
      PortalFlowStep.verifyUnlock => VerifyUnlockScreen(
        language: _language,
        selectedExam: _selectedExam,
        voucherCode: _voucherController.text,
        candidateName: _candidate?.displayName ?? 'Ism\nFamiliya',
        testCenterName: _testCenter?.name ?? 'Edu Action LLC.',
        durationText: _selectedExamDurationText,
        proctorUsernameController: _proctorUsernameController,
        proctorPasswordController: _proctorPasswordController,
        canContinue: _canProctorContinue,
        noticeMessage: _verifyUnlockNoticeMessage ?? _verifyUnlockDefaultNotice,
        onProctorChanged: (_) {
          setState(() {
            _verifyUnlockNoticeMessage = null;
          });
        },
        onPrevious: _goToPreviousPortalStep,
        onContinue: () => unawaited(_unlockExam()),
      ),
      PortalFlowStep.systemCheck => SystemCheckScreen(
        selectedExam: _selectedExam,
        checkLabels: _systemCheckLabels,
        onPrevious: _goToPreviousPortalStep,
        onNext: _showPreExamBlankBeforeLanding,
      ),
      PortalFlowStep.preExamBlank => const ColoredBox(color: Colors.white),
      PortalFlowStep.preExamLanding => PreExamLandingScreen(
        selectedExam: _selectedExam,
        userName:
            _candidate?.displayName ?? _loginUsernameController.text.trim(),
        durationMinutes: _selectedExamData?.durationMinutes ?? 50,
        questionCount: _selectedExamData?.questionCount ?? 45,
        passScore: _selectedExamData?.passScore ?? 700,
        onCloseWindow: widget.onCloseWindow,
        onStartExam: _startExam,
      ),
      PortalFlowStep.scoreSummary => ScoreSummaryScreen(
        selectedExam: _selectedExam,
        email: _candidateEmail,
        scoreReport: _scoreReport,
        pathways: _scoreReport?.pathways ?? _catalog?.pathways,
        onViewFullScoreReport: () {},
      ),
      PortalFlowStep.fullScoreReport => FullScoreReportScreen(
        scoreReport: _scoreReport,
      ),
    };
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final portalScreen = _buildPortalScreen();
    final fullScoreReport = _portalStep == PortalFlowStep.fullScoreReport;
    final customPortalShell =
        _portalStep == PortalFlowStep.preExamBlank ||
        _portalStep == PortalFlowStep.preExamLanding;

    return LockdownShell(
      examLockdownMode: widget.examLockdownMode,
      enteringSecureExam: widget.enteringSecureExam,
      portalChild: fullScoreReport || customPortalShell
          ? portalScreen
          : PortalShell(
              language: _language,
              showUserControls:
                  _portalStep != PortalFlowStep.login &&
                  _portalStep != PortalFlowStep.scoreSummary,
              showLanguageSelector: _portalStep == PortalFlowStep.login,
              compactFooter: _portalStep == PortalFlowStep.scoreSummary,
              shrinkWrapContent: _portalStep == PortalFlowStep.systemCheck,
              userName: _candidate?.displayName ?? 'Certiport Uzbekistan',
              onLanguageChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _language = value;
                });
              },
              onCloseWindow: widget.onCloseWindow,
              child: portalScreen,
            ),
      examChild: ExamFlow(
        key: ValueKey(_examSessionSeed),
        selectedExam: _selectedExam,
        questions: _examStartData?.questions,
        surveySections: _examStartData?.surveySections ?? const [],
        onQuestionChanged: _persistQuestion,
        onFeedbackSubmitted: _persistFeedback,
        onBlockedExit: () => widget.onBlockedExit(),
        onExamCompleted: _completeExam,
        timerConfig: widget.examTimerConfig,
      ),
    );
  }
}
