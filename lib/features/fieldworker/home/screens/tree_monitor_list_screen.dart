import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';

class TreeMonitorListScreen extends StatefulWidget {
  static const route ='/TreeMonitorListScreen';
  const TreeMonitorListScreen({super.key});

  @override
  State<TreeMonitorListScreen> createState() => _TreeMonitorListScreenState();
}

class _TreeMonitorListScreenState extends State<TreeMonitorListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor ${5}',style: AppFonts.regular,),
        backgroundColor: Color(0xFF1A5F3E), // Dark green color
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,color: AppColor.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
        itemCount: 4, // Number of cards
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 16),
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
                            minimumSize: Size(150, 40)
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF1A5F3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(150, 40)
                        ),
                        child: Text(
                          'Monitor',
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
