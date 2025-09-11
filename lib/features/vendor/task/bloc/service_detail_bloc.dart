import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_event.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/service_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../models/service_detail_response_model.dart';

class ServiceDetailBloc extends Bloc<ApiEvent, ApiState<ServiceDetailResponse, ResponseModel>> {
  final ServicesRepository repository;

  ServiceDetailBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchServiceDetails);
  }

  ///  Handles task assignment (creation)
  Future<void> _onFetchServiceDetails(
      ApiListFetch event,
      Emitter<ApiState<ServiceDetailResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading()); // Emit loading state

    try {
      /// Call repository with the task assignment request model
      final result = await repository.getServiceDetails(
        serviceName: event.serviceName ?? '',
        projectAreaId: event.projectAreaId ?? '',
      );
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
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
      // Catch any unexpected exceptions during the process
      emit(ApiFailure(ResponseModel(message: 'An unexpected error occurred: ${e.toString()}')));
    }
  }
}