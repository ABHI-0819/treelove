import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/repositories/sign_in_repository.dart';
import '../../../core/config/constants/enum/otp_purpose.dart';
import '../../../core/network/base_network_status.dart';
import '../models/otp_send_request.dart';
import '../models/otp_verify_request.dart';
import 'registration_otp_event.dart';
import 'registration_otp_state.dart';
/*
class RegistrationOtpBloc
    extends Bloc<RegistrationOtpEvent, ApiState<ResponseModel, ResponseModel>> {
  final SignInRepository repository;
  final String phone;
  final String email;

  Timer? _timer;

  RegistrationOtpBloc({
    required this.repository,
    required this.phone,
    required this.email,
  }) : super(ApiInitial()) {
    on<SendOtp>(_onSendOtp);
    on<ResendOtp>(_onResendOtp);
    on<VerifyOtp>(_onVerifyOtp);

    // auto send OTP
    add(SendOtp());
  }

  bool get isPhonePriority => phone.isNotEmpty;

  Future<void> _onSendOtp(
    SendOtp event,
    Emitter<ApiState<ResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());

    final result = await repository.sendOtp(
      request: OtpSendRequest(
        phone: isPhonePriority ? phone : '',
        email: isPhonePriority ? '' : email,
        purpose: isPhonePriority
            ? OtpPurpose.phoneVerification
            : OtpPurpose.emailVerification,
      ),
    );

    switch (result.status) {
      case ApiStatus.success || ApiStatus.created:
        _startTimer();
        emit(ApiSuccess(result.response));
        break;

      case ApiStatus.failed:
        emit(ApiFailure(result.response));
        break;

      default:
        emit(ApiFailure(result.response));
    }
  }

  Future<void> _onResendOtp(
    ResendOtp event,
    Emitter<ApiState<ResponseModel, ResponseModel>> emit,
  ) async {
    if (_timer?.isActive ?? false) return;
    add(SendOtp());
  }

  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<ApiState<ResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());

    final result = await repository.verifyOtp(
      request: OtpVerifyRequest(
        otp: event.otp,
        phone: phone,
        email: email,
      ),
    );

    switch (result.status) {
      case ApiStatus.success || ApiStatus.created:
        emit(ApiSuccess(result.response));
        break;

      case ApiStatus.failed:
        emit(ApiFailure(result.response));
        break;

      default:
        emit(ApiFailure(result.response));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 60), () {});
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
*/

class RegistrationOtpBloc
    extends Bloc<RegistrationOtpEvent, RegistrationOtpState> {
  final SignInRepository repository;
  final String phone;
  final String email;

  Timer? _timer;

  RegistrationOtpBloc({
    required this.repository,
    required this.phone,
    required this.email,
  }) : super(RegistrationOtpState.initial()) {
    on<SendOtp>(_onSendOtp);
    on<ResendOtp>(_onResendOtp);
    on<VerifyOtp>(_onVerifyOtp);

    add(SendOtp());
  }

  bool get isPhonePriority => phone.isNotEmpty;

  Future<void> _onSendOtp(
    SendOtp event,
    Emitter<RegistrationOtpState> emit,
  ) async {
    emit(state.copyWith(status: RegistrationOtpStatus.sendingOtp));

    final result = await repository.sendOtp(
      request: OtpSendRequest(
        phone: isPhonePriority ? phone : '',
        email: isPhonePriority ? '' : email,
        purpose: isPhonePriority
            ? OtpPurpose.phoneVerification
            : OtpPurpose.emailVerification,
      ),
    );

    if (result.status == ApiStatus.success ||
        result.status == ApiStatus.created) {
      _startTimer();
      emit(state.copyWith(status: RegistrationOtpStatus.otpSent));
    } else {
      emit(state.copyWith(
        status: RegistrationOtpStatus.failure,
        errorMessage: result.response.message,
      ));
    }
  }

  Future<void> _onResendOtp(
    ResendOtp event,
    Emitter<RegistrationOtpState> emit,
  ) async {
    if (_timer?.isActive ?? false) return;
    add(SendOtp());
  }

  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<RegistrationOtpState> emit,
  ) async {
    emit(state.copyWith(status: RegistrationOtpStatus.verifyingOtp));

    final result = await repository.verifyOtp(
      request: OtpVerifyRequest(
        otp: event.otp,
        phone: phone,
        email: email,
      ),
    );

    if (result.status == ApiStatus.success ||
        result.status == ApiStatus.created) {
      emit(state.copyWith(status: RegistrationOtpStatus.verified));
    } else {
      emit(state.copyWith(
        status: RegistrationOtpStatus.failure,
        errorMessage: result.response.message ?? 'Invalid OTP',
      ));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 60), () {});
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

