
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/project_area_repository.dart';
import '../../../../common/repositories/service_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../../../../core/utils/logger.dart';
import '../models/assigned_service_type_response.dart';
import '../models/project_area_list_response.dart';

class ProjectAreaBloc  extends Bloc<ApiEvent, ApiState<ProjectAreasResponse, ResponseModel>> {
  final ProjectAreaRepository repository;

  ProjectAreaBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchProjectListAreas);
  }

  Future<void> _onFetchProjectListAreas(
      ApiListFetch event,
      Emitter<ApiState<ProjectAreasResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchProjectAreas(
        filter: event.filter,
        search: event.search,
        page: event.page,
        limit: event.pageSize,
      );

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
    } catch (e, stackTrace) {
      debugLog(name: "ProjectListBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}

class AreaDetailBloc  extends Bloc<ApiEvent, ApiState<AssignedServiceTypeResponse, ResponseModel>> {
  final ServicesRepository repository;

  AreaDetailBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onFetchAreaDetail);
  }

  Future<void> _onFetchAreaDetail(
      ApiFetch event,
      Emitter<ApiState<AssignedServiceTypeResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.getAssignedServiceDetails(
       projectId: event.projectId!,
        projectAreaId: event.projectAreaId!
      );

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
    } catch (e, stackTrace) {
      debugLog(name: "AreaDetailBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}