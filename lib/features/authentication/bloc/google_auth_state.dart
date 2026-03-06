import 'package:treelove/common/models/response.mode.dart';

import '../../../core/services/auth_service.dart';
import '../models/google.login.response.model.dart';

sealed class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleSerciceResult {
  final bool isSuccess;
  final String? errorMessage;

  GoogleSerciceResult({required this.isSuccess, this.errorMessage});
}

class GoogleAuthSuccess extends GoogleAuthState {
  final String accessToken;
  final String refreshToken;

  GoogleAuthSuccess({required this.accessToken, required this.refreshToken});
}

class GoogleAuthFailure extends GoogleAuthState {
  final ResponseModel error;

  GoogleAuthFailure({required this.error});
}

class GoogleNovigateToUserTypeScreen extends GoogleAuthState {
  GoogleUser? googleServiceResponse;
  GoogleNovigateToUserTypeScreen({this.googleServiceResponse});
}

class GoogleAuthNavigateToHomeScreen extends GoogleAuthState {
  final String userType;

  GoogleAuthNavigateToHomeScreen({
    required this.userType,
  });
}



