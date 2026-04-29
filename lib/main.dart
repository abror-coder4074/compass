import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/compass_components.dart';
import 'ui/compass_shells.dart';
import 'ui/compass_theme.dart';

const Size _normalWindowSize = Size(1280, 800);
const Size _minimumWindowSize = Size(1024, 700);

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

    await _handleBlockedWindowAttempt(
      title: 'Exam in progress',
      message:
          'Compass cannot be closed after the exam workspace is active. Finish '
          'the exam or wait for the timer to expire before exiting.',
    );
  }

  @override
  void onWindowMinimize() {
    if (_examLockdownMode) {
      _handleBlockedWindowAttempt(
        title: 'Secure exam is active',
        message:
            'The exam window must remain visible while the exam is in progress.',
      );
    }
  }

  @override
  void onWindowLeaveFullScreen() {
    if (_examLockdownMode) {
      _handleBlockedWindowAttempt(
        title: 'Secure exam is active',
        message:
            'Compass keeps the exam workspace fullscreen until the exam is '
            'finished or timed out.',
      );
    }
  }

  Future<void> _handleBlockedWindowAttempt({
    required String title,
    required String message,
  }) async {
    await windowManager.restore();
    await windowManager.setFullScreen(true);
    await windowManager.focus();
    await _showLockdownNotice(title: title, message: message);
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
            title: title ?? 'Secure exam is active',
            message:
                message ??
                'This action is unavailable while the exam is running. Use the '
                    'exam finish or timeout flow to leave the secure workspace.',
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
        onFinishExam: _exitExamLockdownMode,
        onCloseWindow: _showExitSimulation,
        onBlockedExit: _showLockdownNotice,
      ),
    );
  }
}

class CompassHome extends StatefulWidget {
  const CompassHome({
    required this.examLockdownMode,
    required this.onStartExam,
    required this.onFinishExam,
    required this.onCloseWindow,
    required this.onBlockedExit,
    this.enteringSecureExam = false,
    super.key,
  });

  final bool examLockdownMode;
  final bool enteringSecureExam;
  final Future<void> Function() onStartExam;
  final Future<void> Function() onFinishExam;
  final Future<void> Function() onCloseWindow;
  final LockdownNoticeCallback onBlockedExit;

  @override
  State<CompassHome> createState() => _CompassHomeState();
}

class _CompassHomeState extends State<CompassHome> {
  String _language = 'English';
  bool _hasExamGroup = false;
  bool _hasVoucher = true;
  bool _rememberAccount = true;
  String _agreement = 'yes';
  String _paymentType = 'Voucher';
  int _examPreviewStep = 0;

  Future<void> _showReviewNotice() {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CompassModalDialog(
          icon: Icons.info_outline,
          title: 'Candidate notice',
          message:
              'Candidate information, exam selection, terms, proctor unlock, '
              'system check, and exam engine screens will reuse this shell and '
              'component set in the next phases.',
          actions: [
            CompassPrimaryButton(
              label: 'OK',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final examTitles = ['Survey 1 of 1', 'Tutorial', 'Question 1 of 45'];

    return LockdownShell(
      examLockdownMode: widget.examLockdownMode,
      enteringSecureExam: widget.enteringSecureExam,
      portalChild: PortalShell(
        language: _language,
        onLanguageChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _language = value;
          });
        },
        onCloseWindow: widget.onCloseWindow,
        child: _PortalFoundationPreview(
          language: _language,
          hasExamGroup: _hasExamGroup,
          hasVoucher: _hasVoucher,
          rememberAccount: _rememberAccount,
          agreement: _agreement,
          paymentType: _paymentType,
          onLanguageChanged: (value) {
            if (value != null) {
              setState(() => _language = value);
            }
          },
          onExamGroupChanged: (value) => setState(() => _hasExamGroup = value),
          onVoucherChanged: (value) => setState(() => _hasVoucher = value),
          onRememberChanged: (value) =>
              setState(() => _rememberAccount = value),
          onAgreementChanged: (value) {
            if (value != null) {
              setState(() => _agreement = value);
            }
          },
          onPaymentTypeChanged: (value) {
            if (value != null) {
              setState(() => _paymentType = value);
            }
          },
          onReviewNotice: _showReviewNotice,
          onStartExam: widget.onStartExam,
        ),
      ),
      examChild: ExamEngineShell(
        title: examTitles[_examPreviewStep],
        lockdownMode: widget.examLockdownMode,
        onBlockedExit: () => widget.onBlockedExit(
          title: 'Secure exam is active',
          message:
              'Logout and Close Window actions are blocked until the exam is '
              'finished or the timer expires.',
        ),
        secondaryLabel: 'Finish Exam',
        onSecondaryPressed: () {
          widget.onFinishExam();
          setState(() {
            _examPreviewStep = 0;
          });
        },
        primaryLabel: 'Next',
        onPrimaryPressed: () {
          setState(() {
            _examPreviewStep = (_examPreviewStep + 1) % examTitles.length;
          });
        },
        child: _ExamFoundationPreview(step: _examPreviewStep),
      ),
    );
  }
}

class _PortalFoundationPreview extends StatelessWidget {
  const _PortalFoundationPreview({
    required this.language,
    required this.hasExamGroup,
    required this.hasVoucher,
    required this.rememberAccount,
    required this.agreement,
    required this.paymentType,
    required this.onLanguageChanged,
    required this.onExamGroupChanged,
    required this.onVoucherChanged,
    required this.onRememberChanged,
    required this.onAgreementChanged,
    required this.onPaymentTypeChanged,
    required this.onReviewNotice,
    required this.onStartExam,
  });

  final String language;
  final bool hasExamGroup;
  final bool hasVoucher;
  final bool rememberAccount;
  final String agreement;
  final String paymentType;
  final ValueChanged<String?> onLanguageChanged;
  final ValueChanged<bool> onExamGroupChanged;
  final ValueChanged<bool> onVoucherChanged;
  final ValueChanged<bool> onRememberChanged;
  final ValueChanged<String?> onAgreementChanged;
  final ValueChanged<String?> onPaymentTypeChanged;
  final VoidCallback onReviewNotice;
  final Future<void> Function() onStartExam;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 28, 42, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome Certiport, let\'s get ready for your exam!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 980;
              final blocks = [
                _ReadinessBlock(
                  title: 'Do you have an Exam Group ID today?',
                  example: 'Example Exam Group ID: xxxxx',
                  value: hasExamGroup,
                  onChanged: onExamGroupChanged,
                  input: hasExamGroup
                      ? const CompassTextInput(
                          label: 'Exam Group ID',
                          initialValue: 'IC3-2026',
                        )
                      : null,
                ),
                _ReadinessBlock(
                  title: 'Do you have a Voucher to use for payment today?',
                  example: 'Example Voucher: xxxx-xxxx-xxxx-xxxx',
                  value: hasVoucher,
                  onChanged: onVoucherChanged,
                  input: hasVoucher
                      ? const CompassTextInput(
                          label: 'Voucher',
                          initialValue: 'IC3G-2026-DEMO-7821',
                        )
                      : null,
                ),
              ];

              if (compact) {
                return Column(
                  children: [
                    blocks.first,
                    const SizedBox(height: 22),
                    blocks.last,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: blocks.first),
                  const SizedBox(width: 44),
                  Expanded(child: blocks.last),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          CompassInfoCard(
            tone: CompassInfoTone.warning,
            title:
                'Candidate, please verify that the following information is correct.',
            message:
                'Notify the proctor when you are ready to proceed to exam authorization.',
          ),
          const SizedBox(height: 24),
          CompassPanel(
            title: 'Candidate & Exam Information',
            child: CompassTable(
              columns: const [
                'Name',
                'Exam details',
                'Test center',
                'Payment type',
              ],
              rows: [
                [
                  'Alex Morgan',
                  'IC3 Digital Literacy GS6 Level 1',
                  'Edu Action LLC.',
                  paymentType,
                ],
                [
                  'alex.morgan@example.com',
                  'Language: $language',
                  'Tashkent',
                  'Scheduled',
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 1050;
              final account = CompassPanel(
                title: 'Account Details',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, fieldConstraints) {
                        final narrow = fieldConstraints.maxWidth < 560;
                        final fields = [
                          const CompassTextInput(
                            label: 'Username',
                            initialValue: 'alex.morgan@example.com',
                            prefixIcon: Icons.person_outline,
                          ),
                          const CompassTextInput(
                            label: 'Password',
                            initialValue: 'Certiport08',
                            obscureText: true,
                            prefixIcon: Icons.lock_outline,
                          ),
                        ];
                        if (narrow) {
                          return Column(
                            children: [
                              fields.first,
                              const SizedBox(height: 14),
                              fields.last,
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: fields.first),
                            const SizedBox(width: 16),
                            Expanded(child: fields.last),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CompassSelect<String>(
                      label: 'Language',
                      value: language,
                      items: const {
                        'English': 'English',
                        'Uzbek': 'Uzbek',
                        'Russian': 'Russian',
                      },
                      onChanged: onLanguageChanged,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CompassToggle(
                          value: rememberAccount,
                          activeLabel: 'On',
                          inactiveLabel: 'Off',
                          onChanged: onRememberChanged,
                        ),
                        const SizedBox(width: 12),
                        const Text('Remember this account'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const CompassPrimaryButton(
                      label: 'Disabled',
                      onPressed: null,
                    ),
                  ],
                ),
              );

              final agreementPanel = CompassPanel(
                title: 'Candidate Agreement',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CompassScrollablePanel(
                      child: Text(
                        'Certification exam content is confidential. By continuing, '
                        'you agree to follow all candidate rules, keep exam content '
                        'private, and complete the exam under proctor supervision.\n\n'
                        'Voucher codes are case-sensitive and must be entered with '
                        'dashes. Candidate data shown in this prototype is mock data '
                        'for presentation purposes.\n\n'
                        'The secure exam workspace begins after Start Secure Exam. '
                        'Pre-exam screens keep normal window controls available.',
                        style: TextStyle(fontSize: 14, height: 1.45),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 18,
                      children: [
                        CompassRadioOption<String>(
                          value: 'yes',
                          groupValue: agreement,
                          label: 'Yes, I accept',
                          onChanged: onAgreementChanged,
                        ),
                        CompassRadioOption<String>(
                          value: 'no',
                          groupValue: agreement,
                          label: 'No',
                          onChanged: onAgreementChanged,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CompassSelect<String>(
                      label: 'Payment type',
                      value: paymentType,
                      items: const {
                        'Voucher': 'Voucher',
                        'Exam Group': 'Exam Group',
                        'Site License': 'Site License',
                      },
                      onChanged: onPaymentTypeChanged,
                    ),
                  ],
                ),
              );

              if (compact) {
                return Column(
                  children: [
                    account,
                    const SizedBox(height: 24),
                    agreementPanel,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: account),
                  const SizedBox(width: 24),
                  Expanded(child: agreementPanel),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _LandingPreview(onStartExam: onStartExam),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CompassSecondaryButton(
                label: 'Review Notice',
                icon: Icons.info_outline,
                onPressed: onReviewNotice,
              ),
              const SizedBox(width: 12),
              CompassSecondaryButton(
                label: 'Previous',
                icon: Icons.arrow_back,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              CompassPrimaryButton(
                label: 'Next',
                icon: Icons.arrow_forward,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadinessBlock extends StatelessWidget {
  const _ReadinessBlock({
    required this.title,
    required this.example,
    required this.value,
    required this.onChanged,
    this.input,
  });

  final String title;
  final String example;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? input;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Text(
          'Please make a selection below and then click "Next" to continue.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
        Text(example, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 18),
        CompassToggle(value: value, onChanged: onChanged),
        if (input != null) ...[const SizedBox(height: 16), input!],
      ],
    );
  }
}

class _LandingPreview extends StatelessWidget {
  const _LandingPreview({required this.onStartExam});

  final Future<void> Function() onStartExam;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CompassColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;
          final details = Container(
            color: CompassColors.examNavy,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(CompassAssets.ic3Logo, width: 130),
                const SizedBox(height: 28),
                const Text(
                  'Welcome, Certiport!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'IC3 Digital Literacy GS6 Level 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Maximum exam time: 50 minutes\n'
                  'Number of exam questions: 45\n'
                  'Minimum score required to pass exam: 700',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
                const Spacer(),
                CompassPrimaryButton(
                  label: 'Start Secure Exam',
                  tone: CompassButtonTone.exam,
                  icon: Icons.play_arrow,
                  onPressed: () {
                    onStartExam();
                  },
                ),
              ],
            ),
          );

          final photo = Image.asset(
            CompassAssets.examLandingPhoto,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 360, child: details),
                SizedBox(height: 360, child: photo),
              ],
            );
          }

          return SizedBox(
            height: 430,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 360, child: details),
                Expanded(child: photo),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExamFoundationPreview extends StatefulWidget {
  const _ExamFoundationPreview({required this.step});

  final int step;

  @override
  State<_ExamFoundationPreview> createState() => _ExamFoundationPreviewState();
}

class _ExamFoundationPreviewState extends State<_ExamFoundationPreview> {
  final Set<int> _selectedSurveyCards = {1};
  String _questionAnswer = 'b';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 34),
      child: switch (widget.step) {
        0 => _buildSurvey(),
        1 => _buildTutorial(),
        _ => _buildQuestion(),
      },
    );
  }

  Widget _buildSurvey() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Please tell us about your experience with Digital Literacy by answering the questions in the answer area.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        const Text(
          'Answer Area',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        _SurveySection(
          color: CompassColors.examNavy,
          title:
              'Select the statement that best describes the courses you have taken that cover Digital Literacy.',
          children: [
            _surveyCard(
              0,
              'I have not taken a course that covers Digital Literacy.',
            ),
            _surveyCard(
              1,
              'I am beginning my first course that covers Digital Literacy.',
            ),
            _surveyCard(
              2,
              'I have completed or nearly completed my first course.',
            ),
            _surveyCard(
              3,
              'I have completed multiple courses that cover Digital Literacy.',
            ),
          ],
        ),
        _SurveySection(
          color: const Color(0xFF078C3B),
          title:
              'Select all types of resources you used to prepare for the exam.',
          children: [
            _surveyCard(4, 'Online learning or video'),
            _surveyCard(5, 'Instructor-led learning'),
            _surveyCard(6, 'Hands-on practice or labs'),
            _surveyCard(7, 'Practice tests'),
          ],
        ),
        _SurveySection(
          color: const Color(0xFF1AADAA),
          title:
              'Select all statements that describe how you use your Digital Literacy skills.',
          children: [
            _surveyCard(8, 'I am studying Digital Literacy for class.'),
            _surveyCard(
              9,
              'I use my Digital Literacy skills non-professionally.',
            ),
            _surveyCard(10, 'I use my Digital Literacy skills professionally.'),
            _surveyCard(11, 'I teach others Digital Literacy.'),
          ],
        ),
      ],
    );
  }

  Widget _surveyCard(int id, String text) {
    final selected = _selectedSurveyCards.contains(id);
    return InkWell(
      onTap: () {
        setState(() {
          if (selected) {
            _selectedSurveyCards.remove(id);
          } else {
            _selectedSurveyCards.add(id);
          }
        });
      },
      child: Container(
        width: 250,
        height: 72,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF5F8) : const Color(0xFFE4E7E8),
          border: Border.all(
            color: selected
                ? CompassColors.certiportTeal
                : const Color(0xFFC6CACC),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildTutorial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Image.asset(CompassAssets.ic3Logo, width: 120),
            const SizedBox(width: 24),
            const Expanded(
              child: Text(
                'IC3 Digital Literacy Certification',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CompassInfoCard(
          tone: CompassInfoTone.info,
          title: 'Tutorial',
          message:
              'The timer starts after the tutorial. Review the navigation controls and continue when ready.',
        ),
        const SizedBox(height: 20),
        const CompassScrollablePanel(
          height: 300,
          child: Text(
            'Use Back and Next to move between questions. The Tools menu remains '
            'available at the bottom left. Mark for Review and feedback controls '
            'will appear in the question workspace.\n\n'
            'During the secure exam phase, Compass remains fullscreen. Attempts '
            'to close, minimize, resize, or sign out display an informational '
            'lockdown message instead of terminating the app.\n\n'
            'This prototype does not install OS-level hooks or close other '
            'applications. It presents the secure browser behavior visually.',
            style: TextStyle(fontSize: 16, height: 1.45),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Question 1 of 45',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: CompassColors.border),
                color: const Color(0xFFF7F8F9),
              ),
              child: const Text(
                'Time Remaining: 49:12',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ClipRRect(
          child: LinearProgressIndicator(
            value: 1 / 45,
            minHeight: 9,
            color: CompassColors.certiportTeal,
            backgroundColor: const Color(0xFFE0E0E0),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Which action best protects a candidate account before launching an exam?',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 18),
        CompassRadioOption<String>(
          value: 'a',
          groupValue: _questionAnswer,
          label: 'Share the voucher with another candidate.',
          onChanged: (value) => setState(() => _questionAnswer = value ?? 'a'),
        ),
        CompassRadioOption<String>(
          value: 'b',
          groupValue: _questionAnswer,
          label: 'Use the assigned login and keep the password private.',
          onChanged: (value) => setState(() => _questionAnswer = value ?? 'b'),
        ),
        CompassRadioOption<String>(
          value: 'c',
          groupValue: _questionAnswer,
          label: 'Skip proctor verification when the exam is ready.',
          onChanged: (value) => setState(() => _questionAnswer = value ?? 'c'),
        ),
      ],
    );
  }
}

class _SurveySection extends StatelessWidget {
  const _SurveySection({
    required this.color,
    required this.title,
    required this.children,
  });

  final Color color;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: const Color(0xFF969696)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 14, runSpacing: 14, children: children),
        ],
      ),
    );
  }
}
