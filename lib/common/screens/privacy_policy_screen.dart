// Privacy Policy Screen
import 'package:flutter/material.dart';

import '../../core/config/themes/app_color.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  static const route = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: AppColor.textPrimary),
        ),
        backgroundColor: AppColor.background,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.privacy_tip_outlined,
                    size: 50,
                    color: AppColor.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Your Privacy Matters",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Last updated: ${_getCurrentDate()}",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            _buildIntroText(
              "TreeLov is a tree-plantation and monitoring app. We respect your privacy and keep your data safe. This Privacy Policy explains what we collect, why we collect it, and how we use it.",
            ),
            const SizedBox(height: 24),

            // Section 1: Location
            _buildSection(
              icon: Icons.location_on_outlined,
              title: "Location",
              content: [
                "We only use your location to:",
                "• Mark the exact place where a tree is planted",
                "• Show your tree on the map",
                "• Help field workers confirm plantation or maintenance tasks",
                "",
                "✓ We do NOT track your location in the background.",
                "✓ We do NOT share your location with anyone.",
              ],
              accentColor: AppColor.secondary,
            ),

            // Section 2: Camera/Photos
            _buildSection(
              icon: Icons.camera_alt_outlined,
              title: "Camera / Photos",
              content: [
                "We use the camera only when you:",
                "• Take a photo of a planted tree",
                "• Upload images for monitoring or grievance",
                "",
                "✓ We never access your gallery without asking.",
                "✓ We do NOT use your photos for anything else.",
              ],
              accentColor: AppColor.accent,
            ),

            // Section 3: Notifications
            _buildSection(
              icon: Icons.notifications_outlined,
              title: "Notifications",
              content: [
                "We send notifications for:",
                "• Task updates",
                "• Plantation,maintenance and monitoring reminders",
                "• Status changes",
                "",
                "You can turn notifications off anytime.",
              ],
              accentColor: AppColor.skyBlue,
            ),

            // Section 4: Account Information
            _buildSection(
              icon: Icons.person_outline,
              title: "Account Information",
              content: [
                "We store basic details you provide during login, such as:",
                "• Name",
                "• Phone number",
                "• Email (if used)",
                "",
                "This is only used to manage your profile and tasks.",
              ],
              accentColor: AppColor.primary,
            ),

            // Section 5: Device Information
            _buildSection(
              icon: Icons.phone_android_outlined,
              title: "Device Information",
              content: [
                "We store your device token to send notifications.",
                "This is safe and NOT shared with any third-party.",
              ],
              accentColor: AppColor.secondaryDark,
            ),

            // How we use data
            _buildHighlightBox(
              title: "How we use your data",
              content: [
                "We use your data only for:",
                "• Managing plantations,maintenance and monitoring",
                "• Assigning tasks to field workers",
                "• Improving the app experience",
                "• Providing support if needed",
                "",
                "We NEVER sell, rent, or share your data with third parties.",
              ],
              color: AppColor.success,
            ),

            // Data Security
            _buildHighlightBox(
              title: "Data Security",
              content: [
                "We use secure methods to protect your data.",
                "Only authorized members of the TreeLov team can access necessary information for operations.",
              ],
              color: AppColor.primary,
            ),
            /*
            // Your Rights
            _buildSection(
              icon: Icons.verified_user_outlined,
              title: "Your Rights",
              content: [
                "You can:",
                "• Request your data",
                "• Update your information",
                "• Ask us to delete your account",
                "",
                "Write to us at: support@treelove.com",
              ],
              accentColor: AppColor.accent,
            ),

             */

            // Changes
            _buildSection(
              icon: Icons.update_outlined,
              title: "Changes to this Policy",
              content: [
                "If we update this policy, we will notify you inside the app.",
              ],
              accentColor: AppColor.textMuted,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroText(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border, width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: AppColor.textSecondary,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<String> content,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...content.map((line) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 14,
                color: line.startsWith("✓")
                    ? AppColor.success
                    : AppColor.textSecondary,
                height: 1.5,
                fontWeight: line.startsWith("✓")
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildHighlightBox({
    required String title,
    required List<String> content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_outlined, color: color, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content.map((line) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              line,
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textPrimary,
                height: 1.5,
              ),
            ),
          )),
        ],
      ),
    );
  }

  static String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }
}