import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';

class PreExamLandingScreen extends StatelessWidget {
  const PreExamLandingScreen({
    required this.selectedExam,
    required this.userName,
    required this.onCloseWindow,
    required this.onStartExam,
    this.durationMinutes = 50,
    this.questionCount = 45,
    this.passScore = 700,
    super.key,
  });

  final String selectedExam;
  final String userName;
  final int durationMinutes;
  final int questionCount;
  final int passScore;
  final Future<void> Function() onCloseWindow;
  final Future<void> Function() onStartExam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 114,
            color: CompassColors.examHeader,
            padding: const EdgeInsets.only(left: 24),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              CompassAssets.ic3Logo,
              width: 126,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;
                final infoPanel = _LandingInfoPanel(
                  selectedExam: selectedExam,
                  userName: userName,
                  durationMinutes: durationMinutes,
                  questionCount: questionCount,
                  passScore: passScore,
                );
                final photo = Image.asset(
                  CompassAssets.examLandingPhoto,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                );

                if (compact) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 330, child: infoPanel),
                        SizedBox(height: 340, child: photo),
                      ],
                    ),
                  );
                }

                final panelWidth = (constraints.maxWidth * 0.3).clamp(
                  390.0,
                  702.0,
                );

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: panelWidth, child: infoPanel),
                    Expanded(child: photo),
                  ],
                );
              },
            ),
          ),
          _LandingFooter(
            onCloseWindow: onCloseWindow,
            onStartExam: onStartExam,
          ),
        ],
      ),
    );
  }
}

class _LandingFooter extends StatefulWidget {
  const _LandingFooter({
    required this.onCloseWindow,
    required this.onStartExam,
  });

  final Future<void> Function() onCloseWindow;
  final Future<void> Function() onStartExam;

  @override
  State<_LandingFooter> createState() => _LandingFooterState();
}

class _LandingFooterState extends State<_LandingFooter> {
  bool _startingExam = false;

  Future<void> _handleStartExam() async {
    if (_startingExam) {
      return;
    }
    setState(() {
      _startingExam = true;
    });
    try {
      await widget.onStartExam();
    } finally {
      if (mounted) {
        setState(() {
          _startingExam = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.fromLTRB(50, 0, 48, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CompassColors.border)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            tooltip: 'Tools',
            offset: const Offset(0, -120),
            onSelected: (value) {
              if (value == 'close') {
                widget.onCloseWindow();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'calculator', child: Text('Calculator')),
              PopupMenuItem(value: 'help', child: Text('Help')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'close', child: Text('Close Window')),
            ],
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tools',
                  style: TextStyle(
                    color: CompassColors.examNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 3),
                Icon(Icons.arrow_drop_down, color: CompassColors.examNavy),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 48,
            child: CompassPrimaryButton(
              label: 'Start Exam',
              tone: CompassButtonTone.exam,
              onPressed: _startingExam ? null : () async => _handleStartExam(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingInfoPanel extends StatelessWidget {
  const _LandingInfoPanel({
    required this.selectedExam,
    required this.userName,
    required this.durationMinutes,
    required this.questionCount,
    required this.passScore,
  });

  final String selectedExam;
  final String userName;
  final int durationMinutes;
  final int questionCount;
  final int passScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CompassColors.examNavy,
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tight = constraints.maxHeight < 500;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $userName!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: tight ? 26 : 35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: tight ? 32 : 42),
              Text(
                selectedExam,
                maxLines: tight ? 3 : null,
                overflow: tight ? TextOverflow.ellipsis : TextOverflow.visible,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: tight ? 21 : 29,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              SizedBox(height: tight ? 58 : 82),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: tight ? 15 : 20,
                    height: 2.05,
                    fontFamily: 'Arial',
                  ),
                  children: [
                    const TextSpan(text: 'Maximum exam time: '),
                    TextSpan(
                      text: '$durationMinutes minutes\n',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const TextSpan(text: 'Number of exam questions: '),
                    TextSpan(
                      text: '$questionCount\n',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const TextSpan(
                      text: 'Minimum score required to pass exam: ',
                    ),
                    TextSpan(
                      text: '$passScore',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
