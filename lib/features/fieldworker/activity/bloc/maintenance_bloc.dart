import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/maintenance_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../models/maintenance_activity_response_model.dart';
import '../models/maintenance_created_response_model.dart';
import '../models/maintenance_request_model.dart';


class MaintenanceBloc extends Bloc<ApiEvent, ApiState<MaintenanceResponse, ResponseModel>> {
  final MaintenanceRepository repository;

  MaintenanceBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<MaintenanceRequestModel>>(_onCreateMaintenance);
  }

  /// ✅ Handles maintenance creation
  Future<void> _onCreateMaintenance(
      ApiAdd<MaintenanceRequestModel> event,
      Emitter<ApiState<MaintenanceResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      /// Call repository with request model
      final result = await repository.addMaintenanceRecord(event.data);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response)); // MaintenanceResponseModel
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response)); // 🚀 go to SignIn
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


class MaintenanceActivityBloc extends Bloc<ApiEvent, ApiState<MaintenanceActivityResponseModel, ResponseModel>> {
  final MaintenanceRepository repository;

  MaintenanceActivityBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchMaintenanceActivityList);
  }

  Future<void> _onFetchMaintenanceActivityList(
      ApiListFetch event,
      Emitter<ApiState<MaintenanceActivityResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchMaintenanceActivityList();

      switch (result.status) {
        case ApiStatus.success || ApiStatus.created:
          emit(ApiSuccess(result.response));
          break;
        /*
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response)); // 🚀 go to SignIn
          break;
        case ApiStatus.unAuthorized:
          emit(ApiFailure(ResponseModel(
            message: "Unauthorized access. Please login again.",
          )));
          break;

         */
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}
