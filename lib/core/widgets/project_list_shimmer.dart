import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProjectCardShimmer extends StatelessWidget {
  const ProjectCardShimmer({super.key});

  Widget shimmerBox({double? width, double? height, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Project Title
          shimmerBox(width: 180.w, height: 16.h),

          SizedBox(height: 12.h),

          /// Subtitle
          shimmerBox(width: 120.w, height: 12.h),

          SizedBox(height: 16.h),

          /// Info row
          Row(
            children: [
              shimmerBox(width: 60.w, height: 12.h),
              SizedBox(width: 20.w),
              shimmerBox(width: 60.w, height: 12.h),
              SizedBox(width: 20.w),
              shimmerBox(width: 60.w, height: 12.h),
            ],
          ),

          SizedBox(height: 16.h),

          /// Bottom bar
          shimmerBox(width: double.infinity, height: 12.h),
        ],
      ),
    );
  }
}

class ProjectListShimmer extends StatelessWidget {
  const ProjectListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return const ProjectCardShimmer();
        },
      ),
    );
  }
}
