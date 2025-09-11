import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/customer/retail/FAQ/faq_screen.dart';
import 'package:treelove/features/customer/retail/cart/cart_screen.dart';
import 'package:treelove/features/customer/retail/invite-friend/screens/invite_friend_screen.dart';
import 'package:treelove/features/customer/retail/my-trees/screens/my_trees_screen.dart';
import 'package:treelove/features/customer/retail/order/order_list_screen.dart';

import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/themes/app_color.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200], // light grey background
                child: Image.network(
                  '',
                  height: 30,
                  width: 30,
                  color: Colors.grey[800], // optional: darker icon for contrast
                ),
              ),

              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Saurabh',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey),
                        SizedBox(width: 6.0),
                        Text(
                          '+911234567967',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.grey),
                        SizedBox(width: 6.0),
                        Text(
                          'xyzl2s@gmail.com',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.verified_rounded,
                color: AppColor.primary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFFFFFF8),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [

            // 🔰 Header
            _buildHeader(),
            // 👤 My Account Section
            _buildSectionHeader('My Account'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 15.w,
                  runSpacing:15.h,
                  children: [
                    _buildButton(icon: Images.babyPlantIcon, label: 'My Plantation', onTap: () {
                      AppRoute.goToNextPage(context: context, screen: MyTreeScreen.route, arguments: {});
                    }),
                    _buildButton(icon: Images.inviteIcon, label: 'Invite a Friend', onTap: () {
                        AppRoute.goToNextPage(context: context, screen: InviteAndEarnScreen.route, arguments: {});
                    }),
                    _buildButton(icon: Images.supportIcon, label: 'Support', onTap: () {}),
                    _buildButton(icon: Images.settingIcon, label: 'Settings', onTap: () {}),
                    _buildButton(icon: Images.orderIcon, label: 'My Order', onTap: () {
                      AppRoute.goToNextPage(context: context, screen: OrderListScreen.route, arguments: {});
                    }),
                  ],
                ),
              ),
            ),

            // const SizedBox(height: 24.0),
            const Divider(thickness: 1.2, indent: 16.0, endIndent: 16.0),

            // 📃 About Section
            _buildAboutSection(context),

            const Divider(thickness: 1.2, indent: 16.0, endIndent: 16.0),

            // ⚙️ Other Options
            _buildOtherOptionsSection(),

            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildLinkRow('Terms of Service', () {}),
                _buildDivider(),
                _buildLinkRow('Privacy Policy', () {}),
                _buildDivider(),
                _buildLinkRow('FAQs', () {
                  AppRoute.goToNextPage(context: context, screen: FaqScreen.route, arguments: {});
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.6,
      color: Colors.grey.shade300,
      indent: 16.0,
      endIndent: 16.0,
    );
  }

  Widget _buildOtherOptionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Other Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildOptionRow('Log Out', () {}),
                _buildDivider(),
                _buildOptionRow('Version 1.x', () {}, showArrow: false),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildButton({required String icon, String? label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 0.4.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, color: AppColor.primary, height: 35, width: 35),
            const SizedBox(height: 8.0),
            Text(
              label ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Option Row (Logout, Version, etc.)
  Widget _buildOptionRow(String text, VoidCallback onTap, {bool showArrow = true}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

}


