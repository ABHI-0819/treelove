import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/network/base_network_status.dart';
import '../../core/utils/logger.dart';
import '../models/profile_response_model.dart';
import '../models/response.mode.dart';
import '../models/update_profile_request_model.dart';
import '../repositories/profile_repository.dart';
import 'api_event.dart';
import 'api_state.dart';

class ProfileBloc
    extends Bloc<ApiEvent, ApiState<ProfileResponseModel, ResponseModel>> {
  final ProfileRepository repository;

  ProfileBloc(this.repository)
      : super(ApiInitial<ProfileResponseModel, ResponseModel>()) {
    on<ApiFetch>(_onFetchProfile);
    on<ApiUpdate<UpdateProfileRequest>>(_onUpdateProfile);
  }

  /// 📌 Fetch Profile
  Future<void> _onFetchProfile(
    ApiFetch event,
    Emitter<ApiState<ProfileResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchUserProfile();

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;

        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      debugLog(
        name: "ProfileBloc",
        e.toString(),
        stackTrace: stackTrace,
      );
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }

  /// 📌 Update Profile (PATCH Multipart)
  Future<void> _onUpdateProfile(
    ApiUpdate<UpdateProfileRequest> event,
    Emitter<ApiState<ProfileResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());

    try {
      final result = await repository.updateUserProfile(event.data);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;

        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      debugLog(
        name: "ProfileBloc",
        e.toString(),
        stackTrace: stackTrace,
      );
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}
