import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/sign_in_repository.dart';
import 'package:treelove/features/authentication/models/register_request_model.dart';

import '../../../common/bloc/api_event.dart';
import '../../../common/bloc/api_state.dart';
import '../../../common/models/response.mode.dart';
import '../../../core/network/base_network_status.dart';

class RegisterBloc extends Bloc<ApiEvent, ApiState<ResponseModel,ResponseModel>> {
  final SignInRepository repository;

  RegisterBloc(this.repository) : super( ApiInitial()) {
    on<ApiAdd<RegistrationRequest>>(_onRegister);
  }

  Future<void> _onRegister(
      ApiAdd<RegistrationRequest> event,
      Emitter<ApiState<ResponseModel,ResponseModel>> emit,
      ) async {
    emit( ApiLoading());

    final result = await repository.addSignInRecord(
     request: event.data
    );

    switch (result.status) {
      case ApiStatus.success || ApiStatus.created:
        emit(ApiSuccess(result.response));
        // Background FCM token sync
        break;
      case ApiStatus.failed:
        emit(ApiFailure(result.response));
        break;
      default:
        ResponseModel data = result.response;
        emit(ApiFailure(data));
    }
  }

}