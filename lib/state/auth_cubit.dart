import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/compass_models.dart';
import '../data/compass_repository.dart';
import '../data/error_messages.dart';

class AuthState {
  const AuthState({
    this.loading = false,
    this.candidate,
    this.testCenter,
    this.vouchers = const [],
    this.error,
  });

  final bool loading;
  final CompassCandidate? candidate;
  final CompassTestCenter? testCenter;
  final List<CompassVoucher> vouchers;
  final String? error;

  AuthState copyWith({
    bool? loading,
    CompassCandidate? candidate,
    CompassTestCenter? testCenter,
    List<CompassVoucher>? vouchers,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      candidate: candidate ?? this.candidate,
      testCenter: testCenter ?? this.testCenter,
      vouchers: vouchers ?? this.vouchers,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final CompassRepository _repository;

  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final result = await _repository.loginCandidate(
        username: username,
        password: password,
      );
      emit(
        AuthState(
          candidate: result.candidate,
          testCenter: result.testCenter,
          vouchers: result.vouchers,
        ),
      );
      return result;
    } catch (error) {
      emit(state.copyWith(loading: false, error: friendlyErrorMessage(error)));
      rethrow;
    }
  }

  Future<CompassCandidate> updateEmail(String email) async {
    final candidate = state.candidate;
    if (candidate == null) {
      throw StateError('Candidate is not logged in.');
    }
    final updated = await _repository.updateCandidateEmail(
      candidateId: candidate.id,
      email: email,
    );
    emit(state.copyWith(candidate: updated));
    return updated;
  }
}
