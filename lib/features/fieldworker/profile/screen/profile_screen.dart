import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/login_repository.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/bloc/auth_bloc.dart';
import '../../../authentication/screens/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldBackground,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
        //   onPressed: () => Navigator.pop(context),
        // ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => logoutBloc,
          ),

        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Image Section
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColor.grey,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColor.textMuted,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.scaffoldBackground,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Name
                const Text(
                  'Jack William',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),
                /*
              // Email
              Text(
                'jackwilliam1704@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textMuted,
                ),
              ),

               */

                const SizedBox(height: 32),

                // Personal Information Section
                _buildSectionTitle('Personal Information'),

                const SizedBox(height: 12),
                /*
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),

               */

                _buildMenuItem(
                  icon: Icons.phone_outlined,
                  title: 'Mobile Number',
                  subtitle: '+91 98765 43210',
                  onTap: () {},
                ),

                _buildMenuItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'jackwilliam1704@gmail.com',
                  onTap: () {},
                ),

                const SizedBox(height: 24),

                // Account Settings Section
                _buildSectionTitle('Account Settings'),

                const SizedBox(height: 12),
                /*
              _buildMenuItem(
                icon: Icons.language_outlined,
                title: 'Language',
                onTap: () {},
              ),

               */

                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {},
                ),

                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                /*
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),

               */

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: BlocListener<LogoutBloc, ApiState<ResponseModel, ResponseModel>>(
                    listener: (context, state) {
                      EasyLoading.dismiss();
                      if (state is ApiSuccess<ResponseModel, ResponseModel>) {
                        AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
                      } else if (state is ApiFailure) {
                        showNotification(context, message: "Logout failed");
                      }
                    },
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.error,
                            width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.error,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Version
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.textMuted,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.divider,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColor.textPrimary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColor.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.textMuted,
            ),
          ),
        )
            : null,
        // trailing: Icon(
        //   Icons.chevron_right,
        //   color: AppColor.textMuted,
        //   size: 20,
        // ),
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
}