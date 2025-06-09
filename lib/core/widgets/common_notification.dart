import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/constants/enum/notification_enum.dart';

Future<void> showNotification(BuildContext context, {required String message, Not? type}) {
  return Flushbar(
    titleText: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w!),
        child: Text(
          type == Not.success
              ? 'Success'
              : type == Not.failed
              ? 'Failed'
              : 'Warning',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )),
    margin: EdgeInsets.symmetric(vertical: 5.h!, horizontal: 10.w!),
    titleColor: Colors.black,
    message: message,
    messageText: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w!),
      child: Text(message, style: TextStyle(fontSize: 12.sp, color: Colors.black)),
    ),
    messageColor: Colors.black,
    icon: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w!),
      child: type == Not.success
          ? Icon(Icons.check_circle_rounded, size: 40.r!, color: Colors.green)
          : type == Not.failed
          ? Icon(Icons.info_outline, size: 40.r!, color: Colors.red)
          : Icon(Icons.info_outline, size: 40.r!, color: Colors.yellow),
    ),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(8.r!),
    backgroundColor: Colors.white,
    blockBackgroundInteraction: true,
  ).show(context); // ✅ return the Future here
}
