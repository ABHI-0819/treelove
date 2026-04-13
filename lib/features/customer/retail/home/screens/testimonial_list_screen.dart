import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/models/testimonial_model.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TestimonialListScreen extends StatelessWidget {
  static const String route = '/testimonial-list';
  final List<TestimonialModel> testimonials;

  const TestimonialListScreen({super.key, required this.testimonials});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEF7),
      appBar: AppBar(
        title: Text('Customer Testimonials', style: AppFonts.body),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: testimonials.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final testimonial = testimonials[index];
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: testimonial.userImage.isNotEmpty
                          ? CachedNetworkImageProvider(testimonial.userImage)
                          : null,
                      child: testimonial.userImage.isEmpty
                          ? Icon(Icons.person, size: 30.r)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testimonial.userName,
                            style: AppFonts.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            testimonial.userDesignation,
                            style: AppFonts.caption.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < testimonial.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16.sp,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  testimonial.message,
                  style: AppFonts.body.copyWith(
                    fontSize: 14.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
