import 'package:flutter/material.dart';

import '../compass_theme.dart';

class TutorialSampleQuestionCard extends StatelessWidget {
  const TutorialSampleQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 862,
      height: 470,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 42,
            top: 0,
            child: Container(
              width: 810,
              height: 470,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF858585)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 64,
                    color: const Color(0xFFEAF1F8),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text(
                            'Question 2 of 45',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 20,
                                ),
                                children: [
                                  TextSpan(text: 'Time Remaining  '),
                                  TextSpan(
                                    text: '00:42:52',
                                    style: TextStyle(
                                      color: Color(0xFF008EBB),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 21,
                    child: Row(
                      children: [
                        Container(width: 45, color: CompassColors.examNavy),
                        Expanded(
                          child: Container(color: const Color(0xFFBAC7CF)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 18, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'You are purchasing a new iPhone.',
                            style: TextStyle(fontSize: 17, height: 1.45),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'You need to select the phone that weighs the least.',
                            style: TextStyle(fontSize: 17, height: 1.45),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Which model should you choose?',
                            style: TextStyle(fontSize: 17, height: 1.45),
                          ),
                          SizedBox(height: 19),
                          _TutorialOption(letter: 'A.', label: 'iPhone X'),
                          _TutorialOption(letter: 'B.', label: 'iPhone 8'),
                          _TutorialOption(letter: 'C.', label: 'iPhone 7'),
                          _TutorialOption(letter: 'D.', label: 'iPhone 6s'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 42,
            top: 64,
            bottom: 0,
            child: Container(width: 1, color: const Color(0xFF8A8A8A)),
          ),
          const Positioned(
            left: 18,
            top: 12,
            child: TutorialRedGuideMarker('1'),
          ),
          const Positioned(
            left: 18,
            top: 151,
            child: TutorialRedGuideMarker('2'),
          ),
        ],
      ),
    );
  }
}

class TutorialRedGuideMarker extends StatelessWidget {
  const TutorialRedGuideMarker(this.number, {super.key});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFC9182D),
        shape: BoxShape.circle,
      ),
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TutorialOption extends StatelessWidget {
  const _TutorialOption({required this.letter, required this.label});

  final String letter;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF9C9C9C), width: 1.5),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 28,
            child: Text(letter, style: const TextStyle(fontSize: 17)),
          ),
          Expanded(
            child: Container(
              height: 25,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD5DCE0)),
              ),
              child: Text(label, style: const TextStyle(fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
