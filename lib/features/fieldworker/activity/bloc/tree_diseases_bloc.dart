import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/tree_diseases_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../../../../core/utils/logger.dart';
import '../models/tree_diseases_list_response_model.dart';

class TreeDiseasesBloc extends Bloc<ApiEvent, ApiState<TreeDiseaseListResponse, ResponseModel>> {
  final TreeDiseasesRepository repository;

  TreeDiseasesBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchTreeDiseasesList);
  }

  Future<void> _onFetchTreeDiseasesList(
      ApiListFetch event,
      Emitter<ApiState<TreeDiseaseListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.getTreeDiseaseList(
        diseasesId: event.diseasesId
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
      debugLog(name: "DiseaseListBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(status: "Failed",message: 'Something went wrong.')));
    }
  }
}