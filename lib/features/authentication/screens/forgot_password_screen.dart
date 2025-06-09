import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/features/authentication/screens/otp_verification_screen.dart';

import '../../../core/config/route/app_route.dart';
import '../../../core/config/themes/app_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const route ='/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                children:  [
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
              const SizedBox(height: 48),
               Text(
                'Forgot your\npassword?',
                style: AppFonts.headline.copyWith(
                  fontSize: 32.sp,
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
                'Enter the mail address associated with your account',
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
                    AppRoute.goToNextPage(context: context, screen: OtpVerificationScreen.route, arguments: {});
                  },
                  child:  Text(
                    'Continue',
                      style: AppFonts.regular,
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
