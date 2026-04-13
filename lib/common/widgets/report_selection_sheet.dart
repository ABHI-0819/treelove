import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import '../repositories/report_repository.dart';

class ReportSelectionSheet extends StatelessWidget {
  final Function(ReportType) onSelect;

  const ReportSelectionSheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Download Project Report',
                style: AppFonts.title.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColor.black),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Select the type of report you want to export as .xlsx',
            style: AppFonts.body.copyWith(color: AppColor.textMuted),
          ),
          SizedBox(height: 20.h),
          _buildOption(
            context,
            title: 'Overall Report',
            subtitle: 'Complete project overview and summary',
            icon: Icons.analytics_outlined,
            type: ReportType.overall,
          ),
          SizedBox(height: 12.h),
          _buildOption(
            context,
            title: 'Maintenance Report',
            subtitle: 'Detailed maintenance activities and status',
            icon: Icons.water_drop_outlined,
            type: ReportType.maintenance,
          ),
          SizedBox(height: 12.h),
          _buildOption(
            context,
            title: 'Monitoring Report',
            subtitle: 'Tree health monitoring and growth data',
            icon: Icons.remove_red_eye_outlined,
            type: ReportType.monitoring,
          ),
          // SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ReportType type,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onSelect(type);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.divider),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColor.primary),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.body.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppFonts.caption.copyWith(color: AppColor.textMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.r, color: AppColor.divider),
          ],
        ),
      ),
    );
  }
}
