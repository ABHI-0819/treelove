import 'package:flutter/material.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';

import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
/*
class TreeMaintenanceListScreen extends StatelessWidget {
  static const route ="/tree-maintenance-list";
  const TreeMaintenanceListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Maintenance ${5}',style: AppFonts.regular,),
        backgroundColor: Color(0xFF1A5F3E), // Dark green color
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,color: AppColor.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 4, // Number of cards
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            margin: EdgeInsets.only(bottom: 16),
            color: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tree Image and Details
                  Row(
                    children: [
                      // Tree Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          Images.sampleImg, // Replace with your image path
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),

                      // Tree Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tree Name
                            Text(
                              'Neem',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),

                            // Tree ID
                            Text(
                              'Tree id: T1239',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),

                            // Location
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Thane',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Buttons
                  SizedBox(height: 16),
                  Row(
                    children: [
                      // Direction Button
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF1A5F3E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.navigation,
                              size: 16,
                              color: Color(0xFF1A5F3E),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Direction',
                              style: TextStyle(
                                color: Color(0xFF1A5F3E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Maintenance Button
                      ElevatedButton(
                        onPressed: () {
                          // AppRoute.goToNextPage(context: context, screen: screen, arguments: )
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF1A5F3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Maintenance',
                          style: TextStyle(
                            color: Color(0xFF1A5F3E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

 */

class TreeMaintenanceListScreen extends StatelessWidget {
  static const route = "/tree-maintenance-list";

  const TreeMaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white, // Soft gray or light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5F3E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Maintenance (5)',
          style: AppFonts.body.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Tree Image and Basic Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tree Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          Images.sampleImg,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Tree Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Neem',
                              style: AppFonts.body.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tree ID: T1239',
                              style: AppFonts.regular.copyWith(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Thane',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Action Buttons
                  Row(
                    children: [
                      // Direction Button
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.navigation, size: 16),
                        label: const Text('Direction'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A5F3E),
                          side: const BorderSide(color: Color(0xFF1A5F3E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Maintenance Button
                      ElevatedButton(
                        onPressed: () {
                          // AppRoute.goToNextPage(context: context, ...)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB2DFDB),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Maintenance',
                          style: AppFonts.body.copyWith(
                            color: const Color(0xFF004D40),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
