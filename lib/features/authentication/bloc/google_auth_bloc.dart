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
        // Forward Google credentials to backend directly. Let backend dictate new/existing state.
        add(GoogleAuthLogin(
            request: GoogleLoginRequestModel(
                email: googleUser.email,
                name: googleUser.displayName,
                idToken: googleUser.idToken ?? "",
                oauthUid: googleUser.uid,
                provider: "google",
                additionalData: {
                  "profilePicture": googleUser.photoURL ?? "",
                })));
      } else {
        emit(GoogleAuthInitial());
      }
    } catch (e) {
      emit(GoogleAuthFailure(
          error: ResponseModel(
              status: "failed",
              message: "Google Sign-In failed: ${e.toString()}")));
    }
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
            // Already have user data from the event request, bypass redundant sign-in!
            emit(GoogleNovigateToUserTypeScreen(
              googleServiceResponse: GoogleUser(
                email: event.request.email,
                displayName: event.request.name,
                uid: event.request.oauthUid??'',
                idToken: event.request.idToken,
                photoURL: event.request.additionalData?["profilePicture"],
                isNewUser: true,
              ),
            ));
          } else {
            final authData = result.response.data;
            if (authData != null && authData.user != null) {
              final user = authData.user!;
              final profile = user.profile;
              
              pref.setString(Keys.id, user.id ?? '');
              pref.setString(Keys.email, user.email ?? '');
              pref.setString(Keys.phone, user.phone ?? '');
              pref.setString(Keys.groupName, user.groupName ?? '');
              pref.setBool(Keys.isActive, user.isActive ?? false);
              
              if (profile != null) {
                pref.setString(Keys.profileId, profile.id ?? '');
                pref.setString(Keys.name, "${profile.firstName ?? ''} ${profile.lastName ?? ''}".trim());
                pref.setString(Keys.firstName, profile.firstName ?? '');
                pref.setString(Keys.lastName, profile.lastName ?? '');
              }
            }

            final tokens = result.response.data?.tokens;
            if (tokens != null) {
              pref.setString(Keys.accessToken, tokens.access ?? '');
              pref.setString(Keys.refreshToken, tokens.refresh ?? '');
              pref.setString(Keys.accessTokenExpires, tokens.accessExpires?.toString() ?? '');
              pref.setString(Keys.refreshTokenExpires, tokens.refreshExpires?.toString() ?? '');
            }

            emit(GoogleAuthNavigateToHomeScreen(
              userType: result.response.data?.user?.groupName ?? '',
            ));
          }
          break;
        case ApiStatus.unAuthorized:
        default:
          emit(GoogleAuthFailure(error: result.response));
      }
    } catch (e) {
      emit(GoogleAuthFailure(
          error: ResponseModel(status: "failed", message: e.toString())));
    }
  }
}
