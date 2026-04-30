import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';
import 'portal_shared.dart';

class VerifyUnlockScreen extends StatelessWidget {
  const VerifyUnlockScreen({
    required this.language,
    required this.selectedExam,
    required this.voucherCode,
    required this.proctorUsernameController,
    required this.proctorPasswordController,
    required this.canContinue,
    required this.onProctorChanged,
    required this.onPrevious,
    required this.onContinue,
    this.candidateName = 'Ism\nFamiliya',
    this.testCenterName = 'Edu Action LLC.',
    this.durationText = '00:50:00',
    this.examGroup = 'None',
    super.key,
  });

  final String language;
  final String selectedExam;
  final String voucherCode;
  final TextEditingController proctorUsernameController;
  final TextEditingController proctorPasswordController;
  final bool canContinue;
  final ValueChanged<String> onProctorChanged;
  final VoidCallback onPrevious;
  final VoidCallback onContinue;
  final String candidateName;
  final String testCenterName;
  final String durationText;
  final String examGroup;

  @override
  Widget build(BuildContext context) {
    final voucher = voucherCode.trim();
    final paymentType = voucher.isEmpty ? 'No voucher' : 'Voucher';
    final examTitle = _shortExamTitle(selectedExam);

    return Padding(
      padding: const EdgeInsets.fromLTRB(55, 17, 55, 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verify & Unlock Exam',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 16),
          const _VerifyNotice(),
          const SizedBox(height: 24),
          _CandidateExamInformation(
            examTitle: examTitle,
            language: language,
            paymentType: paymentType,
            candidateName: candidateName,
            testCenterName: testCenterName,
            durationText: durationText,
            examGroup: examGroup,
          ),
          const SizedBox(height: 38),
          const _ReadyForProctorLine(),
          const SizedBox(height: 12),
          _ProctorAuthenticationPanel(
            usernameController: proctorUsernameController,
            passwordController: proctorPasswordController,
            onChanged: onProctorChanged,
          ),
          const SizedBox(height: 28),
          PortalActionRow(
            children: [
              CompassSecondaryButton(label: 'Previous', onPressed: onPrevious),
              CompassPrimaryButton(
                label: 'Continue',
                onPressed: canContinue ? onContinue : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _shortExamTitle(String selectedExam) {
  if (selectedExam.startsWith('IC3 Digital Literacy GS6 ')) {
    return selectedExam.replaceFirst('IC3 Digital Literacy GS6 ', 'IC3 GS6 ');
  }
  return selectedExam;
}

class _VerifyNotice extends StatelessWidget {
  const _VerifyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(width: 5, color: const Color(0xFFFFA000)),
            const SizedBox(width: 25),
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBC8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active,
                color: Color(0xFFFFA000),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Candidate, please verify that the following information is correct.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}

class _CandidateExamInformation extends StatelessWidget {
  const _CandidateExamInformation({
    required this.examTitle,
    required this.language,
    required this.paymentType,
    required this.candidateName,
    required this.testCenterName,
    required this.durationText,
    required this.examGroup,
  });

  final String examTitle;
  final String language;
  final String paymentType;
  final String candidateName;
  final String testCenterName;
  final String durationText;
  final String examGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 372,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 62,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
            ),
            child: const Text(
              'Candidate & Exam Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _CandidateTableHeader(),
                  const SizedBox(height: 11),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 23,
                        child: Text(
                          candidateName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            height: 1.18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 35,
                        child: _ExamDetails(
                          examTitle: examTitle,
                          language: language,
                          durationText: durationText,
                          examGroup: examGroup,
                        ),
                      ),
                      Expanded(
                        flex: 22,
                        child: Text(
                          testCenterName,
                          style: const TextStyle(fontSize: 14.5),
                        ),
                      ),
                      Expanded(
                        flex: 17,
                        child: Text(
                          paymentType,
                          style: const TextStyle(fontSize: 14.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CandidateTableHeader extends StatelessWidget {
  const _CandidateTableHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700);

    return Container(
      height: 23,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9), width: 2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 23, child: Text('Name', style: style)),
          Expanded(flex: 35, child: Text('Exam details', style: style)),
          Expanded(flex: 22, child: Text('Test center', style: style)),
          Expanded(flex: 17, child: Text('Payment type', style: style)),
        ],
      ),
    );
  }
}

class _ExamDetails extends StatelessWidget {
  const _ExamDetails({
    required this.examTitle,
    required this.language,
    required this.durationText,
    required this.examGroup,
  });

  final String examTitle;
  final String language;
  final String durationText;
  final String examGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          examTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0789A2),
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 22),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 14.5,
              decoration: TextDecoration.underline,
            ),
          ),
          child: const Text('Change exam'),
        ),
        const SizedBox(height: 20),
        Text('Language: $language', style: const TextStyle(fontSize: 14.5)),
        const SizedBox(height: 28),
        const Text('Accommodations: None', style: TextStyle(fontSize: 14.5)),
        const SizedBox(height: 22),
        Text('Duration: $durationText', style: const TextStyle(fontSize: 14.5)),
        const SizedBox(height: 22),
        Text('Exam Group: $examGroup', style: const TextStyle(fontSize: 14.5)),
      ],
    );
  }
}

class _ReadyForProctorLine extends StatelessWidget {
  const _ReadyForProctorLine();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.warning, color: Color(0xFFFF8A00), size: 17),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Candidate, please notify the proctor that you are ready to proceed.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class _ProctorAuthenticationPanel extends StatelessWidget {
  const _ProctorAuthenticationPanel({
    required this.usernameController,
    required this.passwordController,
    required this.onChanged,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 62,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
            ),
            child: const Text(
              'Proctor Authentication',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All fields are required.',
                  style: TextStyle(fontSize: 15.5, color: Color(0xFF263442)),
                ),
                const SizedBox(height: 24),
                _ProctorField(
                  label: 'Proctor Username:',
                  controller: usernameController,
                  onChanged: onChanged,
                ),
                const SizedBox(height: 8),
                _ProctorField(
                  label: 'Proctor Password:',
                  controller: passwordController,
                  obscureText: true,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProctorField extends StatelessWidget {
  const _ProctorField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 618,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF263442),
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFCFCFCF)),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              obscuringCharacter: '*',
              onChanged: onChanged,
              cursorColor: const Color(0xFF222222),
              cursorHeight: 18,
              style: const TextStyle(
                color: Color(0xFF222222),
                fontSize: 16,
                height: 1.0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(9, 11, 9, 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SystemCheckScreen extends StatelessWidget {
  const SystemCheckScreen({
    required this.selectedExam,
    required this.onPrevious,
    required this.onNext,
    this.checkLabels = const [
      'User Admin',
      'Hardware Requirements',
      'Printer Driver',
      'Running Processes',
      'Exam Up to Date',
      'VBScript',
    ],
    super.key,
  });

  final String selectedExam;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final List<String> checkLabels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(55, 16, 55, 29),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _shortExamTitle(selectedExam),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 6),
          _SystemCheckList(checkLabels: checkLabels),
          const SizedBox(height: 7),
          const Divider(height: 1, color: Color(0xFFE3E3E3)),
          const SizedBox(height: 10),
          _SystemCheckActions(onPrevious: onPrevious, onNext: onNext),
        ],
      ),
    );
  }
}

class _SystemCheckList extends StatelessWidget {
  const _SystemCheckList({required this.checkLabels});

  final List<String> checkLabels;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final label in checkLabels) _SystemCheckRow(label: label),
      ],
    );
  }
}

class _SystemCheckRow extends StatelessWidget {
  const _SystemCheckRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          const SizedBox(
            width: 107,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.check,
                color: Color(0xFF007A1D),
                size: 20,
                weight: 800,
              ),
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _SystemCheckActions extends StatelessWidget {
  const _SystemCheckActions({required this.onPrevious, required this.onNext});

  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 94,
          height: 42,
          child: OutlinedButton(
            onPressed: onPrevious,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF7F7F7),
              foregroundColor: const Color(0xFF333333),
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Color(0xFFCFCFCF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              textStyle: const TextStyle(fontSize: 14),
            ),
            child: const Text('Previous'),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 74,
          height: 48,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: CompassColors.certiportTeal,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Color(0xFFFFA000), width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }
}
