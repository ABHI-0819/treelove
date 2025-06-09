import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import 'project_action_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(120.h),
        child: Container(
          height: 100.h,
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B5B4D), Color(0xFF0E6655)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hello John 😊',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ongoing projects (2)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: (){
                AppRoute.goToNextPage(context: context, screen: ProjectActionScreen.route, arguments: {});
              },
              child: ProjectCard(
                title: 'Thane Plantation Drive 2023',
                subtitle: 'Jio Platforms',
                location: 'Thane, Mumbai',
                taskCount: 15,
              ),
            ),
            const SizedBox(height: 12),
            ProjectCard(
              title: 'Mumbai Metro Line 1',
              subtitle: 'Jio Platforms',
              location: 'Thane, Mumbai',
              taskCount: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String location;
  final int taskCount;

  const ProjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  Images.sampleImg, // make sure this exists
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(subtitle,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 14)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.grey, // You can set the color of the line
            thickness: 1.0,     // You can set the thickness of the line
            indent: 20.0,      // Empty space before the line
            endIndent: 20.0,   // Empty space after the line
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(location,
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          SizedBox(height: 15.h,),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE7F1FC),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  "Today's tasks",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$taskCount',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

