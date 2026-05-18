import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';

class NdaScreen extends StatelessWidget {
  const NdaScreen({
    required this.agreement,
    required this.onAgreementChanged,
    required this.onPrevious,
    required this.onNext,
    this.agreementContent,
    super.key,
  });

  final String agreement;
  final String? agreementContent;
  final ValueChanged<String?> onAgreementChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final portalBodyHeight = MediaQuery.sizeOf(context).height - 104 - 88;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: portalBodyHeight.clamp(0, 900)),
      color: CompassColors.portalBackground,
      padding: const EdgeInsets.fromLTRB(36, 0, 36, 28),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1040),
          padding: const EdgeInsets.fromLTRB(42, 18, 42, 30),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: const Text(
                  'Non-Disclosure Agreement and Terms of Use',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 8),
              _NdaAgreementBox(content: agreementContent),
              const SizedBox(height: 18),
              const Text(
                'To take any exam you must accept this Non-Disclosure Agreement and Terms of Use.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              RadioGroup<String>(
                groupValue: agreement,
                onChanged: onAgreementChanged,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NdaRadioOption(
                      value: 'yes',
                      label: 'Yes, I accept',
                      onChanged: onAgreementChanged,
                    ),
                    const SizedBox(height: 8),
                    _NdaRadioOption(
                      value: 'no',
                      label: 'No, I don\'t accept',
                      onChanged: onAgreementChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E2E2)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _NdaPreviousButton(onPressed: onPrevious),
                  const Spacer(),
                  CompassPrimaryButton(
                    label: 'Next',
                    onPressed: agreement == 'yes' ? onNext : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NdaAgreementBox extends StatefulWidget {
  const _NdaAgreementBox({this.content});

  final String? content;

  @override
  State<_NdaAgreementBox> createState() => _NdaAgreementBoxState();
}

class _NdaAgreementBoxState extends State<_NdaAgreementBox> {
  final ScrollController _controller = ScrollController();

  static const _bodyStyle = TextStyle(
    color: Colors.black,
    fontSize: 13.5,
    height: 1.32,
    fontWeight: FontWeight.w400,
  );
  static const _strongStyle = TextStyle(
    color: Colors.black,
    fontSize: 13.5,
    height: 1.32,
    fontWeight: FontWeight.w700,
  );
  static const _linkStyle = TextStyle(
    color: Color(0xFF005CC8),
    fontSize: 13.5,
    height: 1.32,
    decoration: TextDecoration.underline,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 338,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFADADAD), width: 1.4),
      ),
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        thickness: 10,
        radius: Radius.zero,
        child: SingleChildScrollView(
          controller: _controller,
          padding: const EdgeInsets.fromLTRB(12, 18, 22, 18),
          child: widget.content == null || widget.content!.trim().isEmpty
              ? const _NdaText()
              : Text(widget.content!, style: _bodyStyle),
        ),
      ),
    );
  }
}

class _NdaText extends StatelessWidget {
  const _NdaText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: _NdaAgreementBoxState._bodyStyle,
        children: [
          TextSpan(
            text:
                'NON-DISCLOSURE AGREEMENT AND GENERAL TERMS OF USE FOR THE CERTIFICATION EXAMINATIONS\n\n',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'Non-Disclosure: ',
            style: _NdaAgreementBoxState._strongStyle,
          ),
          TextSpan(
            text:
                'The content of Certiport certification examinations is confidential and protected by trade secret law and other applicable law. It is made available to you, the Examinee, solely for skill measurement in the category referenced in the title of the examination. You are prohibited from disclosing, publishing, reproducing, summarizing, paraphrasing, or transmitting any certification examination, in whole or in part, in any form or by any means, verbal or written, electronic or mechanical, without prior written permission from Certiport.\n\n',
          ),
          TextSpan(
            text: 'Privacy and cookies policy: ',
            style: _NdaAgreementBoxState._strongStyle,
          ),
          TextSpan(
            text:
                'Certiport collects personally identifiable information during registration. Please refer to our policy at ',
          ),
          TextSpan(
            text: 'http://www.certiport.com',
            style: _NdaAgreementBoxState._linkStyle,
          ),
          TextSpan(
            text:
                ' to learn more about the privacy of this information and how it may be used by Certiport and its partners.\n\n',
          ),
          TextSpan(
            text: 'Disclaimer: ',
            style: _NdaAgreementBoxState._strongStyle,
          ),
          TextSpan(
            text:
                'You agree and acknowledge that earning this certification does not guarantee employment or eligibility for specific jobs. Certification is not a condition or guarantee of employment with the Test Sponsor or any other entity. Your participation in this certification program is voluntary, and you understand you will not be paid for time spent on this certification course or examination.\n\n',
          ),
          TextSpan(
            text:
                'This agreement shall be construed and controlled by the laws of the State of Minnesota, and Examinee consents to jurisdiction by state and federal courts sitting in the State of Minnesota.\n\n',
          ),
          TextSpan(
            text: 'Candidate conduct: ',
            style: _NdaAgreementBoxState._strongStyle,
          ),
          TextSpan(
            text:
                'You agree to complete the exam independently and under the supervision of an authorized proctor. You may not receive help from another person, use unauthorized notes, use recording devices, copy exam content, photograph the screen, or attempt to bypass the secure testing workspace.\n\n',
          ),
          TextSpan(
            text: 'Exam delivery: ',
            style: _NdaAgreementBoxState._strongStyle,
          ),
          TextSpan(
            text:
                'You must follow all instructions from Certiport, the Test Sponsor, and the test center staff. The proctor may pause, stop, or invalidate an exam session if testing rules are not followed or if exam content may have been exposed.\n\n',
          ),
          TextSpan(
            text: 'Score and candidate records: ',
            style: _NdaAgreementBoxState._strongStyle,
          ),
          TextSpan(
            text:
                'Your registration information, responses, score, and related exam records may be stored and processed for exam administration, reporting, audit, support, and certification verification. You are responsible for confirming that your candidate information is accurate before the exam begins.\n\n',
          ),
          TextSpan(
            text:
                'By selecting Yes, I accept, you confirm that you have read, understand, and agree to be bound by this Non-Disclosure Agreement and Terms of Use. If you do not accept, you will not be permitted to continue to the certification examination.',
          ),
        ],
      ),
    );
  }
}

class _NdaRadioOption extends StatelessWidget {
  const _NdaRadioOption({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final String value;
  final String label;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _NdaPreviousButton extends StatelessWidget {
  const _NdaPreviousButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const baseSide = BorderSide(color: Color(0xFFBFC6CA));
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(78, 38),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        foregroundColor: CompassColors.text,
        side: baseSide,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
      ).copyWith(side: CompassControlStates.hoverSide(baseSide)),
      child: const Text('Previous'),
    );
  }
}
