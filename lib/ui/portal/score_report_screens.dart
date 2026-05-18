import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/compass_models.dart';
import '../compass_components.dart';
import '../compass_theme.dart';

part 'score_report_document.dart';
part 'score_report_summary.dart';

class ScoreSummaryScreen extends StatelessWidget {
  const ScoreSummaryScreen({
    required this.selectedExam,
    required this.email,
    required this.onViewFullScoreReport,
    this.scoreReport,
    this.pathways,
    super.key,
  });

  final String selectedExam;
  final String email;
  final VoidCallback onViewFullScoreReport;
  final ScoreReportData? scoreReport;
  final List<PathwayData>? pathways;

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
                child: _VerifyEmailContent(email: email, onUpdateEmail: () {}),
              ),
              const SizedBox(height: 26),
              _ScorePortalPanel(
                title: 'Exam Score Summary',
                child: _ExamScoreSummaryContent(
                  selectedExam: selectedExam,
                  scoreReport: scoreReport,
                  onViewFullScoreReport: onViewFullScoreReport,
                ),
              ),
              const SizedBox(height: 26),
              _ScorePortalPanel(
                title: 'Pathways',
                child: _PathwaysContent(
                  pathways: pathways ?? scoreReport?.pathways,
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
  const FullScoreReportScreen({this.scoreReport, super.key});

  final ScoreReportData? scoreReport;

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
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: _ScoreReportDocument(scoreReport: scoreReport),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
