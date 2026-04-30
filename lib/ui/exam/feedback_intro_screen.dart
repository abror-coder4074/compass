import 'package:flutter/material.dart';

import '../compass_theme.dart';

class ExamFeedbackShell extends StatelessWidget {
  const ExamFeedbackShell({
    required this.child,
    required this.footer,
    super.key,
  });

  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 144,
            color: CompassColors.examHeader,
            padding: const EdgeInsets.only(left: 30, top: 16),
            alignment: Alignment.topLeft,
            child: Image.asset(
              CompassAssets.ic3Logo,
              width: 156,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(child: child),
          footer,
        ],
      ),
    );
  }
}

class ExamFeedbackIntroScreen extends StatelessWidget {
  const ExamFeedbackIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.fromLTRB(22, 54, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave feedback about exam items',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 28),
            const Text(
              'You can now leave comments for individual exam questions. We use your feedback to improve the exam experience.',
              style: TextStyle(fontSize: 15, height: 1.45),
            ),
            const SizedBox(height: 18),
            const Text(
              'You will have 15 minutes to provide comments. After you start the commenting period, you can re-read exam questions but will not be able to change your answers.',
              style: TextStyle(fontSize: 15, height: 1.45),
            ),
            const SizedBox(height: 18),
            const Text(
              'Please note: Comments are not anonymous. However, Certiport does not respond directly to candidates who provide comments during the exam. If you have feedback for which you\'d like a direct response, please send email to CustomerServices@Certiport.com.',
              style: TextStyle(fontSize: 15, height: 1.45),
            ),
            const SizedBox(height: 18),
            const Text(
              'Thank you for your input!',
              style: TextStyle(fontSize: 15, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamFeedbackFormScreen extends StatelessWidget {
  const ExamFeedbackFormScreen({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.fromLTRB(58, 54, 58, 36),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave feedback about exam items',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'You may enter feedback about the exam below.',
                    style: TextStyle(fontSize: 15, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.only(left: 36),
                    child: Text(
                      '1. Tell us what you liked about the exam.\n'
                      '2. Tell us what you didn\'t like about the exam.\n'
                      '3. Did you experience any technical problems? If so, please describe them.',
                      style: TextStyle(fontSize: 15, height: 1.45),
                    ),
                  ),
                  const SizedBox(height: 58),
                  SizedBox(
                    height: 420,
                    child: TextField(
                      key: const ValueKey('exam-feedback-textarea'),
                      controller: controller,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Color(0xFF9A9A9A)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Color(0xFF9A9A9A)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: CompassColors.examNavy,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExamFeedbackThankYouScreen extends StatelessWidget {
  const ExamFeedbackThankYouScreen({required this.examTitle, super.key});

  final String examTitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(50, 76, 50, 36),
      child: Text(
        'Thank you for taking the $examTitle exam.',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      ),
    );
  }
}
