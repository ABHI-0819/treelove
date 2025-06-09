import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/authentication/screens/forgot_password_screen.dart';

import '../../../core/config/constants/enum/notification_enum.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../customer/retail/home/screens/main_screen.dart';
import '../../fieldworker/home/screens/main_screen.dart';

class PasswordLoginScreen extends StatefulWidget {
  static const route ='/login-password';
  const PasswordLoginScreen({super.key});

  @override
  State<PasswordLoginScreen> createState() => _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends State<PasswordLoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();

  void _onContinuePressed() {
    if(_passwordController.text.isEmpty){
      showNotification(context, message: 'Please enter your password',type:Not.warning);
    } else if(_passwordController.text=='Fieldwork@123'){
      AppRoute.goToNextPage(context: context, screen: FieldWorkerMainScreen.route, arguments: {});
    }else if(_passwordController.text=='Naresh@123'){
      AppRoute.goToNextPage(context: context, screen: RetailMainScreen.route, arguments: {});
    }else{
      showNotification(context, message: 'The password you entered is incorrect',type:Not.warning);
    }
    // final password = _passwordController.text.trim();
    // TODO: Add validation and authentication logic here
    // print("Continue with password: $password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      // backgroundColor: const Color(0xFFFCFCF4), // soft off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Title
               Text(
                'Your greens\ngetting closer',
                style: AppFonts.headline.copyWith(
                  fontSize: 32,
                  height: 1.3,
                  color: Colors.black87,
                ),
                // style: TextStyle(
                //   fontSize: 32,
                //   fontWeight: FontWeight.w600,
                //   fontFamily: 'Serif',
                // ),
              ),
              const SizedBox(height: 24),

              // Info Text
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Sans',
                  ),
                  children: [
                    const TextSpan(text: 'Forgot password? Enter the Email address '),
                    TextSpan(
                      text: 'here',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Handle forgot password link
                          AppRoute.goToNextPage(context: context, screen: ForgotPasswordScreen.route, arguments: {});
                        },
                    ),
                    const TextSpan(text: ' associated with your account'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFFC9C2A8)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                //RetailMainScreen
                child: ElevatedButton(
                  onPressed: _onContinuePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40), // dark green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child:  Text(
                    'Continue',
                      style: AppFonts.regular
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
