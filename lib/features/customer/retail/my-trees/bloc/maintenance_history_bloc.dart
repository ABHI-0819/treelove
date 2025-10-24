import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/maintenance_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../../../../../core/utils/logger.dart';
import '../models/maintenance_history_list_response.dart'; // if used

class MaintenanceHistoryBloc
    extends Bloc<ApiEvent, ApiState<MaintenanceHistoryListResponse, ResponseModel>> {
  final MaintenanceRepository repository;

  MaintenanceHistoryBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_fetchMaintenanceHistory);
  }

  Future<void> _fetchMaintenanceHistory(
      ApiListFetch event,
      Emitter<ApiState<MaintenanceHistoryListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      debugLog("Fetching maintenance history for ID: ${event.id}", name: "MaintenanceHistoryBloc");

      final result = await repository.fetchMaintenanceHistoryList(id: event.id!);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response as MaintenanceHistoryListResponse));
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
      emit(ApiFailure(ResponseModel(message: 'Failed to load maintenance history.')));
    }
  }
}