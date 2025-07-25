import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/task_allocation_respository.dart';
import '../../../../core/network/base_network_status.dart';
import '../models/task_allocation_request_model.dart';
import '../models/task_allocation_response_model.dart';

class TaskAllocationBloc extends Bloc<ApiEvent, ApiState<TaskAllocationResponseModel, ResponseModel>> {
  final TaskAllocationRepository repository;

  TaskAllocationBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<TaskAllocationRequestModel>>(_onAssignTask);
  }

  ///  Handles task assignment (creation)
  Future<void> _onAssignTask(
      ApiAdd<TaskAllocationRequestModel> event,
      Emitter<ApiState<TaskAllocationResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading()); // Emit loading state

    try {
      /// Call repository with the task assignment request model
      final result = await repository.createTaskAllocation(event.data);
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
      // Catch any unexpected exceptions during the process
      emit(ApiFailure(ResponseModel(message: 'An unexpected error occurred: ${e.toString()}')));
    }
  }
}