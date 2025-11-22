import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/customer/retail/FAQ/faq_screen.dart';
import 'package:treelove/features/customer/retail/cart/cart_screen.dart';
import 'package:treelove/features/customer/retail/invite-friend/screens/invite_friend_screen.dart';
import 'package:treelove/features/customer/retail/my-trees/screens/my_trees_screen.dart';
import 'package:treelove/features/customer/retail/order/order_list_screen.dart';
import 'package:treelove/features/customer/retail/profile/screen/profile_screen.dart';
import 'package:treelove/features/customer/retail/settings/setting_screen.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/login_repository.dart';
import '../../../../../common/screens/privacy_policy_screen.dart';
import '../../../../../common/screens/terms_conditions_screen.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/storage/preference_keys.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../../core/widgets/common_notification.dart';
import '../../../../authentication/bloc/auth_bloc.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../../grievance/screens/grievance_list_screen.dart';
import '../../grievance/screens/raise_grievance_screen.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late LogoutBloc logoutBloc;
  final pref = SecurePreference();

  @override
  void initState() {
    logoutBloc = LogoutBloc(LoginRepository(api: ApiConnection()));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    logoutBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

/*
  Widget _buildHeader()  {
    final email = await pref.getString(Keys.email);
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
                      'Ankit sharma',
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
                          'Not available',
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
                          ,
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

 */
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
                backgroundColor: Colors.grey[200],
                child: Image.network(
                  '',
                  height: 30,
                  width: 30,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String?>(
                        future: pref.getString(Keys.name,defaultValue: 'Ankit Sharma'),
                        builder: (context, snapshot) {
                          final name = snapshot.data??'Ankit Sharma';
                          return Text(
                            name ,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                    const SizedBox(height: 4.0),
                    FutureBuilder<String?>(
                        future: pref.getString(Keys.phone),
                        builder: (context, snapshot) {
                          final phone = snapshot.data ?? 'Not available';
                          return Row(
                            children:  [
                              Icon(Icons.phone, size: 16, color: Colors.grey),
                              SizedBox(width: 6.0),
                              Text(
                                phone,
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          );
                        }),

                    const SizedBox(height: 4.0),
                    FutureBuilder<String?>(
                        future: pref.getString(Keys.email,defaultValue: 'Not available'),
                        builder: (context, snapshot) {
                          final email = snapshot.data ??'Not available';
                          return  Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.grey),
                              const SizedBox(width: 6.0),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }),

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

  Widget _buildHeaderCompact() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                AppRoute.goToNextPage(context: context, screen: RetailProfileScreen.route, arguments: {});
                 // Navigate to profile screen
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    // Compact Avatar
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primary,
                                AppColor.primaryLight,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColor.background,
                            child: Icon(
                              Icons.person_rounded,
                              size: 30,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColor.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.cardBackground,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String?>(
                            future: pref.getString(Keys.name, defaultValue: 'User'),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? 'User',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          FutureBuilder<String?>(
                            future: pref.getString(Keys.email),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? 'Not available',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColor.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColor.textMuted,
                    ),
                  ],
                ),
              ),
            ),
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
            _buildHeaderCompact(),
            // _buildHeader(),
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
                    _buildButton(icon: Images.grievanceIcon, label: 'Grievance', onTap: () {
                      AppRoute.goToNextPage(context: context, screen: GrievanceListScreen.route, arguments: {});
                    }),
                    _buildButton(icon: Images.settingIcon, label: 'Settings', onTap: () {
                      AppRoute.goToNextPage(context: context, screen: SettingsScreen.route, arguments: {});
                    }),
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
                _buildLinkRow('Terms of Service', () {
                  AppRoute.goToNextPage(context: context, screen: TermsConditionsScreen.route, arguments: {});
                }),
                _buildDivider(),
                _buildLinkRow('Privacy Policy', () {
                  AppRoute.goToNextPage(context: context, screen: PrivacyPolicyScreen.route, arguments: {});
                }),
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
    return BlocProvider(
  create: (context) => logoutBloc,
  child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocListener<LogoutBloc, ApiState<ResponseModel, ResponseModel>>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is ApiSuccess) {
            AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
          } else if (state is ApiFailure) {
            showNotification(context, message: "Logout failed");
          }
        },
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
                _buildOptionRow('Log Out', () {
                  _showLogoutDialog(context);
                }),
                _buildDivider(),
                _buildOptionRow('Version 1.x', () {}, showArrow: false),
              ],
            ),
          ),
        ],
      ),
),
    ),
);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: AppColor.textSecondary,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColor.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () async{
                final refreshToken = await pref.getString(Keys.refreshToken) ?? '';
                if (refreshToken.isNotEmpty) {
                  EasyLoading.show();
                  logoutBloc.add(ApiDelete(refreshToken));
                } else {
                  showNotification(context, message: "No refresh token found!");
                }
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: AppColor.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
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


