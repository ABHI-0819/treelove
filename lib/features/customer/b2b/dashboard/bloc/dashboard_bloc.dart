

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_state.dart';
import 'package:treelove/common/repositories/dashboard_repository.dart';
import 'package:treelove/features/customer/b2b/dashboard/model/dashboard_response_model.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/base_network_status.dart';
import '../../../../../core/utils/logger.dart';

class B2BDashboardBloc extends Bloc<ApiEvent, ApiState<DashboardResponseModel, ResponseModel>>{
  final DashboardRepository repository;

  B2BDashboardBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onFetchDashboardDetails);
  }

  Future<void> _onFetchDashboardDetails(
      ApiFetch event,
      Emitter<ApiState<DashboardResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.getB2BDashboardData();
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
    } catch (e, stackTrace) {
      debugLog(name: "ProjectDetailBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}

