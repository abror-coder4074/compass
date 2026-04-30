import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/compass_models.dart';
import '../data/compass_repository.dart';
import '../ui/exam/exam_models.dart';

class ExamSessionCubitState {
  const ExamSessionCubitState({
    this.loading = false,
    this.examStartData,
    this.error,
  });

  final bool loading;
  final ExamStartData? examStartData;
  final String? error;

  ExamSessionCubitState copyWith({
    bool? loading,
    ExamStartData? examStartData,
    String? error,
    bool clearError = false,
  }) {
    return ExamSessionCubitState(
      loading: loading ?? this.loading,
      examStartData: examStartData ?? this.examStartData,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ExamSessionCubit extends Cubit<ExamSessionCubitState> {
  ExamSessionCubit(this._repository) : super(const ExamSessionCubitState());

  final CompassRepository _repository;

  Future<ExamStartData> startSession({
    required String candidateId,
    required String examId,
    String? voucherCode,
  }) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final data = await _repository.startExamSession(
        candidateId: candidateId,
        examId: examId,
        voucherCode: voucherCode,
      );
      emit(ExamSessionCubitState(examStartData: data));
      return data;
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
      rethrow;
    }
  }

  Future<bool> unlock({
    required String proctorUsername,
    required String proctorPassword,
  }) {
    final sessionId = state.examStartData?.sessionId;
    if (sessionId == null) {
      throw StateError('Exam session has not been created.');
    }
    return _repository.unlockExam(
      sessionId: sessionId,
      proctorUsername: proctorUsername,
      proctorPassword: proctorPassword,
    );
  }

  Future<void> saveAnswer(ExamQuestion question) async {
    final sessionId = state.examStartData?.sessionId;
    if (sessionId == null) {
      return;
    }
    await _repository.saveAnswer(sessionId: sessionId, question: question);
  }

  Future<ScoreReportData> finishExam() {
    final sessionId = state.examStartData?.sessionId;
    if (sessionId == null) {
      throw StateError('Exam session has not been created.');
    }
    return _repository.finishExam(sessionId: sessionId);
  }

  Future<void> saveFeedback(String feedback) async {
    final sessionId = state.examStartData?.sessionId;
    if (sessionId == null) {
      return;
    }
    await _repository.saveFeedback(sessionId: sessionId, feedback: feedback);
  }
}
