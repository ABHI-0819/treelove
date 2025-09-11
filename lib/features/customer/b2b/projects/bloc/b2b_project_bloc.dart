

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/project_repository.dart';

import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/base_network_status.dart';
import '../../../../../core/utils/logger.dart';
import '../model/b2b_project_detail_response_model.dart';

class B2BProjectBloc extends Bloc<ApiEvent, ApiState<B2BProjectDetailResponseModel, ResponseModel>>{
  final ProjectRepository repository;

  B2BProjectBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onFetchProjectDetails);
  }

  Future<void> _onFetchProjectDetails(
      ApiFetch event,
      Emitter<ApiState<B2BProjectDetailResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.fetchB2BProjectDetails(
       projectId: event.id!
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
    } catch (e, stackTrace) {
      debugLog(name: "ProjectDetailBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}
