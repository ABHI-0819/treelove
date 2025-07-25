import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:treelove/features/vendor/Staff/staff_list_screen.dart';

import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../profile/screens/profile_screen.dart';
import 'home_screen.dart';
import 'projects_screen.dart';


class VendorMainScreen extends StatefulWidget {
  static const route ="/vendor-home-screen";
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  final _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Widget buildPageView(List<Widget> bottomBarPages) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: bottomBarPages,
    );
  }


  @override
  Widget build(BuildContext context) {
    final bottomBarPages = [
      HomeScreen(),
      ProjectsScreen(),
      StaffListScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      body: buildPageView(bottomBarPages),
      bottomNavigationBar: CustomFBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


class CustomFBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomFBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: const Color(0xFFFEFCF3), // Very light cream background
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF004D40), // Dark green
      unselectedItemColor: const Color(0xFFC4B28E), // Muted gold
      selectedLabelStyle: AppFonts.caption.copyWith(fontWeight: FontWeight.w600),
      // const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle:  AppFonts.caption.copyWith(fontWeight: FontWeight.w600),
      // const TextStyle(fontWeight: FontWeight.w600),
      items: [
        buildNavItem(index: 0, filledIcon: Images.homeFilledIcon, outlinedIcon: Images.homeIcon, label: 'Home'),
        buildNavItem(index: 1, filledIcon: Images.projectFilledIcon, outlinedIcon: Images.projectIcon, label: 'Projects'),
        buildNavItem(index: 2, filledIcon: Images.usersFilledIcon, outlinedIcon: Images.usersIcon, label: 'Staff'),
        buildNavItem(index: 3, filledIcon: Images.accountFilledIcon, outlinedIcon: Images.accountIcon, label: 'Account'),
      ],
    );
  }

  BottomNavigationBarItem buildNavItem({
    required int index,
    required String filledIcon,
    required String outlinedIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        selectedIndex == index ? filledIcon : outlinedIcon,
        height: 22,
        width: 22,
      ),
      label: label,
    );
  }

}
/*

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF004A40),
                Color(0xFF00796B),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Hello Triple H 😊",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.notifications,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProjectCard("Ongoing Projects", "02", Colors.green.shade100),
                  SizedBox(width: 20),
                  _buildProjectCard("Upcoming Projects", "01", Colors.pink.shade100),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ongoing projects (2)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildProjectTile(
                logoUrl: "https://via.placeholder.com/50",
                projectName: "Thane Plantation Drive 2023",
                company: "Jio Platforms",
                location: "Thane, Mumbai",
                dueDate: "31 Oct 2023",
                tags: ["Plantation", "Geo-tagging", "Maintenance", "Monitoring"],
              ),
              SizedBox(height: 20),
              _buildProjectTile(
                logoUrl: "https://via.placeholder.com/50",
                projectName: "Thane Plantation Drive 2023",
                company: "Jio Platforms",
                location: "Thane, Mumbai",
                dueDate: "31 Oct 2023",
                tags: ["Plantation", "Geo-tagging", "Maintenance", "Monitoring"],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Tree inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String count, Color bgColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTile({
    required String logoUrl,
    required String projectName,
    required String company,
    required String location,
    required String dueDate,
    required List<String> tags,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(logoUrl),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    company,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 5),
              Text(
                location,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              SizedBox(width: 5),
              Text(
                "Due: $dueDate",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 5,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

 */