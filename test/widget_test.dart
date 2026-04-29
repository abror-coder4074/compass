import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:compass/ui/compass_home.dart';
import 'package:compass/ui/compass_theme.dart';
import 'package:compass/ui/exam/exam_flow.dart';
import 'package:compass/ui/exam/exam_models.dart';

void main() {
  test('mixed question answered states require complete responses', () {
    final checkboxQuestion = ExamQuestion(
      number: 1,
      type: ExamQuestionType.multipleChoice,
      prompt: 'Choose two actions.',
      requiredSelections: 2,
      options: const ['One', 'Two', 'Three'],
    );
    checkboxQuestion.selectedOptions.add('A');
    expect(checkboxQuestion.isAnswered, isFalse);
    checkboxQuestion.selectedOptions.add('B');
    expect(checkboxQuestion.isAnswered, isTrue);

    final matrixQuestion = ExamQuestion(
      number: 2,
      type: ExamQuestionType.matrix,
      prompt: 'Select yes or no.',
      matrixColumns: const ['Yes', 'No'],
      matrixRows: const ['First row', 'Second row'],
    );
    matrixQuestion.matrixSelections[0] = 'Yes';
    expect(matrixQuestion.isAnswered, isFalse);
    matrixQuestion.matrixSelections[1] = 'No';
    expect(matrixQuestion.isAnswered, isTrue);

    final orderingQuestion = ExamQuestion(
      number: 3,
      type: ExamQuestionType.ordering,
      prompt: 'Order the tasks.',
      sourceItems: const ['First', 'Second'],
    );
    orderingQuestion.availableOrderItems.remove('First');
    orderingQuestion.orderedItems.add('First');
    expect(orderingQuestion.isAnswered, isFalse);
    orderingQuestion.availableOrderItems.remove('Second');
    orderingQuestion.orderedItems.add('Second');
    expect(orderingQuestion.isAnswered, isTrue);

    final matchingQuestion = ExamQuestion(
      number: 4,
      type: ExamQuestionType.matching,
      prompt: 'Match items.',
      sourceItems: const ['Left A', 'Left B'],
      targetItems: const ['Right A', 'Right B'],
    );
    matchingQuestion.matchingSelections[0] = 'Left A';
    expect(matchingQuestion.isAnswered, isFalse);
    matchingQuestion.matchingSelections[1] = 'Left B';
    expect(matchingQuestion.isAnswered, isTrue);
  });

  testWidgets('login opens mailing address step', (WidgetTester tester) async {
    await _pumpHome(tester);

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Close Window'), findsOneWidget);

    await _tapButton(tester, 'Login');

    expect(find.text('Mailing address'), findsOneWidget);
    expect(find.text('Accept All Cookies'), findsNothing);
    expect(find.text('Ziyolilar ko\'chasi, 9-uy'), findsOneWidget);
  });

  testWidgets('candidate portal reaches NDA and gates Next until accepted', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester);
    await _tapButton(tester, 'Login');
    await _tapButton(tester, 'Continue');

    expect(
      find.text('Welcome Certiport, let\'s get ready for your exam!'),
      findsOneWidget,
    );
    expect(
      find.text('Do you have a Voucher to use for payment today?'),
      findsOneWidget,
    );
    final voucherToggle = find.byKey(
      const ValueKey('readiness-voucher-toggle'),
    );
    await tester.ensureVisible(voucherToggle);
    await tester.tap(voucherToggle);
    await tester.pumpAndSettle();
    final voucherInput = find.byKey(const ValueKey('readiness-voucher-input'));
    await tester.ensureVisible(voucherInput);
    await tester.enterText(voucherInput, '3075-hz25-5gvy-3x5p');
    await tester.pumpAndSettle();
    expect(find.text('3075-HZ25-5GVY-3X5P'), findsOneWidget);

    await _tapButton(tester, 'Next');

    expect(find.text('Select Your Exam'), findsOneWidget);
    expect(find.text('IC3 Digital Literacy Certification'), findsOneWidget);

    await _tapElevatedButton(tester, 'Select exam');

    expect(
      find.text('Non-Disclosure Agreement and Terms of Use'),
      findsOneWidget,
    );

    final disabledNext = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Next'),
    );
    expect(disabledNext.onPressed, isNull);

    await _tapText(tester, 'Yes, I accept');

    final enabledNext = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Next'),
    );
    expect(enabledNext.onPressed, isNotNull);
  });

  testWidgets('voucher remove clears exam select and payment state', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester);
    await _tapButton(tester, 'Login');
    await _tapButton(tester, 'Continue');

    final voucherToggle = find.byKey(
      const ValueKey('readiness-voucher-toggle'),
    );
    await tester.ensureVisible(voucherToggle);
    await tester.tap(voucherToggle);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('readiness-voucher-input')),
      '3075-hz25-5gvy-3x5p',
    );
    await tester.pumpAndSettle();
    await _tapButton(tester, 'Next');

    expect(find.text('Voucher'), findsOneWidget);
    expect(find.text('3075-HZ25-5GVY-3X5P'), findsOneWidget);

    await _tapButton(tester, 'Remove');

    expect(find.text('Voucher'), findsNothing);
    expect(find.text('3075-HZ25-5GVY-3X5P'), findsNothing);

    await _tapElevatedButton(tester, 'Select exam');
    await _tapText(tester, 'Yes, I accept');
    await _tapButton(tester, 'Next');

    expect(find.text('No voucher'), findsOneWidget);
    expect(find.text('3075-HZ25-5GVY-3X5P'), findsNothing);
  });

  testWidgets('unlock, system check, and Start Exam callback are wired', (
    WidgetTester tester,
  ) async {
    var startExamCalls = 0;
    await _pumpHome(
      tester,
      onStartExam: () async {
        startExamCalls += 1;
      },
    );

    await _advanceToNda(tester);
    await _tapText(tester, 'Yes, I accept');
    await _tapButton(tester, 'Next');

    expect(find.text('Verify & Unlock Exam'), findsOneWidget);
    expect(find.text('Edu Action LLC.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'proctor.demo');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'Compass2026');
    await tester.pumpAndSettle();
    await _tapButton(tester, 'Continue');

    expect(find.text('IC3 GS6 Level 1'), findsOneWidget);
    expect(find.text('VBScript'), findsOneWidget);

    await _tapButton(tester, 'Next');

    expect(find.text('Welcome, Certiport!'), findsOneWidget);
    expect(find.text('Start Exam'), findsOneWidget);

    await _tapButton(tester, 'Start Exam');

    expect(startExamCalls, 1);
  });

  testWidgets('survey transitions to tutorial and timed questions', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester, examLockdownMode: true);

    expect(find.text('Survey 1 of 1'), findsOneWidget);
    expect(find.text('Close Window'), findsNothing);
    expect(find.text('Tools'), findsOneWidget);

    await _tapButton(tester, 'Next');

    expect(find.text('Tutorial'), findsOneWidget);
    expect(find.text('Exam Process'), findsOneWidget);

    await _tapButton(tester, 'Start Exam');

    expect(find.text('Question 1 of 45'), findsOneWidget);
    expect(find.text('Time Remaining 00:50:00'), findsOneWidget);
  });

  testWidgets('answers and flags are reflected in exam summary', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester, examLockdownMode: true);

    await _tapButton(tester, 'Next');
    await _tapButton(tester, 'Start Exam');
    await _tapText(
      tester,
      'B.  Use a unique password and lock the screen before walking away.',
    );
    await _tapText(tester, 'Mark for Review');
    await _tapText(tester, 'Mark for Feedback');
    await _tapText(tester, 'Go To Summary');

    expect(find.text('Exam Summary'), findsOneWidget);

    final answeredCount = tester.widget<Text>(
      find.byKey(const ValueKey('summary-answered-count')),
    );
    final unansweredCount = tester.widget<Text>(
      find.byKey(const ValueKey('summary-unanswered-count')),
    );
    final reviewCount = tester.widget<Text>(
      find.byKey(const ValueKey('summary-review-count')),
    );
    final feedbackCount = tester.widget<Text>(
      find.byKey(const ValueKey('summary-feedback-count')),
    );

    expect(answeredCount.data, '1');
    expect(unansweredCount.data, '44');
    expect(reviewCount.data, '1');
    expect(feedbackCount.data, '1');
  });

  testWidgets('matching, ordering, and checkbox questions update summary', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester, examLockdownMode: true);

    await _advanceToQuestion(tester, 34);
    expect(find.text('Media Creation Process'), findsOneWidget);
    await _tapText(tester, 'Capture video');
    await _tapText(tester, 'Finalize production');
    await _tapText(tester, 'Distribute video');

    await _tapButton(tester, 'Next');
    expect(find.text('Actions in Order'), findsOneWidget);
    await _tapText(tester, 'Develop the prototype');
    await _tapText(tester, 'Identify project requirements');
    await _tapText(tester, 'Generate ideas');
    await _tapText(tester, 'Test the prototype');
    await _tapText(tester, 'Refine the prototype');

    await _tapButton(tester, 'Next');
    expect(find.text('Question 36 of 45'), findsOneWidget);
    await _tapText(
      tester,
      'A.  After the client presents ideas, paraphrase what they said.',
    );
    await _tapText(
      tester,
      'B.  Tell the client that you will email a draft proposal that includes deadlines.',
    );
    await _tapText(
      tester,
      'D.  Decide with the client which forms of digital communication to use during the project.',
    );

    await _tapText(tester, 'Go To Summary');

    expect(_summaryCount(tester, 'answered'), '3');
    expect(_summaryCount(tester, 'unanswered'), '42');
  });

  testWidgets('matrix question counts after every row is answered', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester, examLockdownMode: true);

    await _advanceToQuestion(tester, 41);
    expect(find.text('Answer Area'), findsOneWidget);
    await _tapByKey(tester, const ValueKey('matrix-41-row-0-Yes'));
    await _tapByKey(tester, const ValueKey('matrix-41-row-1-Yes'));
    await _tapByKey(tester, const ValueKey('matrix-41-row-2-Yes'));
    await _tapByKey(tester, const ValueKey('matrix-41-row-3-No'));

    await _tapText(tester, 'Go To Summary');

    expect(_summaryCount(tester, 'answered'), '1');
    expect(_summaryCount(tester, 'unanswered'), '44');
  });

  testWidgets('time dialogs appear automatically after opening summary', (
    WidgetTester tester,
  ) async {
    await _pumpHome(
      tester,
      examLockdownMode: true,
      examTimerConfig: const ExamTimerConfig(
        initialDuration: Duration(seconds: 10),
        warningThreshold: Duration(seconds: 5),
      ),
    );

    await _tapButton(tester, 'Next');
    await _tapButton(tester, 'Start Exam');
    await _tapText(tester, 'Go To Summary');

    expect(find.text('Exam Summary'), findsOneWidget);
    expect(find.text('5-Minute Warning'), findsNothing);
    expect(find.text('Timeout'), findsNothing);

    await _openToolsMenu(tester);
    expect(find.text('Show 5-Minute Warning'), findsNothing);
    expect(find.text('Simulate Timeout'), findsNothing);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));

    expect(find.text('5-Minute Warning'), findsOneWidget);
    await _tapButton(tester, 'Continue');

    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Timeout'), findsOneWidget);
    final timeoutFinishButton = find.descendant(
      of: find.byType(Dialog),
      matching: find.widgetWithText(ElevatedButton, 'Finish Exam'),
    );
    await tester.tap(timeoutFinishButton);
    await tester.pumpAndSettle();

    expect(find.text('Exam Summary'), findsOneWidget);
    expect(find.text('Time Remaining 00:00:00'), findsOneWidget);
  });

  testWidgets(
    'summary finish opens feedback intro while lockdown remains active',
    (WidgetTester tester) async {
      await _pumpHome(tester, examLockdownMode: true);

      await _advanceToFeedbackIntro(tester);

      expect(find.text('Leave feedback about exam items'), findsOneWidget);
      expect(find.text('Skip Feedback'), findsOneWidget);
      expect(find.text('Start Feedback'), findsOneWidget);
    },
  );

  testWidgets('skip feedback opens feedback form', (WidgetTester tester) async {
    var exitSecureCalls = 0;

    await _pumpHome(
      tester,
      examLockdownMode: true,
      onExitSecureWorkspace: () async {
        exitSecureCalls += 1;
      },
    );

    await _advanceToFeedbackIntro(tester);
    await _tapButton(tester, 'Skip Feedback');

    expect(exitSecureCalls, 0);
    expect(
      find.byKey(const ValueKey('exam-feedback-textarea')),
      findsOneWidget,
    );
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('feedback form reaches thank you and exits to score summary', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester, examLockdownMode: true);

    await _advanceToFeedbackIntro(tester);
    await _tapButton(tester, 'Start Feedback');

    expect(
      find.byKey(const ValueKey('exam-feedback-textarea')),
      findsOneWidget,
    );
    await tester.enterText(
      find.byKey(const ValueKey('exam-feedback-textarea')),
      'The exam interface was clear and responsive.',
    );
    await tester.pumpAndSettle();
    await _tapButton(tester, 'Next');

    expect(
      find.text(
        'Thank you for taking the IC3 Digital Literacy GS6 Level 1 exam.',
      ),
      findsOneWidget,
    );
    await _tapButton(tester, 'Exit Exam');

    expect(find.text('Exam Score Summary and Pathways'), findsOneWidget);
  });

  testWidgets('score summary updates email, opens pathways, and full report', (
    WidgetTester tester,
  ) async {
    await _pumpHome(tester, examLockdownMode: true);

    await _advanceToFeedbackIntro(tester);
    await _tapButton(tester, 'Skip Feedback');
    await _tapButton(tester, 'Next');
    await _tapButton(tester, 'Exit Exam');

    await _tapButton(tester, 'Update Email Address');
    await tester.enterText(
      find.byKey(const ValueKey('score-summary-email-input')),
      'alex.updated@example.com',
    );
    await tester.pumpAndSettle();
    await _tapButton(tester, 'Save');

    expect(find.text('alex.updated@example.com'), findsOneWidget);

    await _tapButton(tester, 'View Pathways Details');
    expect(find.text('IC3 Digital Literacy GS6 Master'), findsWidgets);
    await _tapButton(tester, 'Close');

    await _tapButton(tester, 'View Full Score Report');
    expect(find.text('EXAM SCORE REPORT'), findsOneWidget);
    expect(find.text('CANDIDATE'), findsOneWidget);
    expect(find.text('FINAL SCORE'), findsOneWidget);
    expect(find.text('Your Score'), findsWidgets);
  });

  testWidgets('tools close window delegates to blocked exit callback', (
    WidgetTester tester,
  ) async {
    var blockedExitCalls = 0;

    await _pumpHome(
      tester,
      examLockdownMode: true,
      onBlockedExit: ({title, message}) async {
        blockedExitCalls += 1;
      },
    );

    await _openToolsMenu(tester);
    await _tapText(tester, 'Close Window');

    expect(blockedExitCalls, 1);
  });
}

Future<void> _pumpHome(
  WidgetTester tester, {
  bool examLockdownMode = false,
  Future<void> Function()? onStartExam,
  Future<void> Function()? onExitSecureWorkspace,
  Future<void> Function({String? title, String? message})? onBlockedExit,
  ExamTimerConfig examTimerConfig = const ExamTimerConfig(),
}) async {
  var lockdown = examLockdownMode;

  await tester.pumpWidget(
    MaterialApp(
      theme: buildCompassTheme(),
      home: StatefulBuilder(
        builder: (context, setState) {
          return CompassHome(
            examLockdownMode: lockdown,
            onStartExam: onStartExam ?? () async {},
            onExitSecureWorkspace: () async {
              setState(() {
                lockdown = false;
              });
              await onExitSecureWorkspace?.call();
            },
            onCloseWindow: () async {},
            onBlockedExit: onBlockedExit ?? ({title, message}) async {},
            examTimerConfig: examTimerConfig,
          );
        },
      ),
    ),
  );
}

Future<void> _advanceToNda(WidgetTester tester) async {
  await _tapButton(tester, 'Login');
  await _tapButton(tester, 'Continue');
  await _tapButton(tester, 'Next');
  await _tapElevatedButton(tester, 'Select exam');
}

Future<void> _advanceToFeedbackIntro(WidgetTester tester) async {
  await _tapButton(tester, 'Next');
  await _tapButton(tester, 'Start Exam');
  await _tapText(tester, 'Go To Summary');
  await _tapButton(tester, 'Finish Exam');
}

Future<void> _advanceToQuestion(WidgetTester tester, int questionNumber) async {
  await _tapButton(tester, 'Next');
  await _tapButton(tester, 'Start Exam');

  for (
    var currentQuestion = 1;
    currentQuestion < questionNumber;
    currentQuestion++
  ) {
    await _tapButton(tester, 'Next');
  }

  expect(find.text('Question $questionNumber of 45'), findsOneWidget);
}

String _summaryCount(WidgetTester tester, String status) {
  final text = tester.widget<Text>(
    find.byKey(ValueKey('summary-$status-count')),
  );
  return text.data ?? '';
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> _tapByKey(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapButton(WidgetTester tester, String text) async {
  final elevated = find.widgetWithText(ElevatedButton, text);
  if (elevated.evaluate().isNotEmpty) {
    await tester.ensureVisible(elevated.first);
    await tester.tap(elevated.first);
    await tester.pumpAndSettle();
    return;
  }

  final outlined = find.widgetWithText(OutlinedButton, text);
  if (outlined.evaluate().isNotEmpty) {
    await tester.ensureVisible(outlined.first);
    await tester.tap(outlined.first);
    await tester.pumpAndSettle();
    return;
  }

  await _tapText(tester, text);
}

Future<void> _tapElevatedButton(WidgetTester tester, String text) async {
  final finder = find.widgetWithText(ElevatedButton, text);
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> _openToolsMenu(WidgetTester tester) async {
  await tester.tap(find.text('Tools').first);
  await tester.pumpAndSettle();
}
