import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/compass_models.dart';
import '../data/error_messages.dart';

class ScoreReportState {
  const ScoreReportState({this.loading = false, this.report, this.error});

  final bool loading;
  final ScoreReportData? report;
  final String? error;

  ScoreReportState copyWith({
    bool? loading,
    ScoreReportData? report,
    String? error,
    bool clearError = false,
  }) {
    return ScoreReportState(
      loading: loading ?? this.loading,
      report: report ?? this.report,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ScoreReportCubit extends Cubit<ScoreReportState> {
  ScoreReportCubit() : super(const ScoreReportState());

  void setLoading() {
    emit(state.copyWith(loading: true, clearError: true));
  }

  void setReport(ScoreReportData report) {
    emit(ScoreReportState(report: report));
  }

  void setError(Object error) {
    emit(state.copyWith(loading: false, error: friendlyErrorMessage(error)));
  }
}
