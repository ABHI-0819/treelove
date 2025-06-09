import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/authentication/screens/new_password_screen.dart';

import '../../../core/config/themes/app_fonts.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const route = '/otp-verification';
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  int secondsRemaining = 192; // 3 minutes 12 seconds

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  String get timerText {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 40),
                 Text(
                  'Check your\nphone',
                  style: AppFonts.headline.copyWith(
                    fontSize: 32,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                  // style: TextStyle(
                  //   fontSize: 32,
                  //   fontWeight: FontWeight.w600,
                  //   height: 1.2,
                  // ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Enter the OTP sent to your number ending in ••••1234.\nDidn't get the code? Wait a few seconds or tap resend.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: otpController,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(fontSize: 32),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    inactiveColor: const Color(0xFF00473E),
                    activeColor: const Color(0xFF00473E),
                    selectedColor: const Color(0xFF00473E),
                    errorBorderColor: Colors.red,
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Code expires in:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timerText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00473E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: () {
                     AppRoute.goToNextPage(context: context, screen: NewPasswordScreen.route, arguments: {});
                    },
                    child:  Text(
                      'Continue',
                        style: AppFonts.regular
                    ),
                  ),
                ),
                const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F2E8),
                    foregroundColor: const Color(0xFFD2C7A6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  onPressed: secondsRemaining == 0
                      ? () {
                    // handle resend
                    setState(() {
                      secondsRemaining = 180;
                      _startCountdown();
                    });
                  }
                      : null,
                  child: const Text(
                    'Send again',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
