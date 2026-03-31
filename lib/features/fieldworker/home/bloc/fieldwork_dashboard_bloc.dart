import 'package:treelove/common/bloc/api_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/dashboard_repository.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/network/base_network_status.dart';
import '../../../../core/utils/logger.dart';
import '../models/fieldworker_dashboard_response_model.dart';

class FieldworkDashboardBloc extends Bloc<ApiEvent,
    ApiState<FieldworkerDashboardResponseModel, ResponseModel>> {
  DashboardRepository repository;

  FieldworkDashboardBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onFetchDashboard);
  }

  Future<void> _onFetchDashboard(
    ApiFetch event,
    Emitter<ApiState<FieldworkerDashboardResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());
    try {
      final result = await repository.getFieldWorkerDashboard();
      debugLog(result.status.toString(), name: "FieldworkDashboardBloc");
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      debugLog(
          name: "FieldworkDashboardBloc", e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}
