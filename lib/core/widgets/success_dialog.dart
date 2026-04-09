import 'package:flutter/material.dart';
import 'package:treelove/core/config/constants/enum/navigation_enum.dart';
import 'package:treelove/core/config/route/app_route.dart';

class SuccessDialog {
  static void showAndPop({
    required BuildContext context,
    String title = 'Success!',
    String message = 'Operation completed successfully.',
    int delayMilliseconds = 2000,
    dynamic returnResult = NavigationResult.success,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );

    // Wait and pop
    Future.delayed(Duration(milliseconds: delayMilliseconds), () {
      if (context.mounted) {
        Navigator.pop(context); // pop dialog
        AppRoute.safePopWithResult(context, returnResult); // pop screen
      }
    });
  }
}
