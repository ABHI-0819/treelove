import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/response.mode.dart';
import '../../../common/repositories/login_repository.dart';
import '../../../core/network/base_network_status.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/preference_keys.dart';
import '../../../core/storage/secure_storage.dart';
import '../models/google.login.request.model.dart';
import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final authService = AuthService();
  final LoginRepository repository;
  final pref = SecurePreference();

  GoogleAuthBloc(this.repository) : super(GoogleAuthInitial()) {
    on<GoogleAuthStarted>(_onStarted);
    on<GoogleAuthLogin>(_onLogin);
  }

  Future<void> _onStarted(
    GoogleAuthStarted event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      final googleUser = await authService.signInWithGoogle();
      if (googleUser != null) {
        if (googleUser.isNewUser) {
          emit(GoogleNovigateToUserTypeScreen(
            googleServiceResponse: GoogleUser(
              email: googleUser.email,
              displayName: googleUser.displayName,
              uid: googleUser.uid,
              accessToken: googleUser.accessToken,
              idToken: googleUser.idToken,
              isNewUser: googleUser.isNewUser,
            ),
          ));
        } else {
          add(GoogleAuthLogin(
              request: GoogleLoginRequestModel(
                  email: googleUser.email,
                  name: googleUser.displayName,
                  idToken: googleUser.idToken!,
                  oauthUid: googleUser.uid.toString(),
                  provider: "google",
                  // userTypeId:
                  //     "03edfa34-3232-4fdf-85f9-a9d8d8270581", // Assuming '2' is the user type for existing users
                  additionalData: {
                "profilePicture": googleUser.photoURL.toString(),
              })));
        }
      } else {
        emit(GoogleAuthInitial());
      }
    } catch (e) {
      emit(GoogleAuthFailure(
          error: ResponseModel(
              status: "failed",
              message: "Google Sign-In failed: ${e.toString()}")));
    }
    // Check if user is already authenticated with Google
    // If yes, emit GoogleAuthSuccess with user data
    // If no, emit GoogleAuthInitial to show login button
  }

  Future<void> _onLogin(
    GoogleAuthLogin event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      final result = await repository.googleSignIn(event.request);
      switch (result.status) {
        case ApiStatus.success || ApiStatus.created:
          if (result.response.data?.requiresGroupSelection == true) {
            final googleUser = await authService.signInWithGoogle();
            if (googleUser != null) {
              emit(GoogleNovigateToUserTypeScreen(
                googleServiceResponse: GoogleUser(
                  email: event.request.email,
                  displayName: event.request.name,
                  uid: googleUser.uid,
                  idToken: googleUser.idToken,
                  isNewUser: googleUser.isNewUser,
                ),
              ));
            } else {
              emit(GoogleAuthFailure(
                  error: ResponseModel(
                      status: "failed",
                      message:
                          "Google Sign-In failed during group selection.")));
            }
          } else {
            pref.setString(
                Keys.accessToken, result.response.data?.tokens.access ?? '');
            pref.setString(
                Keys.refreshToken, result.response.data?.tokens.refresh ?? '');
            emit(GoogleAuthNavigateToHomeScreen(
              userType: result.response.data?.userType ?? '',
            ));
          }
        case ApiStatus.unAuthorized:
          emit(GoogleAuthFailure(error: result.response));
          break;
        default:
          emit(GoogleAuthFailure(error: result.response));
      }
    } catch (e) {
      emit(GoogleAuthFailure(
          error: ResponseModel(status: "failed", message: e.toString())));
    }
  }
}
