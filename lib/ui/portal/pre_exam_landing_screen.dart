import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';

class PreExamLandingScreen extends StatelessWidget {
  const PreExamLandingScreen({
    required this.selectedExam,
    required this.onCloseWindow,
    required this.onStartExam,
    super.key,
  });

  final String selectedExam;
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
                final infoPanel = _LandingInfoPanel(selectedExam: selectedExam);
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

class _LandingFooter extends StatelessWidget {
  const _LandingFooter({
    required this.onCloseWindow,
    required this.onStartExam,
  });

  final Future<void> Function() onCloseWindow;
  final Future<void> Function() onStartExam;

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
                onCloseWindow();
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
              onPressed: () {
                onStartExam();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingInfoPanel extends StatelessWidget {
  const _LandingInfoPanel({required this.selectedExam});

  final String selectedExam;

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
                'Welcome, Certiport!',
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
                  children: const [
                    TextSpan(text: 'Maximum exam time: '),
                    TextSpan(
                      text: '50 minutes\n',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: 'Number of exam questions: '),
                    TextSpan(
                      text: '45\n',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: 'Minimum score required to pass exam: '),
                    TextSpan(
                      text: '700',
                      style: TextStyle(fontWeight: FontWeight.w700),
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
