import '../ui/exam/exam_models.dart';

class CompassConfig {
  static const supabaseUrl = 'https://mjthfgptkrehpmugjgoj.supabase.co';
  static const supabasePublishableKey =
      'sb_publishable_RxCSzqsMxc_eCs61lM2GEw_H8HVcKrI';
}

class CompassTestCenter {
  const CompassTestCenter({
    required this.id,
    required this.name,
    required this.code,
  });

  factory CompassTestCenter.fromJson(Map<String, dynamic> json) {
    return CompassTestCenter(
      id: _string(json['id']),
      name: _string(json['name']),
      code: _string(json['code']),
    );
  }

  final String id;
  final String name;
  final String code;
}

class CompassCandidate {
  const CompassCandidate({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.candidateIdentifier,
    required this.score,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory CompassCandidate.fromJson(Map<String, dynamic> json) {
    return CompassCandidate(
      id: _string(json['id']),
      username: _string(json['username']),
      email: _string(json['email']),
      displayName: _string(json['display_name']),
      candidateIdentifier: _string(json['candidate_identifier']),
      score: _int(json['score'], fallback: 700),
      addressLine1: _string(json['address_line1']),
      addressLine2: _string(json['address_line2']),
      city: _string(json['city']),
      postalCode: _string(json['postal_code']),
      country: _string(json['country']),
    );
  }

  final String id;
  final String username;
  final String email;
  final String displayName;
  final String candidateIdentifier;
  final int score;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;

  String get reportAddress {
    return [
      addressLine1,
      addressLine2,
      city.isEmpty || postalCode.isEmpty
          ? '$city $postalCode'.trim()
          : '$city $postalCode',
      country,
    ].where((value) => value.trim().isNotEmpty).join('\n');
  }
}

class CompassProgram {
  const CompassProgram({required this.id, required this.name});

  factory CompassProgram.fromJson(Map<String, dynamic> json) {
    return CompassProgram(id: _string(json['id']), name: _string(json['name']));
  }

  final String id;
  final String name;
}

class CompassExam {
  const CompassExam({
    required this.id,
    required this.programId,
    required this.title,
    required this.shortTitle,
    required this.code,
    required this.durationMinutes,
    required this.questionCount,
    required this.passScore,
    required this.language,
  });

  factory CompassExam.fromJson(Map<String, dynamic> json) {
    return CompassExam(
      id: _string(json['id']),
      programId: _string(json['program_id']),
      title: _string(json['title']),
      shortTitle: _string(json['short_title']),
      code: _string(json['code']),
      durationMinutes: _int(json['duration_minutes'], fallback: 50),
      questionCount: _int(json['question_count'], fallback: 45),
      passScore: _int(json['pass_score'], fallback: 700),
      language: _string(json['language'], fallback: 'English'),
    );
  }

  final String id;
  final String programId;
  final String title;
  final String shortTitle;
  final String code;
  final int durationMinutes;
  final int questionCount;
  final int passScore;
  final String language;
}

class CompassVoucher {
  const CompassVoucher({
    required this.id,
    required this.code,
    required this.examId,
    required this.status,
  });

  factory CompassVoucher.fromJson(Map<String, dynamic> json) {
    return CompassVoucher(
      id: _string(json['id']),
      code: _string(json['code']),
      examId: _string(json['exam_id']),
      status: _string(json['status'], fallback: 'assigned'),
    );
  }

  final String id;
  final String code;
  final String examId;
  final String status;
}

class NdaAgreementData {
  const NdaAgreementData({
    required this.examId,
    required this.version,
    required this.content,
  });

  factory NdaAgreementData.fromJson(Map<String, dynamic> json) {
    return NdaAgreementData(
      examId: _string(json['exam_id']),
      version: _string(json['version']),
      content: _string(json['content']),
    );
  }

  final String examId;
  final String version;
  final String content;
}

class SystemCheckData {
  const SystemCheckData({required this.label, required this.status});

  factory SystemCheckData.fromJson(Map<String, dynamic> json) {
    return SystemCheckData(
      label: _string(json['label']),
      status: _string(json['status'], fallback: 'pass'),
    );
  }

  final String label;
  final String status;
}

class PathwayData {
  const PathwayData({required this.name, required this.percentComplete});

  factory PathwayData.fromJson(Map<String, dynamic> json) {
    return PathwayData(
      name: _string(json['name']),
      percentComplete: _int(json['percent_complete']),
    );
  }

  final String name;
  final int percentComplete;
}

class SurveySectionData {
  const SurveySectionData({
    required this.position,
    required this.title,
    required this.description,
    required this.selectionType,
    required this.theme,
    required this.options,
  });

  factory SurveySectionData.fromJson(Map<String, dynamic> json) {
    return SurveySectionData(
      position: _int(json['position']),
      title: _string(json['title']),
      description: _string(json['description']),
      selectionType: _string(json['selection_type'], fallback: 'single'),
      theme: _string(json['theme'], fallback: 'navy'),
      options: _jsonList(json['options'])
          .map(
            (item) => SurveyOption(
              id: _int(item['option_id']),
              label: _string(item['label']),
            ),
          )
          .toList(),
    );
  }

  final int position;
  final String title;
  final String description;
  final String selectionType;
  final String theme;
  final List<SurveyOption> options;
}

class PortalCatalog {
  const PortalCatalog({
    required this.programs,
    required this.exams,
    required this.ndaAgreements,
    required this.systemChecks,
    required this.pathways,
  });

  factory PortalCatalog.fromJson(Map<String, dynamic> json) {
    return PortalCatalog(
      programs: _jsonList(
        json['programs'],
      ).map(CompassProgram.fromJson).toList(),
      exams: _jsonList(json['exams']).map(CompassExam.fromJson).toList(),
      ndaAgreements: _jsonList(
        json['nda_agreements'],
      ).map(NdaAgreementData.fromJson).toList(),
      systemChecks: _jsonList(
        json['system_checks'],
      ).map(SystemCheckData.fromJson).toList(),
      pathways: _jsonList(json['pathways']).map(PathwayData.fromJson).toList(),
    );
  }

  final List<CompassProgram> programs;
  final List<CompassExam> exams;
  final List<NdaAgreementData> ndaAgreements;
  final List<SystemCheckData> systemChecks;
  final List<PathwayData> pathways;
}

class LoginResult {
  const LoginResult({
    required this.candidate,
    required this.testCenter,
    required this.vouchers,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      candidate: CompassCandidate.fromJson(_jsonMap(json['candidate'])),
      testCenter: CompassTestCenter.fromJson(_jsonMap(json['test_center'])),
      vouchers: _jsonList(
        json['vouchers'],
      ).map(CompassVoucher.fromJson).toList(),
    );
  }

  final CompassCandidate candidate;
  final CompassTestCenter testCenter;
  final List<CompassVoucher> vouchers;
}

class VoucherValidationResult {
  const VoucherValidationResult({
    required this.valid,
    this.voucher,
    this.message,
  });

  factory VoucherValidationResult.fromJson(Map<String, dynamic> json) {
    return VoucherValidationResult(
      valid: json['valid'] == true,
      voucher: json['voucher'] == null
          ? null
          : CompassVoucher.fromJson(_jsonMap(json['voucher'])),
      message: json['message'] as String?,
    );
  }

  final bool valid;
  final CompassVoucher? voucher;
  final String? message;
}

class ExamStartData {
  const ExamStartData({
    required this.sessionId,
    required this.surveySections,
    required this.questions,
  });

  factory ExamStartData.fromJson(Map<String, dynamic> json) {
    final session = _jsonMap(json['session']);
    return ExamStartData(
      sessionId: _string(session['id']),
      surveySections: _jsonList(
        json['survey_questions'],
      ).map(SurveySectionData.fromJson).toList(),
      questions: _jsonList(
        json['questions'],
      ).map(examQuestionFromJson).toList(),
    );
  }

  final String sessionId;
  final List<SurveySectionData> surveySections;
  final List<ExamQuestion> questions;
}

class SectionScoreData {
  const SectionScoreData({required this.name, required this.score});

  factory SectionScoreData.fromJson(Map<String, dynamic> json) {
    return SectionScoreData(
      name: _string(json['name']),
      score: _int(json['score']),
    );
  }

  final String name;
  final int score;
}

class ScoreReportData {
  const ScoreReportData({
    required this.sessionId,
    required this.requiredScore,
    required this.candidateScore,
    required this.outcome,
    required this.sectionScores,
    required this.candidate,
    required this.exam,
    required this.testCenter,
    required this.pathways,
  });

  factory ScoreReportData.fromJson(Map<String, dynamic> json) {
    final report = _jsonMap(json['score_report']);
    return ScoreReportData(
      sessionId: _string(_jsonMap(json['session'])['id']),
      requiredScore: _int(report['required_score'], fallback: 700),
      candidateScore: _int(report['candidate_score'], fallback: 700),
      outcome: _string(report['outcome'], fallback: 'Pass'),
      sectionScores: _jsonList(
        report['section_scores'],
      ).map(SectionScoreData.fromJson).toList(),
      candidate: CompassCandidate.fromJson(_jsonMap(json['candidate'])),
      exam: CompassExam.fromJson(_jsonMap(json['exam'])),
      testCenter: CompassTestCenter.fromJson(_jsonMap(json['test_center'])),
      pathways: _jsonList(json['pathways']).map(PathwayData.fromJson).toList(),
    );
  }

  final String sessionId;
  final int requiredScore;
  final int candidateScore;
  final String outcome;
  final List<SectionScoreData> sectionScores;
  final CompassCandidate candidate;
  final CompassExam exam;
  final CompassTestCenter testCenter;
  final List<PathwayData> pathways;
}

ExamQuestion examQuestionFromJson(Map<String, dynamic> json) {
  final rawType = _string(json['type'], fallback: 'singleChoice');
  final requiredSelections = _int(json['required_selections'], fallback: 1);
  final options = _questionOptions(json, rawType);
  final matrixRows = _stringList(json['matrix_rows']);
  final type = _questionType(
    rawType,
    requiredSelections: requiredSelections,
    hasMatrixRows: matrixRows.isNotEmpty,
  );
  final sourceItems = _stringList(json['source_items']);
  return ExamQuestion(
    id: _string(json['id']),
    number: _int(json['number']),
    prompt: _string(json['prompt']),
    promptDetails: _stringList(json['prompt_details']),
    type: type,
    options: options,
    requiredSelections: requiredSelections,
    matrixColumns: type == ExamQuestionType.matrix ? options : const [],
    matrixRows: matrixRows,
    sourceItems: sourceItems,
    targetItems: _stringList(json['target_items']),
    availableOrderItems: type == ExamQuestionType.ordering
        ? List<String>.from(sourceItems)
        : const [],
    availableMatchItems: type == ExamQuestionType.matching
        ? List<String>.from(sourceItems)
        : const [],
  );
}

Map<String, dynamic> answerPayloadFromQuestion(ExamQuestion question) {
  return {
    'type': question.type.name,
    'selected_option': question.selectedOption,
    'selected_options': question.selectedOptions.toList()..sort(),
    'matrix_selections': question.matrixSelections.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
    'ordered_items': question.orderedItems,
    'matching_selections': question.matchingSelections.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
  };
}

ExamQuestion cloneExamQuestion(ExamQuestion source) {
  return ExamQuestion(
    id: source.id,
    number: source.number,
    prompt: source.prompt,
    promptDetails: List<String>.from(source.promptDetails),
    type: source.type,
    options: List<String>.from(source.options),
    requiredSelections: source.requiredSelections,
    matrixColumns: List<String>.from(source.matrixColumns),
    matrixRows: List<String>.from(source.matrixRows),
    sourceItems: List<String>.from(source.sourceItems),
    targetItems: List<String>.from(source.targetItems),
    selectedOption: source.selectedOption,
    selectedOptions: Set<String>.from(source.selectedOptions),
    matrixSelections: Map<int, String>.from(source.matrixSelections),
    availableOrderItems: List<String>.from(source.availableOrderItems),
    orderedItems: List<String>.from(source.orderedItems),
    availableMatchItems: List<String>.from(source.availableMatchItems),
    matchingSelections: Map<int, String>.from(source.matchingSelections),
    markedForReview: source.markedForReview,
    markedForFeedback: source.markedForFeedback,
  );
}

ExamQuestionType _questionType(
  String value, {
  required int requiredSelections,
  required bool hasMatrixRows,
}) {
  final normalized = _normalizedQuestionType(value);
  return switch (normalized) {
    'multiple_choice' when requiredSelections > 1 =>
      ExamQuestionType.multipleChoice,
    'multiple_choice' => ExamQuestionType.singleChoice,
    'matrix' => ExamQuestionType.matrix,
    'ordering' => ExamQuestionType.ordering,
    'matching' => ExamQuestionType.matching,
    'true_false' ||
    'yes_no' ||
    'boolean' when hasMatrixRows => ExamQuestionType.matrix,
    'single_choice' ||
    'true_false' ||
    'yes_no' ||
    'boolean' => ExamQuestionType.singleChoice,
    _ => ExamQuestionType.singleChoice,
  };
}

List<String> _questionOptions(Map<String, dynamic> json, String rawType) {
  final options = _stringList(json['options']);
  if (options.isNotEmpty) {
    return options;
  }

  return switch (_normalizedQuestionType(rawType)) {
    'true_false' || 'boolean' => const ['True', 'False'],
    'yes_no' => const ['Yes', 'No'],
    _ => const [],
  };
}

String _normalizedQuestionType(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '';
  }

  final snakeCase = trimmed
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .replaceAll(RegExp(r'[\s-]+'), '_')
      .toLowerCase();

  return snakeCase;
}

Map<String, dynamic> _jsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _jsonList(Object? value) {
  if (value is List) {
    return value.map(_jsonMap).toList();
  }
  return const [];
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  return const [];
}

String _string(Object? value, {String fallback = ''}) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return fallback;
  }
  return text;
}

int _int(Object? value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
