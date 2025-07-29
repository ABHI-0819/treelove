

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/planted.list.response.model.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/network/base_network_status.dart';
import '../../../../core/utils/logger.dart';

class MapBloc  extends Bloc<ApiEvent, ApiState<PlantedListResponseModel, ResponseModel>> {
  final PlantationRepository repository;

  MapBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchPlantedList);
  }

  Future<void> _onFetchPlantedList(
      ApiListFetch event,
      Emitter<ApiState<PlantedListResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchPlantedList(
          areaId:event.areaId,
          vendorId: event.vendorId,
          createdBy: event.createdBy
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
      debugLog(name: "PlantedTreeBloc", e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

}