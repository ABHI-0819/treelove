import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/monitor_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../../../../../core/utils/logger.dart';
import '../models/monitor_history_list_response.dart';

class MonitoringHistoryBloc
    extends Bloc<ApiEvent, ApiState<MonitoringHistoryListResponse, ResponseModel>> {
  final MonitorRepository repository;

  MonitoringHistoryBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_fetchMonitoringHistory);
  }

  Future<void> _fetchMonitoringHistory(
      ApiListFetch event,
      Emitter<ApiState<MonitoringHistoryListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      debugLog("Fetching monitoring history for plantation ID: ${event.id}", name: "MonitoringHistoryBloc");

      final result = await repository.fetchMonitorHistory(plantationId: event.id!);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response as MonitoringHistoryListResponse));
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response as ResponseModel));
          break;
        case ApiStatus.unAuthorized:
          emit(ApiFailure(ResponseModel(
            message: "Unauthorized access. Please login again.",
          )));
          break;
        default:
          emit(ApiFailure(result.response as ResponseModel));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Failed to load monitoring history.')));
    }
  }
}