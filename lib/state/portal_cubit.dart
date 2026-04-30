import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/compass_models.dart';
import '../data/compass_repository.dart';
import '../data/error_messages.dart';

class PortalState {
  const PortalState({this.loading = false, this.catalog, this.error});

  final bool loading;
  final PortalCatalog? catalog;
  final String? error;

  PortalState copyWith({
    bool? loading,
    PortalCatalog? catalog,
    String? error,
    bool clearError = false,
  }) {
    return PortalState(
      loading: loading ?? this.loading,
      catalog: catalog ?? this.catalog,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class PortalCubit extends Cubit<PortalState> {
  PortalCubit(this._repository) : super(const PortalState());

  final CompassRepository _repository;

  Future<PortalCatalog> loadCatalog() async {
    if (state.catalog != null) {
      return state.catalog!;
    }

    emit(state.copyWith(loading: true, clearError: true));
    try {
      final catalog = await _repository.loadCatalog();
      emit(PortalState(catalog: catalog));
      return catalog;
    } catch (error) {
      emit(state.copyWith(loading: false, error: friendlyErrorMessage(error)));
      rethrow;
    }
  }

  Future<VoucherValidationResult> validateVoucher({
    required String candidateId,
    required String voucherCode,
  }) {
    return _repository.validateVoucher(
      candidateId: candidateId,
      voucherCode: voucherCode,
    );
  }
}
