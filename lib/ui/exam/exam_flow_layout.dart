part of 'exam_flow.dart';

extension _ExamFlowLayout on _ExamFlowState {
  String examStageTitle() {
    return switch (_session.stage) {
      ExamFlowStage.survey => 'Survey 1 of 1',
      ExamFlowStage.tutorial => 'Tutorial',
      ExamFlowStage.question =>
        'Question ${_session.currentQuestion.number} of ${_session.totalQuestions}',
      ExamFlowStage.summary => 'Exam Summary',
      ExamFlowStage.feedbackIntro => '',
      ExamFlowStage.feedbackForm => '',
      ExamFlowStage.feedbackThankYou => '',
    };
  }

  Widget? buildExamHeaderTrailing() {
    if (_session.stage != ExamFlowStage.question &&
        _session.stage != ExamFlowStage.summary) {
      return null;
    }

    return Text(
      'Time Remaining ${_formatDuration(_session.remainingTime)}',
      style: const TextStyle(
        color: CompassColors.examNavy,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget? buildExamUnderHeader() {
    return switch (_session.stage) {
      ExamFlowStage.survey || ExamFlowStage.tutorial => Container(
        height: 10,
        color: CompassColors.examNavy,
      ),
      ExamFlowStage.question || ExamFlowStage.summary => SizedBox(
        height: 20,
        child: LinearProgressIndicator(
          value: _progressValue(),
          color: CompassColors.examNavy,
          backgroundColor: const Color(0xFFB7C5D1),
        ),
      ),
      ExamFlowStage.feedbackIntro => const Divider(
        height: 1,
        thickness: 1,
        color: CompassColors.border,
      ),
      ExamFlowStage.feedbackForm || ExamFlowStage.feedbackThankYou =>
        const Divider(height: 1, thickness: 1, color: CompassColors.border),
    };
  }

  Widget buildExamBody() {
    return switch (_session.stage) {
      ExamFlowStage.survey => ExamSurveyScreen(
        selectedCourseOptionId: _session.surveyCourseSelection,
        selectedResourceOptionIds: _session.surveyResourceSelections,
        selectedUsageOptionIds: _session.surveyUsageSelections,
        onCourseSelected: _handleSurveyCourseSelection,
        onResourceToggled: _toggleSurveyResource,
        onUsageToggled: _toggleSurveyUsage,
        sections: widget.surveySections,
      ),
      ExamFlowStage.tutorial => ExamTutorialScreen(
        examTitle: widget.selectedExam,
        questionCount: _session.totalQuestions,
        durationMinutes: widget.timerConfig.initialDuration.inMinutes,
      ),
      ExamFlowStage.question => ExamQuestionScreen(
        question: _session.currentQuestion,
        onAnswerSelected: _selectAnswer,
        onMultiAnswerToggled: _toggleMultiAnswer,
        onMatrixAnswerSelected: _selectMatrixAnswer,
        onOrderItemMovedToAnswer: _moveOrderItemToAnswer,
        onOrderItemMovedToSource: _moveOrderItemToSource,
        onOrderedItemShifted: _shiftOrderedItem,
        onMatchItemAssigned: _assignMatchItem,
        onMatchTargetCleared: _clearMatchTarget,
      ),
      ExamFlowStage.summary => ExamSummaryScreen(
        session: _session,
        onQuestionSelected: _openQuestionFromSummary,
      ),
      ExamFlowStage.feedbackIntro => const ExamFeedbackIntroScreen(),
      ExamFlowStage.feedbackForm => ExamFeedbackFormScreen(
        controller: _feedbackController,
      ),
      ExamFlowStage.feedbackThankYou => ExamFeedbackThankYouScreen(
        examTitle: widget.selectedExam,
      ),
    };
  }

  Widget buildExamFooter() {
    return switch (_session.stage) {
      ExamFlowStage.survey => ExamFooterBar(
        leadingChildren: [_buildToolsMenu()],
        trailingChildren: [
          CompassPrimaryButton(
            label: 'Next',
            tone: CompassButtonTone.exam,
            onPressed: _goToTutorial,
          ),
        ],
      ),
      ExamFlowStage.tutorial => ExamFooterBar(
        leadingChildren: [_buildToolsMenu()],
        trailingChildren: [
          CompassPrimaryButton(
            label: 'Start Exam',
            tone: CompassButtonTone.exam,
            onPressed: _startTimedExam,
          ),
        ],
      ),
      ExamFlowStage.question => ExamFooterBar(
        leadingChildren: [
          ExamFooterLink(label: 'Go To Summary', onPressed: _openSummary),
          ExamFooterLink(
            label: 'Mark for Review',
            active: _session.currentQuestion.markedForReview,
            onPressed: _toggleReview,
          ),
          ExamFooterLink(
            label: 'Mark for Feedback',
            active: _session.currentQuestion.markedForFeedback,
            onPressed: _toggleFeedback,
          ),
          _buildToolsMenu(),
        ],
        trailingChildren: [
          if (_session.currentQuestionIndex > 0)
            CompassSecondaryButton(
              label: 'Back',
              tone: CompassButtonTone.exam,
              onPressed: _goBackQuestion,
            ),
          CompassPrimaryButton(
            label: 'Next',
            tone: CompassButtonTone.exam,
            onPressed: _goNextQuestion,
          ),
        ],
      ),
      ExamFlowStage.summary => ExamFooterBar(
        leadingChildren: [_buildToolsMenu()],
        trailingChildren: [
          CompassPrimaryButton(
            label: 'Finish Exam',
            tone: CompassButtonTone.exam,
            onPressed: _session.unansweredCount == 0 ? _finishExam : null,
          ),
        ],
      ),
      ExamFlowStage.feedbackIntro => ExamFooterBar(
        leadingChildren: [_buildToolsMenu()],
        trailingChildren: [
          CompassSecondaryButton(
            label: 'Skip Feedback',
            tone: CompassButtonTone.exam,
            onPressed: _startFeedback,
          ),
          CompassPrimaryButton(
            label: 'Start Feedback',
            tone: CompassButtonTone.exam,
            onPressed: _startFeedback,
          ),
        ],
      ),
      ExamFlowStage.feedbackForm => ExamFooterBar(
        leadingChildren: [_buildToolsMenu()],
        trailingChildren: [
          CompassPrimaryButton(
            label: 'Next',
            tone: CompassButtonTone.exam,
            onPressed: _goToFeedbackThankYou,
          ),
        ],
      ),
      ExamFlowStage.feedbackThankYou => ExamFooterBar(
        leadingChildren: [_buildToolsMenu()],
        trailingChildren: [
          CompassPrimaryButton(
            label: 'Exit Exam',
            tone: CompassButtonTone.exam,
            onPressed: _completeExam,
          ),
        ],
      ),
    };
  }

  bool get isFeedbackStage =>
      _session.stage == ExamFlowStage.feedbackIntro ||
      _session.stage == ExamFlowStage.feedbackForm ||
      _session.stage == ExamFlowStage.feedbackThankYou;

  double _progressValue() {
    final numerator = switch (_session.stage) {
      ExamFlowStage.question => _session.currentQuestion.number,
      ExamFlowStage.summary => _session.lastVisitedQuestionIndex + 1,
      ExamFlowStage.feedbackIntro => _session.totalQuestions,
      ExamFlowStage.feedbackForm => _session.totalQuestions,
      ExamFlowStage.feedbackThankYou => _session.totalQuestions,
      _ => 0,
    };

    return numerator == 0 ? 0 : numerator / _session.totalQuestions;
  }

  Widget _buildToolsMenu() {
    return ExamToolsMenu(onSelected: _handleToolSelection);
  }
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours.remainder(100).toString().padLeft(2, '0');
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}
