import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';

part 'score_report_document.dart';
part 'score_report_summary.dart';

class ScoreSummaryScreen extends StatelessWidget {
  const ScoreSummaryScreen({
    required this.selectedExam,
    required this.email,
    required this.onEmailChanged,
    required this.onViewFullScoreReport,
    super.key,
  });

  final String selectedExam;
  final String email;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onViewFullScoreReport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 34, 42, 52),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1020),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Exam Score Summary and Pathways',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF344350),
                ),
              ),
              const SizedBox(height: 40),
              _ScorePortalPanel(
                title: 'Verify Email Address',
                child: _VerifyEmailContent(
                  email: email,
                  onUpdateEmail: () => _showUpdateEmailDialog(context),
                ),
              ),
              const SizedBox(height: 26),
              _ScorePortalPanel(
                title: 'Exam Score Summary',
                child: _ExamScoreSummaryContent(
                  selectedExam: selectedExam,
                  onViewFullScoreReport: onViewFullScoreReport,
                ),
              ),
              const SizedBox(height: 26),
              _ScorePortalPanel(
                title: 'Pathways',
                child: _PathwaysContent(
                  onViewDetails: (pathway) =>
                      _showPathwayDetailsDialog(context, pathway),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUpdateEmailDialog(BuildContext context) {
    final controller = TextEditingController(text: email);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.email_outlined, color: CompassColors.certiportTeal),
              SizedBox(width: 10),
              Text('Update Email Address'),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter the email address for exam session notifications.',
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('score-summary-email-input'),
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                ),
              ],
            ),
          ),
          actions: [
            CompassSecondaryButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            CompassPrimaryButton(
              label: 'Save',
              onPressed: () {
                final nextEmail = controller.text.trim();
                if (nextEmail.isNotEmpty) {
                  onEmailChanged(nextEmail);
                }
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPathwayDetailsDialog(
    BuildContext context,
    _Pathway pathway,
  ) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CompassModalDialog(
          icon: Icons.route_outlined,
          title: pathway.name,
          message:
              'This prototype shows pathway availability only. In Compass, this action opens the candidate pathway details for the selected credential.',
          actions: [
            CompassPrimaryButton(
              label: 'Close',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }
}

class FullScoreReportScreen extends StatelessWidget {
  const FullScoreReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          primary: true,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: const Padding(
                padding: EdgeInsets.only(top: 48),
                child: _ScoreReportDocument(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
