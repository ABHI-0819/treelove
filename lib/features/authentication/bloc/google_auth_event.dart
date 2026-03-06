import '../models/google.login.request.model.dart';

sealed class GoogleAuthEvent {}

class GoogleAuthStarted extends GoogleAuthEvent {}

class GoogleAuthLogin extends GoogleAuthEvent {
  final GoogleLoginRequestModel request;

  GoogleAuthLogin({required this.request});
}