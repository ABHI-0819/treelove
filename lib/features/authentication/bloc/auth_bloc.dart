import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/models/response.mode.dart';
import 'package:treelove/features/authentication/models/login.request.model.dart';
import 'package:treelove/features/authentication/models/login.response.model.dart';

import '../../../common/bloc/api_event.dart';
import '../../../common/bloc/api_state.dart';
import '../../../common/repositories/login_repository.dart';
import '../../../core/network/base_network_status.dart';


class AuthBloc extends Bloc<ApiEvent, ApiState<LoginResponseModel,ResponseModel>> {
  final LoginRepository repository;

  AuthBloc(this.repository) : super( ApiInitial()) {
    on<ApiAdd<LoginRequestModel>>(_onLogin);
  }

  Future<void> _onLogin(
    ApiAdd<LoginRequestModel> event,
    Emitter<ApiState<LoginResponseModel,ResponseModel>> emit,
  ) async {
    emit( ApiLoading());

    final result = await repository.login(
      email: event.data.email,
      password: event.data.password,
    );

    switch (result.status) {
      case ApiStatus.success:
        emit(ApiSuccess(result.response));
        break;
      case ApiStatus.unAuthorized:
        emit( TokenExpired(result.response));
        break;
      default:
        ResponseModel data = result.response;
        emit(ApiFailure(data));
    }
  }

}

class LogoutBloc extends Bloc<ApiEvent, ApiState<ResponseModel, ResponseModel>> {
  final LoginRepository repository; // or LogoutRepository

  LogoutBloc(this.repository) : super(ApiInitial()) {
    on<ApiDelete>(_onLogout); // or ApiAdd, but Delete is more semantic
  }

  Future<void> _onLogout(
      ApiDelete event,
      Emitter<ApiState<ResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    final result = await repository.logout(refreshToken: event.id);

    switch (result.status) {
      case ApiStatus.success:
        emit(ApiSuccess(result.response));
      case ApiStatus.resetContent: // ✅ for 204/205 status
        emit(ApiSuccess(result.response));
        break;
      case ApiStatus.unAuthorized:
        emit(TokenExpired(result.response));
        break;

      default:
        emit(ApiFailure(result.response));
    }
  }
}


/*

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());

    try {
      final ApiResult result = await repository.login(email: event.email, password: event.password);

      switch (result.status) {
        case ApiStatus.success:
          emit(AuthState.loginSuccess(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(AuthState.failure('Unauthorized access'));
          break;
        default:
          emit(AuthState.failure('Login failed: ${result.response}'));
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onFetchUserDetails(Emitter<AuthState> emit) async {
    emit(AuthState.loading());

    try {
      final ApiResult result = await repository.getUserDetails();

      switch (result.status) {
        case ApiStatus.success:
          emit(AuthState.userFetchSuccess(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(AuthState.failure('Session expired'));
          break;
        default:
          emit(AuthState.failure('Failed to fetch user details'));
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

   */
