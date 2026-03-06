import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({super.key});

  Widget shimmerBox({double? width, double? height, ShapeBorder? shape}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          /// Avatar
          shimmerBox(
            width: 48.r,
            height: 48.r,
            shape: const CircleBorder(),
          ),

          SizedBox(width: 16.w),

          /// Name + Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(width: 140.w, height: 16.h),
                SizedBox(height: 8.h),
                shimmerBox(width: 80.w, height: 12.h),
              ],
            ),
          ),

          /// Icons
          Row(
            children: [
              shimmerBox(
                width: 32.r,
                height: 32.r,
                shape: const CircleBorder(),
              ),
              SizedBox(width: 10.w),
              shimmerBox(
                width: 32.r,
                height: 32.r,
                shape: const CircleBorder(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class StaffListShimmer extends StatelessWidget {
  const StaffListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return const ProfileCardShimmer();
      },
    );
  }
}