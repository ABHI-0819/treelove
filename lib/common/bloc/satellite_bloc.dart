import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/core/utils/logger.dart';
import '../../core/network/base_network_status.dart';
import '../models/response.mode.dart';
import '../models/satellite_monitor_history_response.dart';
import '../models/satellite_monitor_response.dart';
import '../repositories/monitor_repository.dart';
import 'api_state.dart';


class SatelliteBloc extends Bloc<ApiEvent, ApiState<SatelliteMonitorResponse, ResponseModel>> {
  final MonitorRepository repository;

  SatelliteBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_satelliteResult);
  }

  /// ✅ Handles monitor creation
  Future<void> _satelliteResult(
      ApiFetch event,
      Emitter<ApiState<SatelliteMonitorResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      debugLog("Running",name: "Executed");
      /// Call repository with request model
      final result = await repository.fetchSatelliteMonitorById(id:event.id!);
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response)); // MonitorResponse
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response)); //  go to SignIn
          break;
        case ApiStatus.unAuthorized:
          emit(ApiFailure(ResponseModel(
            message: "Unauthorized access. Please login again.",
          )));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}

class SatelliteHistoryBloc extends Bloc<ApiEvent,ApiState<SatelliteMonitoringHistoryResponse,ResponseModel>>{
  final MonitorRepository repository;

  SatelliteHistoryBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_satelliteResult);
  }

  /// ✅ Handles monitor creation
  Future<void> _satelliteResult(
      ApiListFetch event,
      Emitter<ApiState<SatelliteMonitoringHistoryResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      debugLog("Running",name: "Executed");
      /// Call repository with request model
      final result = await repository.fetchSatelliteMonitorHistory(Id:event.id!);
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response)); // MonitorResponse
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response)); //  go to SignIn
          break;
        case ApiStatus.unAuthorized:
          emit(ApiFailure(ResponseModel(
            message: "Unauthorized access. Please login again.",
          )));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}