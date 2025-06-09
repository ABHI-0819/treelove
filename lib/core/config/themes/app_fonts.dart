import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_color.dart';

class AppFonts {
  AppFonts._();

  // Font family names must match pubspec.yaml
  static const String daiBannaSIL = 'DaiBannaSIL';
  static const String rasa = 'Rasa';
  static const String poppins = 'Poppins';

  static final TextStyle headline = TextStyle(
    fontSize: 22.sp,
    fontFamily: daiBannaSIL,
    fontWeight: FontWeight.w700,
    color: AppColor.white,
  );

  static final TextStyle title = TextStyle(
    fontSize: 20.sp,
    fontFamily: daiBannaSIL,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 18.sp,
    fontFamily: rasa,
    fontWeight: FontWeight.w500,
    color: AppColor.white,
  );

  static final TextStyle regular = TextStyle(
    fontSize: 16.sp,
    fontFamily: poppins,

    color: AppColor.white,
  );

  static final TextStyle body = TextStyle(
    fontSize: 14.sp,
    fontFamily: poppins,
    fontWeight: FontWeight.w500,
    // fontWeight: FontWeight.normal,
    color: AppColor.black,
  );

  static final TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontFamily: poppins,
    fontWeight: FontWeight.normal,
    // color: AppColor.white,
    color: AppColor.black,
  );

  static final TextStyle small = TextStyle(
    fontSize: 10.sp,
    fontFamily: poppins,
    fontWeight: FontWeight.normal,
    color: AppColor.white,
  );
}
