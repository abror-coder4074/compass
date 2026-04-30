part of 'score_report_screens.dart';

class _ScoreReportDocument extends StatelessWidget {
  const _ScoreReportDocument({this.scoreReport});

  final ScoreReportData? scoreReport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 56, bottom: 10),
          child: Image.asset(
            CompassAssets.ic3Logo,
            width: 170,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ),
        Container(
          height: 46,
          color: const Color(0xFF555A5C),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 56),
          child: const Text(
            'EXAM SCORE REPORT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(height: 14, color: Colors.black),
        Padding(
          padding: const EdgeInsets.fromLTRB(56, 34, 56, 0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _GreenPanel(
                      title: 'CANDIDATE',
                      child: Text(
                        _candidateText,
                        style: const TextStyle(fontSize: 18, height: 1.32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _GreenPanel(
                      title: 'EXAM',
                      child: Text(
                        _examText,
                        style: const TextStyle(fontSize: 18, height: 1.32),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _ResultsGrid(scoreReport: scoreReport),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _SectionAnalysisTable(scoreReport: scoreReport),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: _FinalScoreColumn(scoreReport: scoreReport),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 190),
        const Text(
          '(c) 2026 Certiport and the Certiport logo are registered trademarks of Certiport, a business of NCS Pearson, Inc. All other trademarks and registered trademarks are the property of their respective holders.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Container(
          height: 58,
          color: const Color(0xFF555A5C),
          alignment: Alignment.center,
          child: Image.asset(
            CompassAssets.certiportLogo,
            width: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  String get _candidateText {
    final candidate = scoreReport?.candidate;
    if (candidate == null) {
      return 'Alex Morgan\n'
          '41 Amir Temur Street, Office 1205\n'
          'Tashkent 100000\n'
          'Uzbekistan\n\n'
          'Candidate ID: CP-842916\n'
          'alex.morgan@example.com';
    }
    return '${candidate.displayName}\n'
        '${candidate.reportAddress}\n\n'
        'Candidate ID: ${candidate.candidateIdentifier}\n'
        '${candidate.email}';
  }

  String get _examText {
    final report = scoreReport;
    if (report == null) {
      return 'IC3 Digital Literacy GS6 Level 1\n\n'
          'Exam ID: IC3-GS6-L1-2026\n'
          'Session ID: COMPASS-2026-0312-1842\n'
          'Testing Center: Edu Action LLC.\n'
          'Date: March 12, 2026';
    }
    return '${report.exam.title}\n\n'
        'Exam ID: ${report.exam.code}\n'
        'Session ID: ${report.sessionId}\n'
        'Testing Center: ${report.testCenter.name}\n'
        'Date: ${DateTime.now().toLocal().toString().split(' ').first}';
  }
}

class _GreenPanel extends StatelessWidget {
  const _GreenPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Color(0xFF7E7E7E))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: CompassColors.ic3Green,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(10), child: child),
        ],
      ),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({this.scoreReport});

  final ScoreReportData? scoreReport;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labelWidth = 255.0;
        final scoreWidth = (constraints.maxWidth - labelWidth) / 10;

        return Column(
          children: [
            Row(
              children: [
                _gridHeaderCell('RESULTS', width: labelWidth, alignLeft: true),
                for (var score = 100; score <= 1000; score += 100)
                  _gridHeaderCell(score.toString(), width: scoreWidth),
              ],
            ),
            _ResultScoreRow(
              label: 'Required Score',
              score: scoreReport?.requiredScore ?? 700,
              labelWidth: labelWidth,
              scoreWidth: scoreWidth,
            ),
            _ResultScoreRow(
              label: 'Your Score',
              score: scoreReport?.candidateScore ?? 700,
              labelWidth: labelWidth,
              scoreWidth: scoreWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _gridHeaderCell(
    String text, {
    required double width,
    bool alignLeft = false,
  }) {
    return Container(
      width: width,
      height: 40,
      alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
      padding: alignLeft ? const EdgeInsets.only(left: 10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: CompassColors.ic3Green,
        border: Border.all(color: const Color(0xFF7E7E7E)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ResultScoreRow extends StatelessWidget {
  const _ResultScoreRow({
    required this.label,
    required this.score,
    required this.labelWidth,
    required this.scoreWidth,
  });

  final String label;
  final int score;
  final double labelWidth;
  final double scoreWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: labelWidth,
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7E7E7E)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
        SizedBox(
          width: scoreWidth * 10,
          height: 40,
          child: Stack(
            children: [
              Row(
                children: [
                  for (var i = 0; i < 10; i++)
                    Container(
                      width: scoreWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF7E7E7E)),
                      ),
                    ),
                ],
              ),
              Positioned(
                left: 0,
                top: 12,
                child: Container(
                  width: scoreWidth * (score / 100),
                  height: 15,
                  color: const Color(0xFF858585),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionAnalysisTable extends StatelessWidget {
  const _SectionAnalysisTable({this.scoreReport});

  final ScoreReportData? scoreReport;

  @override
  Widget build(BuildContext context) {
    return _GreenPanel(
      title: 'SECTION ANALYSIS',
      child: Table(
        border: TableBorder.all(color: const Color(0xFF7E7E7E)),
        columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(1)},
        children: [
          for (var i = 0; i < _displayScores.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: i.isEven ? const Color(0xFFD4D5D6) : Colors.white,
              ),
              children: [
                _reportTableCell(_displayScores[i].name),
                _reportTableCell('${_displayScores[i].score}%'),
              ],
            ),
        ],
      ),
    );
  }

  List<SectionScoreData> get _displayScores {
    return scoreReport?.sectionScores ??
        _sectionScores
            .map(
              (score) => SectionScoreData(name: score.name, score: score.score),
            )
            .toList();
  }

  Widget _reportTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Text(text, style: const TextStyle(fontSize: 17)),
    );
  }
}

class _FinalScoreColumn extends StatelessWidget {
  const _FinalScoreColumn({this.scoreReport});

  final ScoreReportData? scoreReport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GreenPanel(
          title: 'FINAL SCORE',
          child: Table(
            border: TableBorder.all(color: const Color(0xFF7E7E7E)),
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFD4D5D6)),
                children: [
                  const _FinalScoreCell('Required Score'),
                  _FinalScoreCell(
                    '${scoreReport?.requiredScore ?? 700}',
                    centered: true,
                  ),
                ],
              ),
              TableRow(
                children: [
                  const _FinalScoreCell('Your Score'),
                  _FinalScoreCell(
                    '${scoreReport?.candidateScore ?? 700}',
                    centered: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _GreenPanel(
          title: 'OUTCOME',
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7E7E7E)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      scoreReport?.outcome ?? 'Pass',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 74,
                  child: Icon(
                    Icons.check,
                    size: 58,
                    color: CompassColors.successGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FinalScoreCell extends StatelessWidget {
  const _FinalScoreCell(this.text, {this.centered = false});

  final String text;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        text,
        textAlign: centered ? TextAlign.center : TextAlign.left,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}

class _SectionScore {
  const _SectionScore(this.name, this.score);

  final String name;
  final int score;
}

const _sectionScores = [
  _SectionScore('Technology Basics', 72),
  _SectionScore('Digital Citizenship', 68),
  _SectionScore('Information Management', 71),
  _SectionScore('Content Creation', 69),
  _SectionScore('Communication', 73),
  _SectionScore('Collaboration', 70),
  _SectionScore('Security', 71),
];
