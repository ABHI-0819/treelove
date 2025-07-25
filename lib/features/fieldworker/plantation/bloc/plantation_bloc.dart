import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/plantation_repository.dart';
import '../../../../core/network/base_network_status.dart';
import '../models/plantation_model.dart';


class PlantationBloc extends Bloc<ApiEvent, ApiState<PlantationResponseModel, ResponseModel>> {
  final PlantationRepository repository;

  PlantationBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<PlantationRequestModel>>(_onCreatePlantation);
  }

  /// ✅ Handles plantation creation
  Future<void> _onCreatePlantation(
      ApiAdd<PlantationRequestModel> event,
      Emitter<ApiState<PlantationResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      /// Call repository with request model
      final result = await repository.createPlantation(event.data);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response)); // PlantationResponseModel
          break;
        case ApiStatus.unAuthorized:
          emit(TokenExpired(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}
