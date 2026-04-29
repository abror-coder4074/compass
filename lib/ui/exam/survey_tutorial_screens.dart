import 'package:flutter/material.dart';

import '../compass_theme.dart';
import 'exam_mock_data.dart';
import 'exam_models.dart';

class ExamSurveyScreen extends StatelessWidget {
  const ExamSurveyScreen({
    required this.selectedCourseOptionId,
    required this.selectedResourceOptionIds,
    required this.selectedUsageOptionIds,
    required this.onCourseSelected,
    required this.onResourceToggled,
    required this.onUsageToggled,
    super.key,
  });

  final int? selectedCourseOptionId;
  final Set<int> selectedResourceOptionIds;
  final Set<int> selectedUsageOptionIds;
  final ValueChanged<int> onCourseSelected;
  final ValueChanged<int> onResourceToggled;
  final ValueChanged<int> onUsageToggled;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.fromLTRB(38, 60, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please tell us about your experience with Digital Literacy by answering the questions in the answer area. '
              'Your answers will not affect the exam questions or your score.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                height: 1.32,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 19),
            const Divider(height: 1, color: Color(0xFFC8C8C8)),
            const SizedBox(height: 14),
            Stack(
              alignment: Alignment.center,
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Answer Area',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _SurveyDots(),
              ],
            ),
            const SizedBox(height: 17),
            Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                widthFactor: 0.80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SurveySectionPanel(
                      color: CompassColors.examNavy,
                      title:
                          'Select the statement that best describes the courses you have taken that cover Digital Literacy.',
                      options: surveyCourseOptions,
                      selectedIds: selectedCourseOptionId == null
                          ? const <int>{}
                          : {selectedCourseOptionId!},
                      onOptionPressed: onCourseSelected,
                    ),
                    _SurveySectionPanel(
                      color: const Color(0xFF008D3D),
                      title:
                          'Select all types of resources you used to prepare for the exam.',
                      options: surveyResourceOptions,
                      selectedIds: selectedResourceOptionIds,
                      onOptionPressed: onResourceToggled,
                    ),
                    _SurveySectionPanel(
                      color: const Color(0xFF1CB3AD),
                      title:
                          'Select all statements that describe how you use your Digital Literacy skills.',
                      options: surveyUsageOptions,
                      selectedIds: selectedUsageOptionIds,
                      onOptionPressed: onUsageToggled,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurveySectionPanel extends StatelessWidget {
  const _SurveySectionPanel({
    required this.color,
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.onOptionPressed,
  });

  final Color color;
  final String title;
  final List<SurveyOption> options;
  final Set<int> selectedIds;
  final ValueChanged<int> onOptionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(9, 10, 9, 28),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: const Color(0xFFA1A9AE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth < 900
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 75) / 4;

              return Wrap(
                spacing: 25,
                runSpacing: 16,
                children: [
                  for (final option in options)
                    _SurveyOptionCard(
                      width: cardWidth,
                      label: option.label,
                      selected: selectedIds.contains(option.id),
                      onPressed: () => onOptionPressed(option.id),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SurveyOptionCard extends StatelessWidget {
  const _SurveyOptionCard({
    required this.width,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final double width;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 109),
        padding: const EdgeInsets.fromLTRB(11, 12, 11, 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE3E6E6),
          border: Border.all(
            color: selected
                ? CompassColors.certiportTealDark
                : const Color(0xFFB6BDC1),
            width: selected ? 3 : 1,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 19,
            height: 1.18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _SurveyDots extends StatelessWidget {
  const _SurveyDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: const BoxDecoration(
            color: Color(0xFFD8D8D8),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
