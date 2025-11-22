import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/features/vendor/home/models/project_detail_model.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/project_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../../../../core/utils/logger.dart';
import '../models/project_list_model.dart';

class ProjectBloc extends Bloc<ApiEvent, ApiState<ProjectDetailResponse, ResponseModel>>{
  final ProjectRepository repository;

  ProjectBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onFetchProjectDetails);
  }

  Future<void> _onFetchProjectDetails(
      ApiFetch event,
      Emitter<ApiState<ProjectDetailResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      final result = await repository.fetchProjectDetails(
       projectId: event.id!
      );
      switch (result.status) {
        case ApiStatus.success:
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
    } catch (e, stackTrace) {
      debugLog(name: "ProjectDetailBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}

class ProjectListBloc  extends Bloc<ApiEvent, ApiState<ProjectListResponse, ResponseModel>> {
  final ProjectRepository repository;

  ProjectListBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchProjectList);
  }

  Future<void> _onFetchProjectList(
      ApiListFetch event,
      Emitter<ApiState<ProjectListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchProjects(
        filter: event.filter,
        search: event.search,
        category: event.category,
        type: event.type,
        page: event.page,
        limit: event.pageSize,
      );

      switch (result.status) {
        case ApiStatus.success:
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
    } catch (e, stackTrace) {
      debugLog(name: "ProjectListBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}