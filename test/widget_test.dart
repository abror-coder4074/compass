import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:compass/main.dart';
import 'package:compass/ui/compass_theme.dart';

void main() {
  testWidgets('shows portal shell, footer close, and secure exam action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCompassTheme(),
        home: CompassHome(
          examLockdownMode: false,
          onStartExam: () async {},
          onFinishExam: () async {},
          onCloseWindow: () async {},
          onBlockedExit: ({title, message}) async {},
        ),
      ),
    );

    expect(
      find.text('Welcome Certiport, let\'s get ready for your exam!'),
      findsOneWidget,
    );
    expect(find.text('Close Window'), findsOneWidget);
    expect(find.text('Start Secure Exam'), findsOneWidget);
  });

  testWidgets('shows lockdown exam shell and finish action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCompassTheme(),
        home: CompassHome(
          examLockdownMode: true,
          onStartExam: () async {},
          onFinishExam: () async {},
          onCloseWindow: () async {},
          onBlockedExit: ({title, message}) async {},
        ),
      ),
    );

    expect(find.text('Survey 1 of 1'), findsOneWidget);
    expect(find.text('Close Window'), findsNothing);
    expect(find.text('Finish Exam'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
  });
}
