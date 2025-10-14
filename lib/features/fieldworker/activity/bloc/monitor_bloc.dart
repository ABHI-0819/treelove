import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/monitor_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../models/monitor_created_response_model.dart';
import '../models/monitor_request_model.dart';

class MonitorBloc extends Bloc<ApiEvent, ApiState<MonitorResponse, ResponseModel>> {
  final MonitorRepository repository;

  MonitorBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<MonitorRequestModel>>(_onCreateMonitor);
  }

  /// ✅ Handles monitor creation
  Future<void> _onCreateMonitor(
      ApiAdd<MonitorRequestModel> event,
      Emitter<ApiState<MonitorResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      /// Call repository with request model
      final result = await repository.addMonitorRecord(event.data);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response)); // MonitorResponse
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
