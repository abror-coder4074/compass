typedef AdminRecord = Map<String, dynamic>;

enum AdminFieldKind { text, multiline, integer, relation, select }

class AdminFieldConfig {
  const AdminFieldConfig({
    required this.key,
    required this.label,
    this.kind = AdminFieldKind.text,
    this.required = false,
    this.nullable = false,
    this.relationTable,
    this.relationLabelKey,
    this.options = const [],
    this.defaultValue,
  });

  final String key;
  final String label;
  final AdminFieldKind kind;
  final bool required;
  final bool nullable;
  final String? relationTable;
  final String? relationLabelKey;
  final List<String> options;
  final Object? defaultValue;
}

class AdminSectionConfig {
  const AdminSectionConfig({
    required this.id,
    required this.title,
    required this.table,
    required this.columns,
    required this.fields,
    required this.displayColumn,
    this.description = '',
    this.editable = true,
    this.questionEditor = false,
  });

  final String id;
  final String title;
  final String table;
  final List<String> columns;
  final List<AdminFieldConfig> fields;
  final String displayColumn;
  final String description;
  final bool editable;
  final bool questionEditor;
}

class AdminSnapshot {
  const AdminSnapshot(this.tables);

  final Map<String, List<AdminRecord>> tables;

  List<AdminRecord> records(String table) => tables[table] ?? const [];

  AdminRecord? recordById(String table, Object? id) {
    if (id == null) {
      return null;
    }
    for (final record in records(table)) {
      if (record['id']?.toString() == id.toString()) {
        return record;
      }
    }
    return null;
  }

  String labelFor(String table, Object? id, {String? labelKey}) {
    final record = recordById(table, id);
    if (record == null) {
      return id?.toString() ?? '';
    }
    final preferredKey = labelKey ?? defaultLabelKeyForTable(table);
    final preferredValue = record[preferredKey]?.toString();
    if (preferredValue != null && preferredValue.trim().isNotEmpty) {
      return preferredValue;
    }
    return record['id']?.toString() ?? '';
  }
}

class DeleteBlocker {
  const DeleteBlocker({
    required this.table,
    required this.foreignKey,
    required this.label,
  });

  final String table;
  final String foreignKey;
  final String label;
}

class AdminQuestionDraft {
  const AdminQuestionDraft({
    this.id,
    required this.examId,
    required this.number,
    required this.prompt,
    required this.promptDetails,
    required this.type,
    required this.requiredSelections,
    required this.options,
    required this.matrixRows,
    required this.sourceItems,
    required this.targetItems,
  });

  final String? id;
  final String examId;
  final int number;
  final String prompt;
  final List<String> promptDetails;
  final String type;
  final int requiredSelections;
  final List<String> options;
  final List<String> matrixRows;
  final List<String> sourceItems;
  final List<String> targetItems;

  Map<String, dynamic> toQuestionPayload() {
    return {
      'exam_id': examId,
      'number': number,
      'prompt': prompt,
      'prompt_details': promptDetails,
      'type': type,
      'required_selections': requiredSelections,
    };
  }
}

const editableAdminSections = <AdminSectionConfig>[
  AdminSectionConfig(
    id: 'test_centers',
    title: 'Test Centers',
    table: 'test_centers',
    displayColumn: 'name',
    description: 'Testing center names and codes.',
    columns: ['name', 'code', 'created_at'],
    fields: [
      AdminFieldConfig(key: 'name', label: 'Name', required: true),
      AdminFieldConfig(key: 'code', label: 'Code', required: true),
    ],
  ),
  AdminSectionConfig(
    id: 'candidates',
    title: 'Candidates',
    table: 'candidates',
    displayColumn: 'display_name',
    description: 'Candidate accounts used by the Compass login screen.',
    columns: [
      'display_name',
      'username',
      'email',
      'candidate_identifier',
      'score',
      'test_center_id',
    ],
    fields: [
      AdminFieldConfig(
        key: 'test_center_id',
        label: 'Test Center',
        kind: AdminFieldKind.relation,
        relationTable: 'test_centers',
        relationLabelKey: 'name',
        nullable: true,
      ),
      AdminFieldConfig(key: 'username', label: 'Username', required: true),
      AdminFieldConfig(key: 'password', label: 'Password', required: true),
      AdminFieldConfig(key: 'email', label: 'Email', required: true),
      AdminFieldConfig(
        key: 'display_name',
        label: 'Display Name',
        required: true,
      ),
      AdminFieldConfig(
        key: 'candidate_identifier',
        label: 'Candidate Identifier',
        required: true,
      ),
      AdminFieldConfig(
        key: 'score',
        label: 'Score',
        kind: AdminFieldKind.integer,
        required: true,
        defaultValue: 700,
      ),
      AdminFieldConfig(key: 'address_line1', label: 'Address Line 1'),
      AdminFieldConfig(key: 'address_line2', label: 'Address Line 2'),
      AdminFieldConfig(key: 'city', label: 'City'),
      AdminFieldConfig(key: 'postal_code', label: 'Postal Code'),
      AdminFieldConfig(key: 'country', label: 'Country'),
    ],
  ),
  AdminSectionConfig(
    id: 'proctors',
    title: 'Proctors',
    table: 'proctors',
    displayColumn: 'display_name',
    description: 'Proctor credentials used on the unlock screen.',
    columns: ['display_name', 'username', 'test_center_id', 'created_at'],
    fields: [
      AdminFieldConfig(
        key: 'test_center_id',
        label: 'Test Center',
        kind: AdminFieldKind.relation,
        relationTable: 'test_centers',
        relationLabelKey: 'name',
        nullable: true,
      ),
      AdminFieldConfig(key: 'username', label: 'Username', required: true),
      AdminFieldConfig(key: 'password', label: 'Password', required: true),
      AdminFieldConfig(
        key: 'display_name',
        label: 'Display Name',
        required: true,
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'programs',
    title: 'Programs',
    table: 'programs',
    displayColumn: 'name',
    description: 'Top-level program groups shown in exam selection.',
    columns: ['name', 'sort_order'],
    fields: [
      AdminFieldConfig(key: 'name', label: 'Name', required: true),
      AdminFieldConfig(
        key: 'sort_order',
        label: 'Sort Order',
        kind: AdminFieldKind.integer,
        defaultValue: 0,
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'exams',
    title: 'Exams',
    table: 'exams',
    displayColumn: 'title',
    description: 'Exam metadata used by portal selection and score reports.',
    columns: ['title', 'code', 'program_id', 'duration_minutes', 'pass_score'],
    fields: [
      AdminFieldConfig(
        key: 'program_id',
        label: 'Program',
        kind: AdminFieldKind.relation,
        relationTable: 'programs',
        relationLabelKey: 'name',
        nullable: true,
      ),
      AdminFieldConfig(key: 'title', label: 'Title', required: true),
      AdminFieldConfig(
        key: 'short_title',
        label: 'Short Title',
        required: true,
      ),
      AdminFieldConfig(key: 'code', label: 'Code', required: true),
      AdminFieldConfig(
        key: 'duration_minutes',
        label: 'Duration Minutes',
        kind: AdminFieldKind.integer,
        required: true,
        defaultValue: 50,
      ),
      AdminFieldConfig(
        key: 'question_count',
        label: 'Question Count',
        kind: AdminFieldKind.integer,
        required: true,
        defaultValue: 45,
      ),
      AdminFieldConfig(
        key: 'pass_score',
        label: 'Pass Score',
        kind: AdminFieldKind.integer,
        required: true,
        defaultValue: 700,
      ),
      AdminFieldConfig(
        key: 'language',
        label: 'Language',
        required: true,
        defaultValue: 'English',
      ),
      AdminFieldConfig(
        key: 'sort_order',
        label: 'Sort Order',
        kind: AdminFieldKind.integer,
        defaultValue: 0,
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'vouchers',
    title: 'Vouchers',
    table: 'vouchers',
    displayColumn: 'code',
    description: 'Voucher codes assigned to candidates and exams.',
    columns: ['code', 'candidate_id', 'exam_id', 'status'],
    fields: [
      AdminFieldConfig(key: 'code', label: 'Code', required: true),
      AdminFieldConfig(
        key: 'candidate_id',
        label: 'Candidate',
        kind: AdminFieldKind.relation,
        relationTable: 'candidates',
        relationLabelKey: 'display_name',
        nullable: true,
      ),
      AdminFieldConfig(
        key: 'exam_id',
        label: 'Exam',
        kind: AdminFieldKind.relation,
        relationTable: 'exams',
        relationLabelKey: 'title',
        nullable: true,
      ),
      AdminFieldConfig(
        key: 'status',
        label: 'Status',
        kind: AdminFieldKind.select,
        options: ['assigned', 'used', 'void'],
        defaultValue: 'assigned',
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'nda_agreements',
    title: 'NDA Agreements',
    table: 'nda_agreements',
    displayColumn: 'version',
    description: 'NDA text shown before proctor verification.',
    columns: ['exam_id', 'version', 'created_at'],
    fields: [
      AdminFieldConfig(
        key: 'exam_id',
        label: 'Exam',
        kind: AdminFieldKind.relation,
        relationTable: 'exams',
        relationLabelKey: 'title',
        nullable: true,
      ),
      AdminFieldConfig(key: 'version', label: 'Version', required: true),
      AdminFieldConfig(
        key: 'content',
        label: 'Content',
        kind: AdminFieldKind.multiline,
        required: true,
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'survey_questions',
    title: 'Survey Questions',
    table: 'survey_questions',
    displayColumn: 'title',
    description: 'Pre-exam survey sections and their behavior.',
    columns: ['exam_id', 'position', 'title', 'selection_type', 'theme'],
    fields: [
      AdminFieldConfig(
        key: 'exam_id',
        label: 'Exam',
        kind: AdminFieldKind.relation,
        relationTable: 'exams',
        relationLabelKey: 'title',
        nullable: true,
      ),
      AdminFieldConfig(
        key: 'position',
        label: 'Position',
        kind: AdminFieldKind.integer,
        required: true,
      ),
      AdminFieldConfig(key: 'title', label: 'Title', required: true),
      AdminFieldConfig(
        key: 'description',
        label: 'Description',
        kind: AdminFieldKind.multiline,
      ),
      AdminFieldConfig(
        key: 'selection_type',
        label: 'Selection Type',
        kind: AdminFieldKind.select,
        options: ['single', 'multi'],
        defaultValue: 'single',
      ),
      AdminFieldConfig(
        key: 'theme',
        label: 'Theme',
        kind: AdminFieldKind.select,
        options: ['navy', 'green', 'teal'],
        defaultValue: 'navy',
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'survey_options',
    title: 'Survey Options',
    table: 'survey_options',
    displayColumn: 'label',
    description: 'Answer cards for survey sections.',
    columns: ['survey_question_id', 'option_id', 'label', 'sort_order'],
    fields: [
      AdminFieldConfig(
        key: 'survey_question_id',
        label: 'Survey Question',
        kind: AdminFieldKind.relation,
        relationTable: 'survey_questions',
        relationLabelKey: 'title',
        nullable: true,
      ),
      AdminFieldConfig(
        key: 'option_id',
        label: 'Option ID',
        kind: AdminFieldKind.integer,
        required: true,
      ),
      AdminFieldConfig(key: 'label', label: 'Label', required: true),
      AdminFieldConfig(
        key: 'sort_order',
        label: 'Sort Order',
        kind: AdminFieldKind.integer,
        required: true,
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'questions',
    title: 'Questions',
    table: 'questions',
    displayColumn: 'prompt',
    description:
        'Exam items, prompts, answer options, matrix rows, ordering, and matching items.',
    questionEditor: true,
    columns: ['exam_id', 'number', 'type', 'prompt', 'required_selections'],
    fields: [],
  ),
  AdminSectionConfig(
    id: 'pathways',
    title: 'Pathways',
    table: 'pathways',
    displayColumn: 'name',
    description: 'Pathway progress rows shown on score summary.',
    columns: ['exam_id', 'name', 'percent_complete', 'sort_order'],
    fields: [
      AdminFieldConfig(
        key: 'exam_id',
        label: 'Exam',
        kind: AdminFieldKind.relation,
        relationTable: 'exams',
        relationLabelKey: 'title',
        nullable: true,
      ),
      AdminFieldConfig(key: 'name', label: 'Name', required: true),
      AdminFieldConfig(
        key: 'percent_complete',
        label: 'Percent Complete',
        kind: AdminFieldKind.integer,
        required: true,
      ),
      AdminFieldConfig(
        key: 'sort_order',
        label: 'Sort Order',
        kind: AdminFieldKind.integer,
        defaultValue: 0,
      ),
    ],
  ),
  AdminSectionConfig(
    id: 'system_checks',
    title: 'System Checks',
    table: 'system_checks',
    displayColumn: 'label',
    description: 'System check labels and statuses shown before exam launch.',
    columns: ['label', 'status', 'sort_order'],
    fields: [
      AdminFieldConfig(key: 'label', label: 'Label', required: true),
      AdminFieldConfig(
        key: 'status',
        label: 'Status',
        kind: AdminFieldKind.select,
        options: ['pass', 'warn', 'fail'],
        defaultValue: 'pass',
      ),
      AdminFieldConfig(
        key: 'sort_order',
        label: 'Sort Order',
        kind: AdminFieldKind.integer,
        defaultValue: 0,
      ),
    ],
  ),
];

const readOnlyAdminSections = <AdminSectionConfig>[
  AdminSectionConfig(
    id: 'exam_sessions',
    title: 'Exam Sessions',
    table: 'exam_sessions',
    displayColumn: 'status',
    editable: false,
    columns: [
      'candidate_id',
      'exam_id',
      'voucher_id',
      'status',
      'started_at',
      'completed_at',
      'score',
      'outcome',
    ],
    fields: [],
  ),
  AdminSectionConfig(
    id: 'exam_answers',
    title: 'Exam Answers',
    table: 'exam_answers',
    displayColumn: 'question_id',
    editable: false,
    columns: [
      'session_id',
      'question_id',
      'answer',
      'marked_review',
      'marked_feedback',
      'updated_at',
    ],
    fields: [],
  ),
  AdminSectionConfig(
    id: 'exam_feedback',
    title: 'Exam Feedback',
    table: 'exam_feedback',
    displayColumn: 'feedback',
    editable: false,
    columns: ['session_id', 'feedback', 'created_at'],
    fields: [],
  ),
  AdminSectionConfig(
    id: 'score_reports',
    title: 'Score Reports',
    table: 'score_reports',
    displayColumn: 'outcome',
    editable: false,
    columns: [
      'session_id',
      'required_score',
      'candidate_score',
      'outcome',
      'section_scores',
      'created_at',
    ],
    fields: [],
  ),
];

const allAdminSections = <AdminSectionConfig>[
  ...editableAdminSections,
  ...readOnlyAdminSections,
];

const questionTypes = <String>[
  'singleChoice',
  'multipleChoice',
  'multiple_choice',
  'true_false',
  'yes_no',
  'boolean',
  'matrix',
  'ordering',
  'matching',
];

const deleteBlockers = <String, List<DeleteBlocker>>{
  'test_centers': [
    DeleteBlocker(
      table: 'candidates',
      foreignKey: 'test_center_id',
      label: 'candidates',
    ),
    DeleteBlocker(
      table: 'proctors',
      foreignKey: 'test_center_id',
      label: 'proctors',
    ),
  ],
  'candidates': [
    DeleteBlocker(
      table: 'vouchers',
      foreignKey: 'candidate_id',
      label: 'vouchers',
    ),
    DeleteBlocker(
      table: 'exam_sessions',
      foreignKey: 'candidate_id',
      label: 'exam sessions',
    ),
  ],
  'programs': [
    DeleteBlocker(table: 'exams', foreignKey: 'program_id', label: 'exams'),
  ],
  'exams': [
    DeleteBlocker(table: 'vouchers', foreignKey: 'exam_id', label: 'vouchers'),
    DeleteBlocker(
      table: 'nda_agreements',
      foreignKey: 'exam_id',
      label: 'NDA agreements',
    ),
    DeleteBlocker(
      table: 'survey_questions',
      foreignKey: 'exam_id',
      label: 'survey questions',
    ),
    DeleteBlocker(
      table: 'questions',
      foreignKey: 'exam_id',
      label: 'questions',
    ),
    DeleteBlocker(
      table: 'exam_sessions',
      foreignKey: 'exam_id',
      label: 'exam sessions',
    ),
    DeleteBlocker(table: 'pathways', foreignKey: 'exam_id', label: 'pathways'),
  ],
  'vouchers': [
    DeleteBlocker(
      table: 'exam_sessions',
      foreignKey: 'voucher_id',
      label: 'exam sessions',
    ),
  ],
  'survey_questions': [
    DeleteBlocker(
      table: 'survey_options',
      foreignKey: 'survey_question_id',
      label: 'survey options',
    ),
  ],
  'questions': [
    DeleteBlocker(
      table: 'exam_answers',
      foreignKey: 'question_id',
      label: 'exam answers',
    ),
  ],
};

String defaultLabelKeyForTable(String table) {
  return switch (table) {
    'test_centers' => 'name',
    'candidates' => 'display_name',
    'proctors' => 'display_name',
    'programs' => 'name',
    'exams' => 'title',
    'vouchers' => 'code',
    'nda_agreements' => 'version',
    'survey_questions' => 'title',
    'survey_options' => 'label',
    'questions' => 'prompt',
    'pathways' => 'name',
    'system_checks' => 'label',
    _ => 'id',
  };
}

AdminSectionConfig sectionForTable(String table) {
  return allAdminSections.firstWhere((section) => section.table == table);
}
