import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:treelove/features/customer/b2b/dashboard/screens/dashboard_screen.dart';
import 'package:treelove/features/customer/b2b/projects/screens/projects_screen.dart';

import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../account/screens/account_screen.dart';
import '../../projects/screens/project_detail_screen.dart';

class OrganizationMainScreen extends StatefulWidget {
  static const route = "/organization-main-screen";

  const OrganizationMainScreen({super.key});

  @override
  State<OrganizationMainScreen> createState() => _OrganizationMainScreenState();
}

class _OrganizationMainScreenState extends State<OrganizationMainScreen> {
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
      ClientDashboardScreen(),
      B2BProjectScreen(),
      // AccountScreen()
      // index 2
    ];

    return Scaffold(
      body: buildPageView(bottomBarPages),
      bottomNavigationBar: CustomOrgBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


class CustomOrgBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomOrgBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: const Color(0xFFFEFCF3),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF004D40),
      unselectedItemColor: const Color(0xFFC4B28E),
      selectedLabelStyle: AppFonts.caption.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppFonts.caption.copyWith(fontWeight: FontWeight.w600),
      items: [
        buildNavItem(index: 0, filledIcon: Images.dashboardFilledIcon, outlinedIcon: Images.dashboardIcon, label: 'Dashboard'),
        buildNavItem(index: 1, filledIcon: Images.projectFilledIcon, outlinedIcon: Images.projectIcon, label: 'Projects'),
        buildNavItem(index: 2, filledIcon: Images.accountFilledIcon, outlinedIcon: Images.accountIcon, label: 'Account'),
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
