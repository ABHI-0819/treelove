import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../common/repositories/sign_in_repository.dart';
import '../../../core/config/route/app_route.dart';
import '../../../core/network/api_connection.dart';
import '../bloc/registration_otp_bloc.dart';
import '../bloc/registration_otp_event.dart';
import '../bloc/registration_otp_state.dart';
import 'registration_success_screen.dart';

class RegistrationOtpScreen extends StatefulWidget {
   static const route = '/registration-otp';
  final String phone;
  final String email;

  const RegistrationOtpScreen({
    super.key,
    this.phone = '',
    this.email = '',
  });

  @override
  State<RegistrationOtpScreen> createState() => _RegistrationOtpScreenState();
}

class _RegistrationOtpScreenState extends State<RegistrationOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  late String maskedValue;
  int secondsRemaining = 60;
  Timer? _timer;

  late RegistrationOtpBloc registrationOtpBloc;

  @override
  void initState() {
    super.initState();

    registrationOtpBloc = RegistrationOtpBloc(
      repository: SignInRepository(api: ApiConnection()),
      phone: widget.phone,
      email: widget.email,
    );

    _setupMaskedValue();
    _startCountdown();
  }

  void _setupMaskedValue() {
    if (widget.phone.isNotEmpty) {
      maskedValue =
          '+91 ${widget.phone.substring(0, 2)} ••• ••• ${widget.phone.substring(widget.phone.length - 2)}';
    } else if (widget.email.isNotEmpty) {
      final parts = widget.email.split('@');
      maskedValue = '${parts[0][0]}•••@${parts[1]}';
    } else {
      maskedValue = 'your contact';
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => secondsRemaining = 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  bool get _isOtpComplete => otpController.text.length == 6;

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    registrationOtpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: registrationOtpBloc,
      child: BlocConsumer<RegistrationOtpBloc, RegistrationOtpState>(
        listener: (context, state) {
          /// ✅ NAVIGATION ONLY AFTER VERIFICATION
          if (state.status == RegistrationOtpStatus.verified) {
            AppRoute.goToNextPage(
              context: context,
              screen: RegistrationSuccessScreen.route,
              arguments: {},
            );
          }

          /// ❌ ERROR HANDLING
          if (state.status == RegistrationOtpStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
              ),
            );
          }

          /// 🔁 Restart timer when OTP is resent
          if (state.status == RegistrationOtpStatus.otpSent) {
            _startCountdown();
          }
        },
        builder: (context, state) {
          final isVerifying =
              state.status == RegistrationOtpStatus.verifyingOtp;

          final isSendingOtp = state.status == RegistrationOtpStatus.sendingOtp;

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        const Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the 6-digit code sent to $maskedValue.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 60),
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),

                  /// BODY
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: otpController,
                            animationType: AnimationType.fade,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textStyle: const TextStyle(fontSize: 32),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: 60,
                              fieldWidth: 40,
                              inactiveColor: const Color(0xFF00473E),
                              activeColor: const Color(0xFF00473E),
                              selectedColor: const Color(0xFF00473E),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),

                          const SizedBox(height: 40),

                          /// VERIFY BUTTON
                          ///
                          SizedBox(
                            width: double.infinity,
                            height: 47.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isOtpComplete && !isVerifying
                                  ? () {
                                      registrationOtpBloc.add(
                                        VerifyOtp(otpController.text),
                                      );
                                    }
                                  : null,
                              child: isVerifying
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Verify',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.white),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// RESEND SECTION
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                secondsRemaining > 0
                                    ? "Resend OTP in 00:${secondsRemaining.toString().padLeft(2, '0')}"
                                    : "Didn't get the OTP?",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (secondsRemaining == 0 && !isSendingOtp)
                                GestureDetector(
                                  onTap: () {
                                    registrationOtpBloc.add(ResendOtp());
                                  },
                                  child: const Text(
                                    ' Resend',
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
