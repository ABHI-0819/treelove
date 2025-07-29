import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/features/fieldworker/home/screens/monitor_activity_screen.dart';

import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';

class TreeMonitorListScreen extends StatefulWidget {
  static const route = '/tree-monitor-list';

  const TreeMonitorListScreen({super.key});

  @override
  State<TreeMonitorListScreen> createState() => _TreeMonitorListScreenState();
}

class _TreeMonitorListScreenState extends State<TreeMonitorListScreen> {

  final List<Map<String, dynamic>> _treeData = List.generate(
    20, // Simulate more data for scrolling
        (index) => {
      'id': 'T${1239 + index}',
      'name': 'Neem $index',
      'location': 'Thane ${index % 5 + 1}',
      'imageUrl': Images.sampleImg, // Or a network URL
      // Add other relevant tree data fields
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E5D57),
        title: const Text(
          'Monitor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => AppRoute.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: _treeData.length,
        itemBuilder: (context, index) {
          final tree = _treeData[index];
          return _TreeCard(
            treeData: tree,
            onDirectionPressed: () {
              debugPrint("Direction pressed for tree: ${tree['id']}");
            },
            onMonitorPressed: () {
              AppRoute.goToNextPage(context: context, screen: MonitorActivityScreen.route, arguments: {});
            },
          );
        },
      ),
    );
  }
}

class _TreeCard extends StatelessWidget {
  final Map<String, dynamic> treeData;
  final VoidCallback onDirectionPressed;
  final VoidCallback onMonitorPressed;

  const _TreeCard({
    required this.treeData,
    required this.onDirectionPressed,
    required this.onMonitorPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String name = treeData['name'] ?? 'Unknown Tree';
    final String id = treeData['id'] ?? 'ID-??';
    final String location = treeData['location'] ?? 'Unknown Location';
    final String imageUrl = treeData['imageUrl'] ?? Images.sampleImg;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.h,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: _buildTreeImage(imageUrl),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    Text(
                      name,
                      style: AppFonts.body.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      'Tree ID: $id',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                    ),

                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14.r, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDirectionPressed,
                  icon: Icon(Icons.navigation, size: 16.r),
                  label: const Text('Direction'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.primaryDark,
                    side: BorderSide(color: AppColor.primaryDark),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onMonitorPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: const Text('Monitor'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTreeImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 60.w,
        height: 60.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          width: 60.w,
          height: 60.h,
          child: const Icon(Icons.image),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          width: 60.w,
          height: 60.h,
          child: const Icon(Icons.broken_image),
        ),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: 60.w,
        height: 60.h,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildTag(String text, {Color? bgColor, Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.green.shade50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.green.shade800,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

