part of 'score_report_screens.dart';

class _VerifyEmailContent extends StatelessWidget {
  const _VerifyEmailContent({required this.email, required this.onUpdateEmail});

  final String email;
  final VoidCallback onUpdateEmail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        final text = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You may be sent additional information regarding your exam session.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 22),
            Wrap(
              children: [
                const Text('Your Email: ', style: TextStyle(fontSize: 14)),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              text,
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: CompassPrimaryButton(
                  label: 'Update Email Address',
                  onPressed: onUpdateEmail,
                ),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: text),
            const SizedBox(width: 30),
            CompassPrimaryButton(
              label: 'Update Email Address',
              onPressed: onUpdateEmail,
            ),
          ],
        );
      },
    );
  }
}

class _ExamScoreSummaryContent extends StatelessWidget {
  const _ExamScoreSummaryContent({
    required this.selectedExam,
    required this.onViewFullScoreReport,
    this.scoreReport,
  });

  final String selectedExam;
  final VoidCallback onViewFullScoreReport;
  final ScoreReportData? scoreReport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SummaryTableRow(
          examName: 'Exam name',
          score: 'Score',
          status: 'Status',
          header: true,
        ),
        _SummaryTableRow(
          examName:
              scoreReport?.exam.shortTitle ?? _shortExamName(selectedExam),
          score: '${scoreReport?.candidateScore ?? 700}/1000',
          status: scoreReport?.outcome ?? 'Pass',
          action: CompassPrimaryButton(
            label: 'View Full Score Report',
            onPressed: onViewFullScoreReport,
          ),
        ),
      ],
    );
  }

  static String _shortExamName(String selectedExam) {
    if (selectedExam.startsWith('IC3 Digital Literacy GS6 ')) {
      return selectedExam.replaceFirst('IC3 Digital Literacy GS6 ', 'IC3 GS6 ');
    }
    return selectedExam;
  }
}

class _SummaryTableRow extends StatelessWidget {
  const _SummaryTableRow({
    required this.examName,
    required this.score,
    required this.status,
    this.header = false,
    this.action,
  });

  final String examName;
  final String score;
  final String status;
  final bool header;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final scoreWidth = compact ? 104.0 : 126.0;
        final statusWidth = compact ? 84.0 : 96.0;
        final actionWidth = compact ? 174.0 : 196.0;
        final horizontalPadding = compact ? 6.0 : 8.0;

        return Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: CompassColors.border)),
          ),
          child: Row(
            children: [
              _summaryCell(
                examName,
                large: false,
                horizontalPadding: horizontalPadding,
              ),
              _summaryCell(
                score,
                width: scoreWidth,
                large: false,
                horizontalPadding: horizontalPadding,
              ),
              _summaryCell(
                status,
                width: statusWidth,
                large: false,
                horizontalPadding: horizontalPadding,
              ),
              SizedBox(
                width: actionWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8,
                  ),
                  child: action == null
                      ? const SizedBox.shrink()
                      : FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: action,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCell(
    String text, {
    double? width,
    required bool large,
    required double horizontalPadding,
  }) {
    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: header
              ? 14
              : large
              ? 24
              : 13,
          fontWeight: header || large ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );

    if (width == null) {
      return Expanded(child: content);
    }

    return SizedBox(width: width, child: content);
  }
}

class _PathwaysContent extends StatelessWidget {
  const _PathwaysContent({required this.onViewDetails, this.pathways});

  final List<PathwayData>? pathways;
  final ValueChanged<_Pathway> onViewDetails;

  @override
  Widget build(BuildContext context) {
    final displayPathways =
        pathways
            ?.map((pathway) => _Pathway(pathway.name, pathway.percentComplete))
            .toList() ??
        _pathways;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            final image = Image.asset(
              CompassAssets.pathwaysProgress,
              width: compact ? double.infinity : 276,
              height: compact ? 154 : 156,
              fit: BoxFit.cover,
            );
            const copy = Text(
              'Earning a certification is a major accomplishment and the first step toward advancing your academic pursuits or career.\n\n'
              'Pathways are designed to highlight your specific accomplishments, track your progress, and show you just how far you can go with the right credentials.\n\n'
              'Below is a list of related pathways for you to discover and to take your certification to the next level.',
              style: TextStyle(fontSize: 15, height: 1.35),
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [image, const SizedBox(height: 18), copy],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image,
                const SizedBox(width: 26),
                const Expanded(child: copy),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const _PathwayHeaderRow(),
        for (final pathway in displayPathways)
          _PathwayRow(pathway: pathway, onViewDetails: onViewDetails),
      ],
    );
  }
}

class _ScorePortalPanel extends StatelessWidget {
  const _ScorePortalPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CompassColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: CompassColors.border)),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(padding: const EdgeInsets.all(18), child: child),
        ],
      ),
    );
  }
}

class _PathwayHeaderRow extends StatelessWidget {
  const _PathwayHeaderRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'Pathway',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Percent Complete',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 230),
        ],
      ),
    );
  }
}

class _PathwayRow extends StatelessWidget {
  const _PathwayRow({required this.pathway, required this.onViewDetails});

  final _Pathway pathway;
  final ValueChanged<_Pathway> onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CompassColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(pathway.name)),
          Expanded(flex: 2, child: Text('${pathway.percentComplete}%')),
          SizedBox(
            width: 230,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CompassPrimaryButton(
                label: 'View Pathways Details',
                onPressed: () => onViewDetails(pathway),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pathway {
  const _Pathway(this.name, this.percentComplete);

  final String name;
  final int percentComplete;
}

const _pathways = [
  _Pathway('IC3 Digital Literacy GS6 Master', 0),
  _Pathway('Future Proof Economies: Workforce Ready', 0),
  _Pathway('Workforce Ready', 0),
];
