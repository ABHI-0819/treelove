import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/route/app_route.dart';

import '../../../../common/screens/notification_screen.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final pref = SecurePreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      // backgroundColor: AppColor.scaffoldBackground.withValues(alpha: 0.60),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 60.h,
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor: AppColor.primary.withValues(alpha: 0.60),
            elevation: 0,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 👋 Greeting Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.0.verticalSpace,
                      Text(
                        "Hello 👋",
                        style: AppFonts.caption.copyWith(
                          color: AppColor.white.withOpacity(0.85),
                        ),
                      ),
                      FutureBuilder<String?>(
                        future: pref.getString(Keys.name),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final name = snapshot.data ?? 'Field Worker';
                            return Text(
                              name,
                              style: AppFonts.title.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColor.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),

                  /// 🔔 Notification Button
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      AppRoute.goToNextPage(
                        context: context,
                        screen: NotificationsScreen.route,
                        arguments: {},
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        /// Notification Dot
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.primary,
                      AppColor.primaryLight,
                      AppColor.secondary.withOpacity(0.85),
                    ],
                  ),
                ),

                /// Decorative shapes
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Overall Summary Cards
                _buildSummarySection(),
                const SizedBox(height: 24),

                // This Week Progress
                _buildWeeklyProgressSection(),
                const SizedBox(height: 24),

                // Today's Tasks
                // _buildTodayTasksSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Summary',
          style: AppFonts.title.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Assignments',
                value: '6',
                icon: Icons.assignment_outlined,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Trees Assigned',
                value: '3,000',
                icon: Icons.park_outlined,
                color: AppColor.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Trees Completed',
          value: '18',
          subtitle: 'Total Progress: 0.6%',
          icon: Icons.check_circle_outline,
          color: AppColor.secondaryDark,
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
    bool isWide = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              if (!isWide) const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isWide ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week Progress',
          style: AppFonts.title.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildWeeklyProgressItem(
                  'Plantation', 18, Icons.eco, AppColor.secondary),
              const SizedBox(height: 16),
              _buildWeeklyProgressItem(
                  'Maintenance', 0, Icons.build, AppColor.primaryLight),
              const SizedBox(height: 16),
              _buildWeeklyProgressItem(
                  'Monitoring', 0, Icons.visibility, AppColor.secondaryDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressItem(
      String type, int count, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              Text(
                '$count trees completed',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
