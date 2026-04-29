import 'package:flutter/material.dart';

import 'compass_shells.dart';
import 'exam/exam_flow.dart';
import 'portal_flow.dart';

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
  final _addressLine1Controller = TextEditingController(
    text: 'Ziyolilar ko\'chasi, 9-uy',
  );
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController(text: 'Tashkent');
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _voucherController = TextEditingController();
  final _examSearchController = TextEditingController();
  final _proctorUsernameController = TextEditingController();
  final _proctorPasswordController = TextEditingController();

  String _language = 'English';
  PortalFlowStep _portalStep = PortalFlowStep.login;
  bool _hasExamGroup = false;
  bool _hasVoucher = false;
  String _assignedVoucher = 'Select';
  String _activeExamTab = 'search';
  String _selectedProgram = 'All programs';
  String _selectedExam = 'IC3 Digital Literacy GS6 Level 1';
  String _candidateEmail = 'alex.morgan@example.com';
  String _agreement = 'no';
  int _examSessionSeed = 0;

  bool get _canProctorContinue =>
      _proctorUsernameController.text.trim().isNotEmpty &&
      _proctorPasswordController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _voucherController.dispose();
    _examSearchController.dispose();
    _proctorUsernameController.dispose();
    _proctorPasswordController.dispose();
    super.dispose();
  }

  void _goTo(PortalFlowStep step) {
    setState(() {
      _portalStep = step;
    });
  }

  void _goToPreviousPortalStep() {
    setState(() {
      _portalStep = switch (_portalStep) {
        PortalFlowStep.login => PortalFlowStep.login,
        PortalFlowStep.address => PortalFlowStep.login,
        PortalFlowStep.readiness => PortalFlowStep.address,
        PortalFlowStep.examSelect => PortalFlowStep.readiness,
        PortalFlowStep.nda => PortalFlowStep.examSelect,
        PortalFlowStep.verifyUnlock => PortalFlowStep.nda,
        PortalFlowStep.systemCheck => PortalFlowStep.verifyUnlock,
        PortalFlowStep.preExamLanding => PortalFlowStep.systemCheck,
        PortalFlowStep.scoreSummary => PortalFlowStep.preExamLanding,
        PortalFlowStep.fullScoreReport => PortalFlowStep.scoreSummary,
      };
    });
  }

  Future<void> _startExam() async {
    setState(() {
      _examSessionSeed += 1;
    });
    await widget.onStartExam();
  }

  Future<void> _completeExam() async {
    setState(() {
      _portalStep = PortalFlowStep.scoreSummary;
    });
    await widget.onExitSecureWorkspace();
  }

  void _clearVoucher() {
    setState(() {
      _hasVoucher = false;
      _assignedVoucher = 'Select';
      _voucherController.clear();
    });
  }

  Widget _buildPortalScreen() {
    return switch (_portalStep) {
      PortalFlowStep.login => LoginScreen(
        usernameController: _loginUsernameController,
        passwordController: _loginPasswordController,
        onLogin: () {
          final loginEmail = _loginUsernameController.text.trim();
          if (loginEmail.isNotEmpty) {
            _candidateEmail = loginEmail;
          }
          _goTo(PortalFlowStep.address);
        },
      ),
      PortalFlowStep.address => MailingAddressScreen(
        addressLine1Controller: _addressLine1Controller,
        addressLine2Controller: _addressLine2Controller,
        cityController: _cityController,
        stateController: _stateController,
        postalCodeController: _postalCodeController,
        onContinue: () => _goTo(PortalFlowStep.readiness),
        onCancel: _goToPreviousPortalStep,
      ),
      PortalFlowStep.readiness => ReadinessScreen(
        hasExamGroup: _hasExamGroup,
        hasVoucher: _hasVoucher,
        assignedVoucher: _assignedVoucher,
        voucherController: _voucherController,
        onExamGroupChanged: (value) => setState(() => _hasExamGroup = value),
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
        onNext: () => _goTo(PortalFlowStep.examSelect),
      ),
      PortalFlowStep.examSelect => ExamSelectScreen(
        activeTab: _activeExamTab,
        program: _selectedProgram,
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
            _agreement = 'no';
            _portalStep = PortalFlowStep.nda;
          });
        },
        onRemoveVoucher: _clearVoucher,
        onPrevious: _goToPreviousPortalStep,
      ),
      PortalFlowStep.nda => NdaScreen(
        agreement: _agreement,
        onAgreementChanged: (value) {
          if (value != null) {
            setState(() => _agreement = value);
          }
        },
        onPrevious: _goToPreviousPortalStep,
        onNext: () => _goTo(PortalFlowStep.verifyUnlock),
      ),
      PortalFlowStep.verifyUnlock => VerifyUnlockScreen(
        language: _language,
        selectedExam: _selectedExam,
        voucherCode: _voucherController.text,
        proctorUsernameController: _proctorUsernameController,
        proctorPasswordController: _proctorPasswordController,
        canContinue: _canProctorContinue,
        onProctorChanged: (_) => setState(() {}),
        onPrevious: _goToPreviousPortalStep,
        onContinue: () => _goTo(PortalFlowStep.systemCheck),
      ),
      PortalFlowStep.systemCheck => SystemCheckScreen(
        selectedExam: _selectedExam,
        onPrevious: _goToPreviousPortalStep,
        onNext: () => _goTo(PortalFlowStep.preExamLanding),
      ),
      PortalFlowStep.preExamLanding => PreExamLandingScreen(
        selectedExam: _selectedExam,
        onCloseWindow: widget.onCloseWindow,
        onStartExam: _startExam,
      ),
      PortalFlowStep.scoreSummary => ScoreSummaryScreen(
        selectedExam: _selectedExam,
        email: _candidateEmail,
        onEmailChanged: (value) => setState(() => _candidateEmail = value),
        onViewFullScoreReport: () => _goTo(PortalFlowStep.fullScoreReport),
      ),
      PortalFlowStep.fullScoreReport => const FullScoreReportScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final portalScreen = _buildPortalScreen();
    final fullScoreReport = _portalStep == PortalFlowStep.fullScoreReport;
    final customPortalShell =
        _portalStep == PortalFlowStep.address ||
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
              userName: 'Certiport Uzbekistan',
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
        onBlockedExit: () => widget.onBlockedExit(),
        onExamCompleted: _completeExam,
        timerConfig: widget.examTimerConfig,
      ),
    );
  }
}
