enum ExamFlowStage {
  survey,
  tutorial,
  question,
  summary,
  feedbackIntro,
  feedbackForm,
  feedbackThankYou,
}

class SurveyOption {
  const SurveyOption({required this.id, required this.label});

  final int id;
  final String label;
}

enum ExamQuestionType {
  singleChoice,
  multipleChoice,
  matrix,
  ordering,
  matching,
}

class ExamQuestion {
  ExamQuestion({
    required this.number,
    required this.prompt,
    this.promptDetails = const [],
    this.type = ExamQuestionType.singleChoice,
    this.options = const [],
    this.requiredSelections = 1,
    this.matrixColumns = const [],
    this.matrixRows = const [],
    this.sourceItems = const [],
    this.targetItems = const [],
    this.selectedOption,
    Set<String>? selectedOptions,
    Map<int, String>? matrixSelections,
    List<String>? availableOrderItems,
    List<String>? orderedItems,
    List<String>? availableMatchItems,
    Map<int, String>? matchingSelections,
    this.markedForReview = false,
    this.markedForFeedback = false,
  }) : selectedOptions = selectedOptions ?? <String>{},
       matrixSelections = matrixSelections ?? <int, String>{},
       availableOrderItems =
           availableOrderItems ??
           (type == ExamQuestionType.ordering
               ? List<String>.from(sourceItems)
               : <String>[]),
       orderedItems = orderedItems ?? <String>[],
       availableMatchItems =
           availableMatchItems ??
           (type == ExamQuestionType.matching
               ? List<String>.from(sourceItems)
               : <String>[]),
       matchingSelections = matchingSelections ?? <int, String>{};

  final int number;
  final String prompt;
  final List<String> promptDetails;
  final ExamQuestionType type;
  final List<String> options;
  final int requiredSelections;
  final List<String> matrixColumns;
  final List<String> matrixRows;
  final List<String> sourceItems;
  final List<String> targetItems;
  String? selectedOption;
  final Set<String> selectedOptions;
  final Map<int, String> matrixSelections;
  final List<String> availableOrderItems;
  final List<String> orderedItems;
  final List<String> availableMatchItems;
  final Map<int, String> matchingSelections;
  bool markedForReview;
  bool markedForFeedback;

  bool get isAnswered {
    return switch (type) {
      ExamQuestionType.singleChoice => selectedOption != null,
      ExamQuestionType.multipleChoice =>
        selectedOptions.length == requiredSelections,
      ExamQuestionType.matrix => matrixSelections.length == matrixRows.length,
      ExamQuestionType.ordering => orderedItems.length == sourceItems.length,
      ExamQuestionType.matching =>
        targetItems.isNotEmpty &&
            targetItems.asMap().keys.every(matchingSelections.containsKey),
    };
  }
}

class ExamSessionState {
  ExamSessionState.initial({
    required this.questions,
    this.initialRemainingTime = const Duration(minutes: 50),
  }) : stage = ExamFlowStage.survey,
       currentQuestionIndex = 0,
       lastVisitedQuestionIndex = 0,
       remainingTime = initialRemainingTime,
       warningShown = false,
       timedOut = false,
       surveyCourseSelection = null,
       surveyResourceSelections = <int>{},
       surveyUsageSelections = <int>{};

  final Duration initialRemainingTime;
  ExamFlowStage stage;
  final List<ExamQuestion> questions;
  int currentQuestionIndex;
  int lastVisitedQuestionIndex;
  Duration remainingTime;
  bool warningShown;
  bool timedOut;
  int? surveyCourseSelection;
  final Set<int> surveyResourceSelections;
  final Set<int> surveyUsageSelections;

  int get totalQuestions => questions.length;

  ExamQuestion get currentQuestion => questions[currentQuestionIndex];

  int get answeredCount =>
      questions.where((question) => question.isAnswered).length;

  int get unansweredCount => totalQuestions - answeredCount;

  int get reviewCount =>
      questions.where((question) => question.markedForReview).length;

  int get feedbackCount =>
      questions.where((question) => question.markedForFeedback).length;
}
