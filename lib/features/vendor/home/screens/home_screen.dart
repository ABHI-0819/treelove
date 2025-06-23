import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';

class HomeScreen extends StatefulWidget {
  // static const route = '/vendor-home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      // bottomNavigationBar: const _BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderSection(),
            const _StatsSection(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Ongoing projects (2)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _ProjectCard(),
            const _ProjectCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B5E42), Color(0xFF196D54)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding:  EdgeInsets.all(16.r),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello Yash 🙂',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.notifications,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF196D54),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _StatBox(title: 'Ongoing Projects', value: '02'),
          _StatBox(title: 'Upcoming Projects', value: '01'),
        ],
      ),
    );
  }
}



class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 2,
          height: 65.h,// Thickness of the line
          color: Color(0xFF00FF00), // Color of the line
        ),
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 15),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.05),
            //     blurRadius: 6,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
            // border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5.h,
            children: [
              Text(
                value,
                style: AppFonts.regular.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
              ),
              Text(
                title,
                style:AppFonts.caption.copyWith(
                  color: AppColor.white
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _ProjectCard extends StatelessWidget {
  const _ProjectCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.h,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-vector/bird-colorful-logo-gradient-vector_343694-1365.jpg?semt=ais_hybrid&w=740',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Thane Plantation Drive 2023',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Jio Platforms', style: TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
            Container(
              height: 0.4, // Thickness of the line
              color: Colors.grey, // Color of the line
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Thane, Mumbai', style: TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Due: 31 Oct 2023', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
             Wrap(
              spacing: 20.w,
              runSpacing: 10.h,
              children: [
                _ProjectTag(text: 'Geo-tagging', color: Color(0xFFFCE8E8)),
                _ProjectTag(text: 'Maintenance', color: Color(0xFFE6F3FB)),
                _ProjectTag(text: 'Monitoring', color: Color(0xFFEAEAFD)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ProjectTag extends StatelessWidget {
  final String text;
  final Color color;

  const _ProjectTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.w,
        children: [
          Icon(
            _getIcon(text),
            size: 18,
            color: Colors.black54,
          ),
          Text(
            text,
            style: AppFonts.caption,
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String label) {
    switch (label.toLowerCase()) {
      case 'plantation':
        return Icons.local_florist;
      case 'geo-tagging':
        return Icons.place_outlined;
      case 'maintenance':
        return Icons.settings_suggest;
      case 'monitoring':
        return Icons.remove_red_eye_outlined;
      default:
        return Icons.label;
    }
  }
}
/*
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0B5E42),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.folder_open), label: 'Projects'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), label: 'Tree inventory'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}

 */
