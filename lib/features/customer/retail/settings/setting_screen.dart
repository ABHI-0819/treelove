import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';

import '../../../../core/config/themes/app_color.dart';

class SettingsScreen extends StatefulWidget {
  static const route ='/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (ctx) => AlertDialog(
        title: Text(
          'Are you sure?',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Deleting your account will permanently remove all your data. This action cannot be undone.',
          style: TextStyle(color: AppColor.textSecondary),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppColor.cardBackground,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColor.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              AppRoute.pushAndRemoveUntil(context, SignInScreen.route, arguments: {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deleted successfully.'),
                  backgroundColor: AppColor.error,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColor.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              _buildHeader(),
              // Notification Toggle Card
              Container(
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.border.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notification',
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeTrackColor: AppColor.secondary.withOpacity(0.5),
                      activeColor: AppColor.primary,
                      inactiveThumbColor: AppColor.white,
                      inactiveTrackColor: AppColor.grey,
                    ),
                  ],
                ),
              ),
              // Delete Account Card
              InkWell(
                onTap: () => _showDeleteConfirmationDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.border.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: AppColor.error,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColor.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.primary,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "Setting",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 44),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }
}