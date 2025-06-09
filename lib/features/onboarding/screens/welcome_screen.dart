import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';

import '../../../core/config/resource/images.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              Images.welcomeBg,
              fit: BoxFit.cover,
            ),
          ),

          // Logo
          Align(
            alignment: const Alignment(0, -0.2),
            child: SizedBox(
              width: 164,
              height: 146,
              child: Image.asset(
               Images.appLogo,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Tagline
          Align(
            alignment: const Alignment(0, 0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Together, we are fostering a leafier tomorrow',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFF5F0E2),
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  height: 1.3,
                ),
              ),
            ),
          ),

          // CTA Button
          Align(
            alignment: const Alignment(0, 0.85),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00473C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: () {
                // TODO: Navigate to next screen
                AppRoute.goToNextPage(context: context, screen: SignInScreen.route, arguments: {});
              },
              child: Text(
                'Let’s get started',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFF8F4E3),
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
