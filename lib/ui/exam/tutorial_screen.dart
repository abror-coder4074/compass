import 'package:flutter/material.dart';

import '../compass_theme.dart';
import 'exam_mock_data.dart';
import 'tutorial_sample_question.dart';

class ExamTutorialScreen extends StatelessWidget {
  const ExamTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 13,
      radius: Radius.zero,
      child: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.fromLTRB(16, 24, 26, 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
              decoration: BoxDecoration(
                color: CompassColors.examNavy,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Center(
                child: Text(
                  tutorialExamTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TutorialBullet(
                    text: 'This exam has ',
                    strongText: '45 questions.',
                  ),
                  SizedBox(height: 8),
                  _TutorialBullet(
                    text: 'The maximum exam time is ',
                    strongText: '50 minutes.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const _TutorialHeading('Exam Process'),
            const SizedBox(height: 17),
            const Text(
              'The exam experience follows this process:',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 18),
            const _TutorialStep(
              index: '1.',
              title: 'Tutorial.',
              body:
                  'The tutorial (this page) provides helpful information about the exam environment. ',
              linkText: 'Read the tutorial carefully.',
              afterLink:
                  ' When you are ready to begin taking the exam, select ',
              ending: 'Start Exam.',
            ),
            const _TutorialStep(
              index: '2.',
              title: 'Exam Questions.',
              body:
                  'The exam timer starts and the questions appear. You can move forward and back through them, answer them, and mark them for review or feedback.',
            ),
            const _TutorialStep(
              index: '3.',
              title: 'Exam Summary.',
              body:
                  'The exam summary indicates the questions you have answered, not answered, marked for review, and marked for feedback. You can review and change your answers. The exam timer stops and your answers are submitted when you select ',
              ending: 'Finish Exam.',
            ),
            const _TutorialStep(
              index: '4.',
              title: 'Feedback.',
              body:
                  'You can leave feedback about the exam and individual questions. When you finish leaving feedback, select ',
              ending: 'Exit Exam to display your score report.',
            ),
            const SizedBox(height: 24),
            const _TutorialHeading('Exam Interface and Controls'),
            const SizedBox(height: 17),
            const Text(
              'Each page of the exam has three panes.',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 22),
            const TutorialSampleQuestionCard(),
            const SizedBox(height: 26),
            const _CalloutExplanation(
              number: '1',
              title: 'Question information pane',
              text:
                  'The top pane shows your current question number, the total number of questions, the time remaining, and your progress through the exam.',
            ),
            const _CalloutExplanation(
              number: '2',
              title: 'Question and answer pane',
              text:
                  'The main pane displays the question scenario and the available responses. Select the option that best answers the question.',
            ),
            const SizedBox(height: 18),
            const _TutorialHeading('Answering Questions'),
            const SizedBox(height: 12),
            const _TutorialParagraph(
              'Select one answer for each question unless the question instructions tell you to do something different. You can change your answer before you finish the exam by selecting another option.',
            ),
            const _TutorialParagraph(
              'Some questions may include tables, pictures, or task instructions. Read every instruction before selecting Next. If a question includes a scroll bar, scroll through the full content before answering.',
            ),
            const SizedBox(height: 14),
            const _TutorialHeading('Navigation'),
            const SizedBox(height: 12),
            const _TutorialParagraph(
              'Use Next to continue to the next question. Use Back to return to the previous question. You can also select Go To Summary to review the status of all questions.',
            ),
            const _TutorialParagraph(
              'Use Mark for Review if you want to return to a question later. Use Mark for Feedback when you want to leave a comment about the question after the exam is finished.',
            ),
            const SizedBox(height: 14),
            const _TutorialHeading('Tools'),
            const SizedBox(height: 12),
            const _TutorialParagraph(
              'The Tools menu remains available during the exam. It may include help, calculator, or other exam tools depending on the exam configuration.',
            ),
            const _TutorialParagraph(
              'The timer continues while you use tools or review questions. The timer stops only after you finish the exam or the maximum exam time is reached.',
            ),
            const SizedBox(height: 14),
            const _TutorialHeading('Exam Summary'),
            const SizedBox(height: 12),
            const _TutorialParagraph(
              'The Exam Summary shows which questions are answered, unanswered, marked for review, and marked for feedback. You can return to questions from the summary before selecting Finish Exam.',
            ),
            const _TutorialParagraph(
              'When you select Finish Exam, your answers are submitted and you can no longer return to the questions.',
            ),
            const SizedBox(height: 14),
            const _TutorialHeading('After the Exam'),
            const SizedBox(height: 12),
            const _TutorialParagraph(
              'After finishing the exam, you may be asked to leave feedback. When the feedback process is complete, your score report is displayed.',
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _TutorialHeading extends StatelessWidget {
  const _TutorialHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: CompassColors.examNavy,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TutorialBullet extends StatelessWidget {
  const _TutorialBullet({required this.text, required this.strongText});

  final String text;
  final String strongText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 17, height: 1.38),
        children: [
          const TextSpan(text: '\u2022   '),
          TextSpan(text: text),
          TextSpan(
            text: strongText,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _TutorialStep extends StatelessWidget {
  const _TutorialStep({
    required this.index,
    required this.title,
    required this.body,
    this.linkText,
    this.afterLink,
    this.ending,
  });

  final String index;
  final String title;
  final String body;
  final String? linkText;
  final String? afterLink;
  final String? ending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              index,
              style: const TextStyle(fontSize: 17, height: 1.38),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  height: 1.38,
                ),
                children: [
                  TextSpan(
                    text: '$title ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: body),
                  if (linkText != null)
                    TextSpan(
                      text: linkText,
                      style: const TextStyle(
                        color: Color(0xFF0070B8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (afterLink != null) TextSpan(text: afterLink),
                  if (ending != null)
                    TextSpan(
                      text: ending,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalloutExplanation extends StatelessWidget {
  const _CalloutExplanation({
    required this.number,
    required this.title,
    required this.text,
  });

  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TutorialRedGuideMarker(number),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.38,
                  ),
                  children: [
                    TextSpan(
                      text: '$title. ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: text),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialParagraph extends StatelessWidget {
  const _TutorialParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.45)),
    );
  }
}
