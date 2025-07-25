import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../../../vendor/home/screens/home_screen.dart';

class B2BProjectScreen extends StatefulWidget {
  const B2BProjectScreen({super.key});

  @override
  State<B2BProjectScreen> createState() => _B2BProjectScreenState();
}

class _B2BProjectScreenState extends State<B2BProjectScreen> {
  String selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:AppBar(
        backgroundColor: AppColor.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        toolbarHeight: 64, // Slightly taller for a modern look
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Add filter action
              },
              icon:  Icon(Icons.filter_list, size: 18,color: AppColor.white,),
              label: const Text('Filters'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1A5F3E),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
      /*
      appBar:AppBar(
      automaticallyImplyLeading: false, // disable default
      backgroundColor: const Color(0xFF1A5F3E),
      title: Text(
        'Projects',
        style: AppFonts.regular.copyWith(
          color: AppColor.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

       */
      body: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Search Field
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      hintText: 'Search project',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF1A5F3E), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('All', 'All'),
                _buildTab('Ongoing', 'Ongoing'),
                _buildTab('Completed', 'Completed'),
              ],
            ),
          ),
            /// TODO: Uncomment this
          // Project Cards
          /*
          Expanded(
            child: ListView.builder(
              // padding: EdgeInsets.all(16),
              itemCount: 2, // Number of projects
              itemBuilder: (context, index) {
                return ProjectCard();
              },
            ),
          ),

           */
        ],
      ),
    );
  }

  // Reusable Tab Widget
  Widget _buildTab(String label, String value) {
    bool isSelected = selectedTab == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = value;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Text(
            label,
            style: AppFonts.body.copyWith(
              color: isSelected ? Color(0xFF1A5F3E) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            )
        ),
      ),
    );
  }
}


