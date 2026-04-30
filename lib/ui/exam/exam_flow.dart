import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/compass_models.dart';
import '../compass_components.dart';
import '../compass_shells.dart';
import '../compass_theme.dart';
import 'exam_mock_data.dart';
import 'exam_models.dart';
import 'feedback_intro_screen.dart';
import 'question_summary_screens.dart';
import 'survey_tutorial_screens.dart';
import 'tutorial_screen.dart';

part 'exam_flow_layout.dart';
part 'exam_status_dialog.dart';

class ExamTimerConfig {
  const ExamTimerConfig({
    this.initialDuration = const Duration(minutes: 50),
    this.warningThreshold = const Duration(minutes: 5),
    this.tickInterval = const Duration(seconds: 1),
    this.timeStep = const Duration(seconds: 1),
  });

  final Duration initialDuration;
  final Duration warningThreshold;
  final Duration tickInterval;
  final Duration timeStep;
}

class ExamFlow extends StatefulWidget {
  const ExamFlow({
    required this.selectedExam,
    required this.onBlockedExit,
    required this.onExamCompleted,
    this.questions,
    this.surveySections = const [],
    this.onQuestionChanged,
    this.onFeedbackSubmitted,
    this.timerConfig = const ExamTimerConfig(),
    super.key,
  });

  final String selectedExam;
  final Future<void> Function() onBlockedExit;
  final Future<void> Function() onExamCompleted;
  final List<ExamQuestion>? questions;
  final List<SurveySectionData> surveySections;
  final ValueChanged<ExamQuestion>? onQuestionChanged;
  final ValueChanged<String>? onFeedbackSubmitted;
  final ExamTimerConfig timerConfig;

  @override
  State<ExamFlow> createState() => _ExamFlowState();
}

class _ExamFlowState extends State<ExamFlow> {
  final _feedbackController = TextEditingController();
  late ExamSessionState _session;
  Timer? _timer;
  bool _statusDialogVisible = false;
  bool _pendingTimeoutDialog = false;

  @override
  void initState() {
    super.initState();
    _resetSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackController.dispose();
    super.dispose();
  }

  void _resetSession() {
    _timer?.cancel();
    _feedbackController.clear();
    _session = ExamSessionState.initial(
      questions: [
        for (final question in widget.questions ?? buildMockExamQuestions())
          cloneExamQuestion(question),
      ],
      initialRemainingTime: widget.timerConfig.initialDuration,
    );
    _statusDialogVisible = false;
    _pendingTimeoutDialog = false;
  }

  void _goToTutorial() {
    setState(() {
      _session.stage = ExamFlowStage.tutorial;
    });
  }

  void _startTimedExam() {
    _timer?.cancel();
    setState(() {
      _session.stage = ExamFlowStage.question;
      _session.currentQuestionIndex = 0;
      _session.lastVisitedQuestionIndex = 0;
      _session.remainingTime = widget.timerConfig.initialDuration;
      _session.warningShown = false;
      _session.timedOut = false;
    });

    _timer = Timer.periodic(widget.timerConfig.tickInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final previousDuration = _session.remainingTime;
      final nextDuration = previousDuration - widget.timerConfig.timeStep;
      if (nextDuration <= Duration.zero) {
        timer.cancel();
        setState(() {
          _session.remainingTime = Duration.zero;
          _session.timedOut = true;
        });
        _showTimeoutDialog();
        return;
      }

      final shouldWarn =
          !_session.warningShown &&
          previousDuration > widget.timerConfig.warningThreshold &&
          nextDuration <= widget.timerConfig.warningThreshold;

      setState(() {
        _session.remainingTime = nextDuration;
      });

      if (shouldWarn) {
        _showFiveMinuteWarning();
      }
    });
  }

  void _selectAnswer(String answer) {
    setState(() {
      _session.currentQuestion.selectedOption = answer;
    });
    _notifyQuestionChanged();
  }

  void _toggleMultiAnswer(String answer) {
    setState(() {
      final question = _session.currentQuestion;
      if (question.selectedOptions.contains(answer)) {
        question.selectedOptions.remove(answer);
        return;
      }

      if (question.selectedOptions.length < question.requiredSelections) {
        question.selectedOptions.add(answer);
      }
    });
    _notifyQuestionChanged();
  }

  void _selectMatrixAnswer(int rowIndex, String answer) {
    setState(() {
      _session.currentQuestion.matrixSelections[rowIndex] = answer;
    });
    _notifyQuestionChanged();
  }

  void _moveOrderItemToAnswer(String item) {
    setState(() {
      final question = _session.currentQuestion;
      if (question.availableOrderItems.remove(item)) {
        question.orderedItems.add(item);
      }
    });
    _notifyQuestionChanged();
  }

  void _moveOrderItemToSource(String item) {
    setState(() {
      final question = _session.currentQuestion;
      if (question.orderedItems.remove(item) &&
          !question.availableOrderItems.contains(item)) {
        question.availableOrderItems.add(item);
      }
    });
    _notifyQuestionChanged();
  }

  void _shiftOrderedItem(int index, int delta) {
    setState(() {
      final question = _session.currentQuestion;
      final nextIndex = (index + delta)
          .clamp(0, question.orderedItems.length - 1)
          .toInt();
      if (nextIndex == index) {
        return;
      }

      final item = question.orderedItems.removeAt(index);
      question.orderedItems.insert(nextIndex, item);
    });
    _notifyQuestionChanged();
  }

  void _assignMatchItem(String item, int targetIndex) {
    setState(() {
      final question = _session.currentQuestion;
      final replacedItem = question.matchingSelections[targetIndex];
      if (replacedItem != null &&
          replacedItem != item &&
          !question.availableMatchItems.contains(replacedItem)) {
        question.availableMatchItems.add(replacedItem);
      }

      question.matchingSelections.removeWhere((_, value) => value == item);
      question.availableMatchItems.remove(item);
      question.matchingSelections[targetIndex] = item;
    });
    _notifyQuestionChanged();
  }

  void _clearMatchTarget(int targetIndex) {
    setState(() {
      final question = _session.currentQuestion;
      final item = question.matchingSelections.remove(targetIndex);
      if (item != null && !question.availableMatchItems.contains(item)) {
        question.availableMatchItems.add(item);
      }
    });
    _notifyQuestionChanged();
  }

  void _toggleReview() {
    setState(() {
      _session.currentQuestion.markedForReview =
          !_session.currentQuestion.markedForReview;
    });
    _notifyQuestionChanged();
  }

  void _toggleFeedback() {
    setState(() {
      _session.currentQuestion.markedForFeedback =
          !_session.currentQuestion.markedForFeedback;
    });
    _notifyQuestionChanged();
  }

  void _goBackQuestion() {
    if (_session.currentQuestionIndex == 0) {
      return;
    }

    setState(() {
      _session.currentQuestionIndex -= 1;
      _session.lastVisitedQuestionIndex = _session.currentQuestionIndex;
    });
  }

  void _goNextQuestion() {
    if (_session.currentQuestionIndex == _session.totalQuestions - 1) {
      _openSummary();
      return;
    }

    setState(() {
      _session.currentQuestionIndex += 1;
      _session.lastVisitedQuestionIndex = _session.currentQuestionIndex;
    });
  }

  void _openSummary() {
    setState(() {
      _session.stage = ExamFlowStage.summary;
      _session.lastVisitedQuestionIndex = _session.currentQuestionIndex;
    });
  }

  void _finishExam() {
    _timer?.cancel();
    setState(() {
      _session.stage = ExamFlowStage.feedbackIntro;
    });
  }

  void _startFeedback() {
    setState(() {
      _session.stage = ExamFlowStage.feedbackForm;
    });
  }

  void _goToFeedbackThankYou() {
    widget.onFeedbackSubmitted?.call(_feedbackController.text);
    setState(() {
      _session.stage = ExamFlowStage.feedbackThankYou;
    });
  }

  void _notifyQuestionChanged() {
    widget.onQuestionChanged?.call(_session.currentQuestion);
  }

  Future<void> _completeExam() async {
    _timer?.cancel();
    await widget.onExamCompleted();
  }

  Future<void> _showFiveMinuteWarning() async {
    if (_statusDialogVisible || !mounted || _session.warningShown) {
      return;
    }

    setState(() {
      _session.warningShown = true;
    });

    _statusDialogVisible = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ExamStatusDialog(
          title: '5-Minute Warning',
          message: 'You have 5 minutes remaining.',
          buttonLabel: 'Continue',
          onPressed: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
    _statusDialogVisible = false;

    if (_pendingTimeoutDialog && mounted) {
      _pendingTimeoutDialog = false;
      await _showTimeoutDialog();
    }
  }

  Future<void> _showTimeoutDialog() async {
    if (!mounted) {
      return;
    }

    if (_statusDialogVisible) {
      _pendingTimeoutDialog = true;
      return;
    }

    _timer?.cancel();
    _pendingTimeoutDialog = false;
    setState(() {
      _session.timedOut = true;
      _session.remainingTime = Duration.zero;
    });

    _statusDialogVisible = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ExamStatusDialog(
          title: 'Timeout',
          message:
              'You have reached the maximum test time. Click Finish Exam to continue to the Exam Summary.',
          buttonLabel: 'Finish Exam',
          onPressed: () {
            Navigator.of(dialogContext).pop();
            if (!mounted) {
              return;
            }
            setState(() {
              _session.stage = ExamFlowStage.summary;
            });
          },
        );
      },
    );
    _statusDialogVisible = false;
  }

  void _handleSurveyCourseSelection(int optionId) {
    setState(() {
      _session.surveyCourseSelection = optionId;
    });
  }

  void _toggleSurveyResource(int optionId) {
    setState(() {
      if (_session.surveyResourceSelections.contains(optionId)) {
        _session.surveyResourceSelections.remove(optionId);
      } else {
        _session.surveyResourceSelections.add(optionId);
      }
    });
  }

  void _toggleSurveyUsage(int optionId) {
    setState(() {
      if (_session.surveyUsageSelections.contains(optionId)) {
        _session.surveyUsageSelections.remove(optionId);
      } else {
        _session.surveyUsageSelections.add(optionId);
      }
    });
  }

  void _handleToolSelection(String value) {
    switch (value) {
      case 'close_window':
        widget.onBlockedExit();
        return;
      case 'calculator':
      case 'help':
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFeedbackStage) {
      return ExamFeedbackShell(
        footer: buildExamFooter(),
        child: buildExamBody(),
      );
    }

    return ExamWorkspaceShell(
      title: examStageTitle(),
      titleTrailing: buildExamHeaderTrailing(),
      underHeader: buildExamUnderHeader(),
      footer: buildExamFooter(),
      child: buildExamBody(),
    );
  }
}
