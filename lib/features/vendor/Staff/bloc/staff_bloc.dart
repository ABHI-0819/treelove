import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/staff_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../models/staff_request_model.dart';
import '../models/staff_response_model.dart';

class StaffBloc extends Bloc<ApiEvent, ApiState<StaffResponseModel, ResponseModel>> {
  final StaffRepository repository;

  StaffBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<AddStaffRequestModel>>(_onCreateStaff);
  }

  ///  Handles task assignment (creation)
  Future<void> _onCreateStaff(
      ApiAdd<AddStaffRequestModel> event,
      Emitter<ApiState<StaffResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading()); // Emit loading state

    try {
      /// Call repository with the task assignment request model
      final result = await repository.createStaff(event.data);
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(TokenExpired(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'An unexpected error occurred: ${e.toString()}')));
    }
  }
}

class StaffListBloc extends Bloc<ApiEvent, ApiState<StaffListResponseModel, ResponseModel>> {
  final StaffRepository repository;

  StaffListBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchStaffList);
  }

  ///  Handles task assignment (creation)
  Future<void> _onFetchStaffList(
      ApiListFetch event,
      Emitter<ApiState<StaffListResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading()); // Emit loading state

    try {
      /// Call repository with the task assignment request model
      final result = await repository.fetchStaffList();
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(TokenExpired(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'An unexpected error occurred: ${e.toString()}')));
    }
  }


}

class StaffSuspendBloc extends Bloc<ApiEvent, ApiState<ResponseModel, ResponseModel>> {
  final StaffRepository repository;
  StaffSuspendBloc(this.repository) : super(ApiInitial()) {
    on<ApiDelete>(_onSuspendStaff);
  }

  Future<void> _onSuspendStaff(
      ApiDelete event,
      Emitter<ApiState<ResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading()); // Emit loading state

    try {
      /// Call repository with the task assignment request model
      final result = await repository.suspendStaff(userId: event.id);
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(TokenExpired(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'An unexpected error occurred: ${e.toString()}')));
    }
  }
}

