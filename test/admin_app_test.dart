import 'package:compass/admin/admin_app.dart';
import 'package:compass/admin/admin_models.dart';
import 'package:compass/admin/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin app shell opens with sidebar and records', (tester) async {
    final repository = FakeAdminRepository();

    await tester.pumpWidget(AdminApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Compass Admin'), findsOneWidget);
    expect(find.text('Test Centers'), findsWidgets);
    expect(find.text('Edu Action LLC.'), findsWidgets);
    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('candidate form validates required fields and saves payload', (
    tester,
  ) async {
    final repository = FakeAdminRepository();

    await tester.pumpWidget(AdminApp(repository: repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Candidates').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('New'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsWidgets);
    final passwordEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(EditableText),
      ),
    );
    expect(passwordEditable.obscureText, isTrue);

    await _enterTextField(tester, 'Username', 'student.demo');
    await _enterTextField(tester, 'Password', 'Compass2026');
    await _enterTextField(tester, 'Email', 'student@example.com');
    await _enterTextField(tester, 'Display Name', 'Student Demo');
    await _enterTextField(tester, 'Candidate Identifier', 'CAND-DEMO-001');
    await _enterTextField(tester, 'Score', '740');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repository.lastSavedSection?.table, 'candidates');
    expect(repository.lastPayload?['username'], 'student.demo');
    expect(repository.lastPayload?['password'], 'Compass2026');
    expect(repository.lastPayload?['score'], 740);
  });

  testWidgets('question editor validates options and saves complete draft', (
    tester,
  ) async {
    final repository = FakeAdminRepository();

    await tester.pumpWidget(AdminApp(repository: repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Questions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('New'));
    await tester.pumpAndSettle();

    await _selectFirstDropdownValue(tester, 'IC3 Digital Literacy GS6 Level 1');
    await _enterTextField(tester, 'Number', '46');
    await _enterTextField(tester, 'Prompt', 'Choose the safest action.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('Single choice questions need at least 2 answer options.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await _enterTextField(
      tester,
      'Answer Options',
      'Use a strong password\nShare the password',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repository.lastQuestionDraft?.number, 46);
    expect(repository.lastQuestionDraft?.type, 'singleChoice');
    expect(repository.lastQuestionDraft?.options.length, 2);
  });

  testWidgets('delete is blocked when related records exist', (tester) async {
    final repository = FakeAdminRepository(blockers: ['candidates']);

    await tester.pumpWidget(AdminApp(repository: repository));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Cannot delete'), findsOneWidget);
    expect(repository.deletedId, isNull);
  });
}

Future<void> _enterTextField(
  WidgetTester tester,
  String label,
  String value,
) async {
  final finder = find.widgetWithText(TextFormField, label);
  final scrollable = find.byType(Scrollable).last;
  await tester.scrollUntilVisible(
    finder,
    180,
    scrollable: scrollable,
    maxScrolls: 20,
  );
  await tester.enterText(finder, value);
  await tester.pumpAndSettle();
}

Future<void> _selectFirstDropdownValue(
  WidgetTester tester,
  String value,
) async {
  await tester.tap(find.byType(DropdownButtonFormField<String>).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(value).last);
  await tester.pumpAndSettle();
}

class FakeAdminRepository implements AdminRepository {
  FakeAdminRepository({this.blockers = const []}) : snapshot = _snapshot();

  AdminSnapshot snapshot;
  final List<String> blockers;
  AdminSectionConfig? lastSavedSection;
  Map<String, dynamic>? lastPayload;
  AdminQuestionDraft? lastQuestionDraft;
  String? deletedId;

  @override
  Future<AdminSnapshot> loadSnapshot() async => snapshot;

  @override
  Future<void> saveRecord({
    required AdminSectionConfig section,
    required String? id,
    required Map<String, dynamic> payload,
  }) async {
    lastSavedSection = section;
    lastPayload = payload;
  }

  @override
  Future<void> saveQuestion(AdminQuestionDraft draft) async {
    lastQuestionDraft = draft;
  }

  @override
  Future<List<String>> deleteBlockersFor({
    required AdminSectionConfig section,
    required String id,
  }) async {
    return blockers;
  }

  @override
  Future<void> deleteRecord({
    required AdminSectionConfig section,
    required String id,
  }) async {
    deletedId = id;
  }
}

AdminSnapshot _snapshot() {
  final tables = <String, List<AdminRecord>>{
    for (final section in allAdminSections) section.table: <AdminRecord>[],
    'question_options': <AdminRecord>[],
    'question_matrix_rows': <AdminRecord>[],
    'question_match_items': <AdminRecord>[],
  };

  tables['test_centers'] = [
    {
      'id': 'center-1',
      'name': 'Edu Action LLC.',
      'code': 'EDU-ACTION',
      'created_at': '2026-04-30T00:00:00Z',
    },
  ];
  tables['programs'] = [
    {'id': 'program-1', 'name': 'IC3 Digital Literacy', 'sort_order': 1},
  ];
  tables['exams'] = [
    {
      'id': 'exam-1',
      'program_id': 'program-1',
      'title': 'IC3 Digital Literacy GS6 Level 1',
      'short_title': 'IC3 GS6 Level 1',
      'code': 'IC3-GS6-L1',
      'duration_minutes': 50,
      'question_count': 45,
      'pass_score': 700,
      'language': 'English',
      'sort_order': 1,
    },
  ];
  tables['candidates'] = [
    {
      'id': 'candidate-1',
      'test_center_id': 'center-1',
      'username': 'student',
      'password': 'Compass2026',
      'email': 'student@example.com',
      'display_name': 'Student Demo',
      'candidate_identifier': 'CAND-001',
      'score': 700,
      'address_line1': '',
      'address_line2': '',
      'city': '',
      'postal_code': '',
      'country': '',
    },
  ];
  tables['questions'] = [
    {
      'id': 'question-1',
      'exam_id': 'exam-1',
      'number': 1,
      'prompt': 'Choose the best answer.',
      'prompt_details': <String>[],
      'type': 'singleChoice',
      'required_selections': 1,
    },
  ];
  tables['question_options'] = [
    {
      'id': 'option-1',
      'question_id': 'question-1',
      'position': 1,
      'label': 'First option',
    },
    {
      'id': 'option-2',
      'question_id': 'question-1',
      'position': 2,
      'label': 'Second option',
    },
  ];

  return AdminSnapshot(tables);
}
