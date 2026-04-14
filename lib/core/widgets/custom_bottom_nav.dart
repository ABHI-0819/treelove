import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';

import '../config/resource/images.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
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
      unselectedLabelStyle:  AppFonts.caption.copyWith(fontWeight: FontWeight.w600),
      items: [
        buildNavItem(index: 0, filledIcon: Images.homeFilledIcon, outlinedIcon: Images.homeIcon, label: 'Home'),
        buildNavItem(index: 1, filledIcon: Images.projectFilledIcon, outlinedIcon: Images.projectIcon, label: 'Projects'),
        buildNavItem(index: 2, filledIcon: Images.inquiryFilledIcon, outlinedIcon: Images.inquiryIcon, label: 'Enquiry'),
        buildNavItem(index: 3, filledIcon: Images.moreFilledIcon, outlinedIcon: Images.moreIcon, label: 'More'),
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
