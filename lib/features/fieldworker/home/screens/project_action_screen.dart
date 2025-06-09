import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../../core/config/route/app_route.dart';
import 'select_tree_species.dart';
import 'tree_plantation_screen.dart';

class ProjectActionScreen extends StatelessWidget {
  static const route ='/ProjectActionScreen';
  final List<Map<String, dynamic>> actions = [
    {
      'title': 'Plantation',
      'icon': Icons.spa,
      'color': Colors.green.shade100,
      'badge': 5,
    },
    {
      'title': 'Maintenance',
      'icon': Icons.water_drop,
      'color': Colors.blue.shade100,
      'badge': 5,
    },
    {
      'title': 'Monitoring',
      'icon': Icons.search,
      'color': Colors.purple.shade100,
      'badge': 5,
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final item = actions[index];
                return _buildActionCard(
                  title: item['title'],
                  icon: item['icon'],
                  badgeCount: item['badge'],
                  bgColor: item['color'],
                  onTap: (){
                    AppRoute.goToNextPage(context: context, screen: SelectTreeTypeScreen.route, arguments: {});
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: const Color(0xFF005247),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => AppRoute.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            SizedBox(height: 16.h),
            const Text(
              'Thane Plantation Metro Drive 2023',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.white70, size: 16),
                SizedBox(width: 4),
                Text(
                  'Thane, Mumbai',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required int badgeCount,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: Colors.black, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                badges.Badge(
                  badgeContent: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}


/*

class ProjectActionScreen extends StatelessWidget {
  static const route = '/ProjectActionScreen';

  final List<_ActionItem> actions = const [
    _ActionItem(
      title: 'Plantation',
      icon: Icons.spa,
      color: Color(0xFFC8E6C9), // Colors.green.shade100
      badge: 5,
    ),
    _ActionItem(
      title: 'Geo-tagging',
      icon: Icons.location_on,
      color: Color(0xFFFFCDD2), // Colors.red.shade100
      badge: 5,
    ),
    _ActionItem(
      title: 'Monitoring',
      icon: Icons.search,
      color: Color(0xFFE1BEE7), // Colors.purple.shade100
      badge: 5,
    ),
    _ActionItem(
      title: 'Maintenance',
      icon: Icons.water_drop,
      color: Color(0xFFBBDEFB), // Colors.blue.shade100
      badge: 5,
    ),
  ];

  const ProjectActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 16.h),
                itemCount: actions.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final item = actions[index];
                  return _ActionCard(
                    title: item.title,
                    icon: item.icon,
                    badgeCount: item.badge,
                    bgColor: item.color,
                    onTap: () {
                      // Navigate or handle tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180.h,
          width: double.infinity,
          color: const Color(0xFF005247),
          padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(height: 16.h),
              const Text(
                'Thane Plantation Metro Drive 2023',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Thane, Mumbai',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
        ),
      ],
    );
  }
}

*/