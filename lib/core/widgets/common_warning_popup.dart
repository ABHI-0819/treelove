import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../config/resource/images.dart';
import '../config/themes/app_color.dart';
class CommonWarningPopUp extends StatefulWidget {
  final String  title;
  final String  content;
  final VoidCallback ? cancel;
  final VoidCallback ? ok;
  final String ? cancelButtonLabel;
  final String ? okButtonLabel;
  const CommonWarningPopUp({required this.title,required this.content,this.cancel,this.ok,this.cancelButtonLabel,this.okButtonLabel,Key? key}) : super(key: key);

  @override
  State<CommonWarningPopUp> createState() => _CommonWarningPopUpState();
}

class _CommonWarningPopUpState extends State<CommonWarningPopUp> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Lottie.asset(
              Images.warning,
              width: 70.w,
              height: 70.h,
              animate: true,
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              widget.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.ok,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:  Text(
                      'Yes, ${widget.okButtonLabel}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.cancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E5E5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}