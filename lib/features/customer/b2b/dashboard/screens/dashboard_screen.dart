import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/config/resource/images.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class OrgDashboardScreen extends StatelessWidget {
  const OrgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SafeArea(
              child: Row(
                spacing: 20.w,
                children: [
                   CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: SvgPicture.asset(Images.accountFilledIcon)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Hi Ramesh',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          )),
                      Text('Your Jio dashboard',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: 'This year',
                      items: [
                        DropdownMenuItem(
                          value: 'This year',
                          child: Text('This year'),
                        )
                      ],
                      onChanged: (val) {},
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Every tree planted matters',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE0F2F1),
                  ),
                ),
                Column(
                  children: const [
                    Text('3900',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        )),
                    Text('Carbon offset (kg)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        )),
                  ],
                )
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Activity overview',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('+10% vs Last year',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 20),
            _buildActivityRow(
              icon: Images.babyPlantIcon,
              label: 'Plantation',
              value: '85,000',
              progress: 1.0,
              color: Colors.teal,
            ),
            const SizedBox(height: 16),
            _buildActivityRow(
              icon: Images.maintenanceIcon,
              label: 'Maintenance',
              value: '85,000',
              progress: 1.0,
              color: Colors.teal,
            ),
            const SizedBox(height: 16),
            _buildActivityRow(
              icon: Images.monitorIcon,
              label: 'Monitoring',
              value: '45,000',
              progress: 0.65,
              color: Colors.indigo,
            ),
            const SizedBox(height: 16,),

          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow({
    required String icon,
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        spacing: 20.w,
        children: [
          SvgPicture.asset(icon, height: 30, width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                // ✨ Animated Progress Bar
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  tween: Tween(begin: 0, end: progress),
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    color: color,
                    backgroundColor: Colors.grey.shade200,
                    borderRadius:  BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

