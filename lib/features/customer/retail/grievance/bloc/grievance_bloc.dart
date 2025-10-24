// bloc/grievance_list_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/grievance_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../model/grievance_category_list_response.dart';
import '../model/grievance_list_response.dart';
import '../model/grievance_request.dart';
import '../model/grievance_response.dart';
// bloc/grievance_submit_bloc.dart



class GrievanceBloc
    extends Bloc<ApiEvent, ApiState<GrievanceResponse, ResponseModel>> {
  final GrievanceRepository repository;

  GrievanceBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<GrievanceRequestModel>>(_submitGrievance);
  }

  Future<void> _submitGrievance(
      ApiAdd<GrievanceRequestModel> event,
      Emitter<ApiState<GrievanceResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.postGrievance(event.data);
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response));
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
      emit(ApiFailure(ResponseModel(message: 'Failed to submit grievance.')));
    }
  }
}

class GrievanceListBloc
    extends Bloc<ApiEvent, ApiState<GrievanceListResponse, ResponseModel>> {
  final GrievanceRepository repository;

  GrievanceListBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_fetchGrievances);
  }

  Future<void> _fetchGrievances(
      ApiListFetch event,
      Emitter<ApiState<GrievanceListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.fetchAllGrievances();
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response));
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
      emit(ApiFailure(ResponseModel(message: 'Failed to load grievances.')));
    }
  }
}



class GrievanceCategoryBloc
    extends Bloc<ApiEvent, ApiState<GrievanceCategoryListResponse, ResponseModel>> {
  final GrievanceRepository repository;

  GrievanceCategoryBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_fetchCategories);
  }

  Future<void> _fetchCategories(
      ApiListFetch event,
      Emitter<ApiState<GrievanceCategoryListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.fetchGrievanceCategories();
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response));
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
      emit(ApiFailure(ResponseModel(message: 'Failed to load categories.')));
    }
  }
}