import 'package:flutter/material.dart';

import '../compass_theme.dart';
import 'exam_models.dart';

typedef MatrixAnswerSelected = void Function(int rowIndex, String answer);
typedef OrderItemShifted = void Function(int index, int delta);
typedef MatchItemAssigned = void Function(String item, int targetIndex);

class ExamQuestionScreen extends StatelessWidget {
  const ExamQuestionScreen({
    required this.question,
    required this.onAnswerSelected,
    required this.onMultiAnswerToggled,
    required this.onMatrixAnswerSelected,
    required this.onOrderItemMovedToAnswer,
    required this.onOrderItemMovedToSource,
    required this.onOrderedItemShifted,
    required this.onMatchItemAssigned,
    required this.onMatchTargetCleared,
    super.key,
  });

  final ExamQuestion question;
  final ValueChanged<String> onAnswerSelected;
  final ValueChanged<String> onMultiAnswerToggled;
  final MatrixAnswerSelected onMatrixAnswerSelected;
  final ValueChanged<String> onOrderItemMovedToAnswer;
  final ValueChanged<String> onOrderItemMovedToSource;
  final OrderItemShifted onOrderedItemShifted;
  final MatchItemAssigned onMatchItemAssigned;
  final ValueChanged<int> onMatchTargetCleared;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
        child: _QuestionFrame(child: _buildQuestionBody()),
      ),
    );
  }

  Widget _buildQuestionBody() {
    final prompt = _PromptBlock(question: question);

    return switch (question.type) {
      ExamQuestionType.singleChoice => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prompt,
          const SizedBox(height: 20),
          _OptionList(
            question: question,
            mode: _OptionListMode.radio,
            onOptionPressed: onAnswerSelected,
          ),
        ],
      ),
      ExamQuestionType.multipleChoice => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prompt,
          const SizedBox(height: 20),
          _OptionList(
            question: question,
            mode: _OptionListMode.checkbox,
            onOptionPressed: onMultiAnswerToggled,
          ),
        ],
      ),
      ExamQuestionType.matrix => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prompt,
          const Divider(height: 38, color: Color(0xFFD5D5D5)),
          const _AnswerAreaLabel(),
          const SizedBox(height: 12),
          _MatrixQuestion(
            question: question,
            onAnswerSelected: onMatrixAnswerSelected,
          ),
        ],
      ),
      ExamQuestionType.ordering => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prompt,
          const Divider(height: 38, color: Color(0xFFD5D5D5)),
          _OrderingQuestion(
            question: question,
            onMovedToAnswer: onOrderItemMovedToAnswer,
            onMovedToSource: onOrderItemMovedToSource,
            onShifted: onOrderedItemShifted,
          ),
        ],
      ),
      ExamQuestionType.matching => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prompt,
          const Divider(height: 34, color: Color(0xFFD5D5D5)),
          _MatchingQuestion(
            question: question,
            onAssigned: onMatchItemAssigned,
            onCleared: onMatchTargetCleared,
          ),
        ],
      ),
    };
  }
}

class _QuestionFrame extends StatelessWidget {
  const _QuestionFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 500),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
      color: Colors.white,
      child: child,
    );
  }
}

class _PromptBlock extends StatelessWidget {
  const _PromptBlock({required this.question});

  final ExamQuestion question;

  @override
  Widget build(BuildContext context) {
    final lines = [question.prompt, ...question.promptDetails];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          Text(lines[i], style: const TextStyle(fontSize: 16, height: 1.45)),
          if (i != lines.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

enum _OptionListMode { radio, checkbox }

class _OptionList extends StatelessWidget {
  const _OptionList({
    required this.question,
    required this.mode,
    required this.onOptionPressed,
  });

  final ExamQuestion question;
  final _OptionListMode mode;
  final ValueChanged<String> onOptionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < question.options.length; i++)
          _QuestionOptionTile(
            key: ValueKey(
              '${mode == _OptionListMode.radio ? 'single' : 'multi'}-option-${question.number}-${String.fromCharCode(65 + i)}',
            ),
            letter: String.fromCharCode(65 + i),
            text: question.options[i],
            control: mode == _OptionListMode.radio
                ? _SmallRadioButton(
                    selected:
                        question.selectedOption == String.fromCharCode(65 + i),
                  )
                : _SmallCheckbox(
                    selected: question.selectedOptions.contains(
                      String.fromCharCode(65 + i),
                    ),
                  ),
            onPressed: () => onOptionPressed(String.fromCharCode(65 + i)),
          ),
      ],
    );
  }
}

class _AnswerAreaLabel extends StatelessWidget {
  const _AnswerAreaLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Answer Area',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _MatrixQuestion extends StatelessWidget {
  const _MatrixQuestion({
    required this.question,
    required this.onAnswerSelected,
  });

  final ExamQuestion question;
  final MatrixAnswerSelected onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 260, right: 120),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              for (final column in question.matrixColumns)
                SizedBox(
                  width: 92,
                  child: Text(
                    column,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (
            var rowIndex = 0;
            rowIndex < question.matrixRows.length;
            rowIndex++
          )
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      question.matrixRows[rowIndex],
                      style: const TextStyle(fontSize: 15, height: 1.25),
                    ),
                  ),
                  for (final column in question.matrixColumns)
                    SizedBox(
                      width: 92,
                      child: Center(
                        child: InkWell(
                          key: ValueKey(
                            'matrix-${question.number}-row-$rowIndex-$column',
                          ),
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () => onAnswerSelected(rowIndex, column),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: _SmallRadioButton(
                              selected:
                                  question.matrixSelections[rowIndex] == column,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderingQuestion extends StatelessWidget {
  const _OrderingQuestion({
    required this.question,
    required this.onMovedToAnswer,
    required this.onMovedToSource,
    required this.onShifted,
  });

  final ExamQuestion question;
  final ValueChanged<String> onMovedToAnswer;
  final ValueChanged<String> onMovedToSource;
  final OrderItemShifted onShifted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DragColumn(
            title: 'Actions',
            children: [
              for (final item in question.availableOrderItems)
                _DraggableAnswerBox(
                  item: item,
                  onTap: () => onMovedToAnswer(item),
                ),
            ],
          ),
        ),
        SizedBox(
          width: 82,
          child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Column(
              children: [
                _RoundIconButton(
                  key: ValueKey('order-${question.number}-move-first'),
                  icon: Icons.chevron_right,
                  onPressed: question.availableOrderItems.isEmpty
                      ? null
                      : () =>
                            onMovedToAnswer(question.availableOrderItems.first),
                ),
                const SizedBox(height: 10),
                _RoundIconButton(
                  key: ValueKey('order-${question.number}-return-last'),
                  icon: Icons.chevron_left,
                  onPressed: question.orderedItems.isEmpty
                      ? null
                      : () => onMovedToSource(question.orderedItems.last),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: DragTarget<String>(
            onAcceptWithDetails: (details) => onMovedToAnswer(details.data),
            builder: (context, candidateData, rejectedData) {
              return _DragColumn(
                title: 'Actions in Order',
                highlighted: candidateData.isNotEmpty,
                children: [
                  if (question.orderedItems.isEmpty) const _EmptyDropMessage(),
                  for (var i = 0; i < question.orderedItems.length; i++)
                    _OrderedAnswerBox(
                      item: question.orderedItems[i],
                      index: i,
                      totalItems: question.orderedItems.length,
                      onRemove: () => onMovedToSource(question.orderedItems[i]),
                      onShifted: onShifted,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MatchingQuestion extends StatelessWidget {
  const _MatchingQuestion({
    required this.question,
    required this.onAssigned,
    required this.onCleared,
  });

  final ExamQuestion question;
  final MatchItemAssigned onAssigned;
  final ValueChanged<int> onCleared;

  @override
  Widget build(BuildContext context) {
    final firstEmptyTarget = question.targetItems.asMap().keys.firstWhere(
      (index) => !question.matchingSelections.containsKey(index),
      orElse: () => -1,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DragColumn(
            title: 'Media Creation Process',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in question.availableMatchItems)
                    _DraggableAnswerBox(
                      item: item,
                      width: 158,
                      onTap: firstEmptyTarget == -1
                          ? null
                          : () => onAssigned(item, firstEmptyTarget),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Container(width: 1, height: 360, color: const Color(0xFFD5D5D5)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Action',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < question.targetItems.length; i++)
                _MatchingTargetRow(
                  questionNumber: question.number,
                  targetIndex: i,
                  actionText: question.targetItems[i],
                  assignedItem: question.matchingSelections[i],
                  onAssigned: onAssigned,
                  onCleared: () => onCleared(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExamSummaryScreen extends StatelessWidget {
  const ExamSummaryScreen({
    required this.session,
    required this.onQuestionSelected,
    super.key,
  });

  final ExamSessionState session;
  final ValueChanged<int> onQuestionSelected;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.fromLTRB(22, 18, 14, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Select any category column heading or icon to return to items in that category.',
                style: TextStyle(color: CompassColors.examNavy, fontSize: 14),
              ),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1380),
                child: Table(
                  border: const TableBorder(
                    horizontalInside: BorderSide(color: Colors.white),
                    verticalInside: BorderSide(color: Colors.white),
                  ),
                  columnWidths: const {
                    0: FixedColumnWidth(160),
                    1: FlexColumnWidth(2.8),
                    2: FixedColumnWidth(185),
                    3: FixedColumnWidth(185),
                    4: FixedColumnWidth(185),
                    5: FixedColumnWidth(185),
                  },
                  children: [
                    TableRow(
                      children: [
                        _headerCell('Question Number'),
                        _headerCell('Question Content'),
                        _countHeaderCell(
                          label: 'Answered',
                          value: session.answeredCount.toString(),
                          valueKey: const ValueKey('summary-answered-count'),
                        ),
                        _countHeaderCell(
                          label: 'Unanswered',
                          value: session.unansweredCount.toString(),
                          valueKey: const ValueKey('summary-unanswered-count'),
                        ),
                        _countHeaderCell(
                          label: 'Review',
                          value: session.reviewCount.toString(),
                          valueKey: const ValueKey('summary-review-count'),
                        ),
                        _countHeaderCell(
                          label: 'Leave Feedback',
                          value: session.feedbackCount.toString(),
                          valueKey: const ValueKey('summary-feedback-count'),
                        ),
                      ],
                    ),
                    for (final (index, question) in session.questions.indexed)
                      TableRow(
                        decoration: BoxDecoration(
                          color: question.number.isOdd
                              ? const Color(0xFFF1F2F3)
                              : Colors.white,
                        ),
                        children: [
                          _clickableBodyCell(
                            key: ValueKey(
                              'summary-row-${question.number}-number',
                            ),
                            onPressed: () => onQuestionSelected(index),
                            child: Text(
                              '${question.number}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          _clickableBodyCell(
                            key: ValueKey(
                              'summary-row-${question.number}-content',
                            ),
                            onPressed: () => onQuestionSelected(index),
                            child: Text(
                              question.prompt,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          _statusBodyCell(
                            key: ValueKey(
                              'summary-row-${question.number}-answered',
                            ),
                            active: question.isAnswered,
                            onPressed: () => onQuestionSelected(index),
                          ),
                          _statusBodyCell(
                            key: ValueKey(
                              'summary-row-${question.number}-unanswered',
                            ),
                            active: !question.isAnswered,
                            onPressed: () => onQuestionSelected(index),
                          ),
                          _statusBodyCell(
                            key: ValueKey(
                              'summary-row-${question.number}-review',
                            ),
                            active: question.markedForReview,
                            onPressed: () => onQuestionSelected(index),
                          ),
                          _statusBodyCell(
                            key: ValueKey(
                              'summary-row-${question.number}-feedback',
                            ),
                            active: question.markedForFeedback,
                            onPressed: () => onQuestionSelected(index),
                          ),
                        ],
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

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Text(
        text,
        style: const TextStyle(
          color: CompassColors.examNavy,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _countHeaderCell({
    required String label,
    required String value,
    required Key valueKey,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CompassColors.examNavy,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            key: valueKey,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyCell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }

  Widget _clickableBodyCell({
    required Key key,
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      key: key,
      mouseCursor: SystemMouseCursors.click,
      onTap: onPressed,
      child: _bodyCell(child),
    );
  }

  Widget _statusBodyCell({
    required Key key,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      key: key,
      mouseCursor: SystemMouseCursors.click,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Center(
          child: active
              ? const Icon(Icons.check, size: 22, color: Colors.black)
              : const SizedBox(width: 22, height: 22),
        ),
      ),
    );
  }
}

class _QuestionOptionTile extends StatelessWidget {
  const _QuestionOptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.control,
    required this.onPressed,
  });

  final String letter;
  final String text;
  final Widget control;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 10, 12, 0),
              child: control,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFC9D1D6)),
                  color: Colors.white,
                ),
                child: Text(
                  '$letter.  $text',
                  style: const TextStyle(fontSize: 15, height: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallRadioButton extends StatelessWidget {
  const _SmallRadioButton({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF8A8A8A), width: 1.2),
      ),
      child: selected
          ? Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CompassColors.examNavy,
              ),
            )
          : null,
    );
  }
}

class _SmallCheckbox extends StatelessWidget {
  const _SmallCheckbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF555555), width: 1.1),
      ),
      child: selected
          ? const Icon(Icons.check, size: 11, color: CompassColors.examNavy)
          : null,
    );
  }
}

class _DragColumn extends StatelessWidget {
  const _DragColumn({
    required this.title,
    required this.children,
    this.highlighted = false,
  });

  final String title;
  final List<Widget> children;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      constraints: const BoxConstraints(minHeight: 360),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF4F8FB) : Colors.white,
        border: Border.all(color: const Color(0xFFD7DDE1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DraggableAnswerBox extends StatelessWidget {
  const _DraggableAnswerBox({required this.item, this.width, this.onTap});

  final String item;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = _AnswerBox(width: width, text: item);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Draggable<String>(
          data: item,
          feedback: Material(
            color: Colors.transparent,
            child: _AnswerBox(width: width ?? 320, text: item, elevated: true),
          ),
          childWhenDragging: Opacity(opacity: 0.35, child: child),
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _OrderedAnswerBox extends StatelessWidget {
  const _OrderedAnswerBox({
    required this.item,
    required this.index,
    required this.totalItems,
    required this.onRemove,
    required this.onShifted,
  });

  final String item;
  final int index;
  final int totalItems;
  final VoidCallback onRemove;
  final OrderItemShifted onShifted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(child: _AnswerBox(text: item)),
          const SizedBox(width: 8),
          IconButton(
            key: ValueKey('order-item-$index-remove'),
            tooltip: 'Move back',
            icon: const Icon(Icons.chevron_left, size: 22),
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
          ),
          Column(
            children: [
              IconButton(
                key: ValueKey('order-item-$index-up'),
                tooltip: 'Move up',
                icon: const Icon(Icons.keyboard_arrow_up, size: 21),
                onPressed: index == 0 ? null : () => onShifted(index, -1),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                key: ValueKey('order-item-$index-down'),
                tooltip: 'Move down',
                icon: const Icon(Icons.keyboard_arrow_down, size: 21),
                onPressed: index == totalItems - 1
                    ? null
                    : () => onShifted(index, 1),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerBox extends StatelessWidget {
  const _AnswerBox({required this.text, this.width, this.elevated = false});

  final String text;
  final double? width;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 31),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF8398A4)),
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.2)),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Opacity(
        opacity: onPressed == null ? 0.35 : 1,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Icon(icon, color: Colors.black, size: 35),
        ),
      ),
    );
  }
}

class _EmptyDropMessage extends StatelessWidget {
  const _EmptyDropMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC9D1D6)),
      ),
      child: const Text(
        'Drag actions here',
        style: TextStyle(color: Color(0xFF7A8790), fontSize: 14),
      ),
    );
  }
}

class _MatchingTargetRow extends StatelessWidget {
  const _MatchingTargetRow({
    required this.questionNumber,
    required this.targetIndex,
    required this.actionText,
    required this.assignedItem,
    required this.onAssigned,
    required this.onCleared,
  });

  final int questionNumber;
  final int targetIndex;
  final String actionText;
  final String? assignedItem;
  final MatchItemAssigned onAssigned;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(actionText, style: const TextStyle(fontSize: 15)),
          ),
          const SizedBox(width: 16),
          DragTarget<String>(
            onAcceptWithDetails: (details) {
              onAssigned(details.data, targetIndex);
            },
            builder: (context, candidateData, rejectedData) {
              return InkWell(
                key: ValueKey('match-$questionNumber-target-$targetIndex'),
                mouseCursor: assignedItem == null
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                onTap: assignedItem == null ? null : onCleared,
                child: Container(
                  width: 154,
                  constraints: const BoxConstraints(minHeight: 43),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 5,
                  ),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty
                        ? const Color(0xFFF4F8FB)
                        : Colors.white,
                    border: Border.all(
                      color: const Color(0xFF9AA7AE),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: assignedItem == null
                      ? const SizedBox.shrink()
                      : Text(
                          assignedItem!,
                          style: const TextStyle(fontSize: 14, height: 1.15),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
