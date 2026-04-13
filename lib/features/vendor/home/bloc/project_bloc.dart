import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/features/vendor/home/models/project_detail_model.dart';
import 'package:treelove/features/vendor/home/models/vendor_dashboard_model.dart';
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
  
  bool isFetchingMore = false;
  bool hasReachedMax = false;

  ProjectListBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchProjectList);
  }

  Future<void> _onFetchProjectList(
      ApiListFetch event,
      Emitter<ApiState<ProjectListResponse, ResponseModel>> emit,
      ) async {
      
    if (isFetchingMore) return;

    if (event.page == null || event.page == 1) {
      emit(ApiLoading());
      hasReachedMax = false;
    } else {
      if (hasReachedMax) return;
      isFetchingMore = true;
    }

    try {
      final result = await repository.fetchProjects(
        filter: event.filter,
        search: event.search,
        category: event.category,
        type: event.type,
        page: event.page,
        limit: event.pageSize ?? 10,
      );

      switch (result.status) {
        case ApiStatus.success:
          final newResponse = result.response as ProjectListResponse;
          
          if (newResponse.data.length < 10) {
              hasReachedMax = true;
          }

          if (event.page != null && event.page! > 1 && state is ApiSuccess<ProjectListResponse, ResponseModel>) {
            final currentState = state as ApiSuccess<ProjectListResponse, ResponseModel>;
            final currentData = currentState.data;
            
            final updatedList = List<ProjectItem>.from(currentData.data)..addAll(newResponse.data);
            final updatedResponse = ProjectListResponse(
                status: newResponse.status,
                message: newResponse.message,
                data: updatedList
            );
            emit(ApiSuccess(updatedResponse));
          } else {
            emit(ApiSuccess(newResponse));
          }
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      debugLog(name: "ProjectListBloc",  e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    } finally {
      isFetchingMore = false;
    }
  }

}

class VendorDashboardBloc
    extends Bloc<ApiEvent, ApiState<VendorDashboardModel, ResponseModel>> {
  final ProjectRepository repository;

  VendorDashboardBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchDashboard);
  }

  Future<void> _onFetchDashboard(
    ApiListFetch event,
    Emitter<ApiState<VendorDashboardModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());
    try {
      final result = await repository.fetchVendorDashboard();
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      debugLog(name: "VendorDashboardBloc", e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}