// --- TreeSpecies Bloc ---
import 'package:bloc/bloc.dart';
import 'package:treelove/core/utils/logger.dart';
import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/tree_species_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../models/tree_species_model.dart';


class TreeSpeciesBloc extends Bloc<ApiEvent, ApiState<TreeSpeciesListResponse, ResponseModel>> {
  final TreeSpeciesRepository repository;

  TreeSpeciesBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchTreeSpecies);
  }

  Future<void> _onFetchTreeSpecies(
      ApiListFetch event,
      Emitter<ApiState<TreeSpeciesListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.getTreeList();

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
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}

class TreeDetailBloc extends Bloc<ApiEvent, ApiState<SingleTreeSpeciesResponse, ResponseModel>> {
  final TreeSpeciesRepository repository;

  TreeDetailBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onFetchTreeById);
  }


  Future<void> _onFetchTreeById(
      ApiFetch event,
      Emitter<ApiState<SingleTreeSpeciesResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.getTreeDetail(treeId: event.id!);

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
      debugLog(e.toString(),stackTrace: stackTrace,name: "Fat Gaya");
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}
