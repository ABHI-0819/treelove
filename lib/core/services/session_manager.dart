import 'dart:async';
import 'package:flutter/material.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';
import '../config/constants/enum/session_status.dart';
import '../utils/logger.dart';


class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  late StreamSubscription<SessionStatus> _sessionSubscription;
  final ApiConnection _apiService = ApiConnection();

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _sessionSubscription = _apiService.sessionStream.listen((status) async {
      switch (status) {
        case SessionStatus.expired:
        case SessionStatus.loggedOut:
          await _handleSessionExpired(navigatorKey);
          break;
        case SessionStatus.refreshed:
          debugLog('Token refreshed', name: 'Session');
          break;
        case SessionStatus.active:
          break;
      }
    });
  }

  Future<void> _handleSessionExpired(GlobalKey<NavigatorState> navigatorKey) async {
    debugLog('Session expired. Logging out...', name: 'Session');
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      SignInScreen.route,
          (route) => false,
    );
  }

  void dispose() {
    _sessionSubscription.cancel();
  }
}
