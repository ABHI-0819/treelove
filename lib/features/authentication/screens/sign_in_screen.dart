import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/authentication/screens/create_account_screen.dart';
import 'package:treelove/features/authentication/screens/forgot_password_screen.dart';
import 'package:treelove/features/authentication/screens/password_login_screen.dart';

import '../../../core/config/resource/images.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/preference_keys.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/utils/logger.dart';

class SignInScreen extends StatefulWidget {
  static const route ='/sign-in';
   SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  final authService = AuthService();

  SecurePreference preference= SecurePreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.arrow_back, size: 24),
                  Icon(Icons.close, size: 24),
                ],
              ),
              const SizedBox(height: 48),
               Text(
                'Your greens\ngetting closer',
                style: AppFonts.headline.copyWith(
                  fontSize: 32,
                  height: 1.3,
                  color: Colors.black87,
                ),
                // style: TextStyle(
                //   fontSize: 32,
                //   height: 1.3,
                //   fontWeight: FontWeight.w500,
                //   fontFamily: 'Georgia', // Use a serif font if available
                //   color: Colors.black87,
                // ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign in or create an account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address or Phone Number',
                  hintStyle: TextStyle(
                    color: Color(0xFFD6CBA8),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.goToNextPage(context: context, screen: PasswordLoginScreen.route, arguments: {});
                  },
                  child:  Text(
                    'Continue',
                    style: AppFonts.regular

                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F4E4),
                    foregroundColor: const Color(0xFFBDB290),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    handleGoogleSignIn();
                    // AuthService().signInWithGoogle();
                  },
                  icon: SvgPicture.asset(Images.googleIcon),
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFBDB290),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              /*
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Like your original
                    decoration: TextDecoration.underline, // Optional: makes it more obviously tappable
                  ),
                ),
              ),
              
               */
              const SizedBox(height: 64),
              Center(
                child: RichText(
                  text:  TextSpan(
                    text: "Don’t have an account? ",
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            AppRoute.goToNextPage(context: context, screen: CreateAccountScreen.route, arguments: {});

                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void handleGoogleSignIn() async {
    final googleUser = await authService.signInWithGoogle();

    if (googleUser == null) {
      debugLog('User cancelled or sign-in failed.');
      return;
    }

    debugLog(googleUser.uid,name: "uid data");
    preference.set(Keys.token, googleUser.idToken);
    preference.set(Keys.name, googleUser.displayName);
    debugLog(googleUser.idToken.toString(),name: "idToken data");
    debugLog('Signed in user: ${googleUser.displayName}, email: ${googleUser.email}');
    debugLog('Access Token: ${googleUser.accessToken}');
    // Proceed with your app logic here.
  }
}
///
/// Android Debug Key
/*
Variant: debugAndroidTest
Config: debug
Store: /Users/amiand-bhugol2/.android/debug.keystore
Alias: AndroidDebugKey
MD5: FE:0B:A3:10:C9:D3:0D:AA:E8:35:DD:C0:AE:94:68:68
SHA1: A1:A6:FC:50:3D:62:55:71:9F:00:48:CC:44:98:C6:8A:E2:6B:D4:B7
SHA-256: D0:6A:F6:AE:8D:FD:D5:D2:BF:5D:F8:46:14:38:34:58:8A:C8:87:EB:62:8B:E2:18:3D:00:9E:AD:C4:3D:61:4D
Valid until: Monday, 28 December, 2054

 */