

// Terms & Conditions Screen
import 'package:flutter/material.dart';

import '../../core/config/themes/app_color.dart';

class TermsConditionsScreen extends StatelessWidget {
  static const route = '/terms-conditions';

  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text(
          "Terms & Conditions",
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
                  colors: [AppColor.secondary, AppColor.secondaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.secondary.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 50,
                    color: AppColor.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Terms & Conditions",
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
              "Please read these Terms before using TreeLov. By using TreeLov, you agree to follow these rules.",
            ),
            const SizedBox(height: 24),

            // Section 1: Use of App
            _buildTermSection(
              number: "1",
              title: "Use of the App",
              icon: Icons.eco_outlined,
              content: [
                "TreeLov helps you:",
                "• Plant trees",
                "• Tag tree locations",
                "• Perform maintenance tasks",
                "• Report grievances",
                "• Track plantation progress",
                "",
                "Use the app only for legal and responsible purposes.",
              ],
              color: AppColor.primary,
            ),

            // Section 2: Responsibilities
            _buildTermSection(
              number: "2",
              title: "Your Responsibilities",
              icon: Icons.task_alt_outlined,
              content: [
                "You agree to:",
                "• Provide accurate information",
                "• Upload real and correct photos",
                "• Mark correct tree locations",
                "• Not misuse or damage the app",
                "",
                "⚠️ Misuse may lead to account suspension.",
              ],
              color: AppColor.warning,
            ),

            // Section 3: Permissions
            _buildTermSection(
              number: "3",
              title: "Permissions",
              icon: Icons.lock_open_outlined,
              content: [
                "To work properly, the app needs:",
                "• Location permission (to mark tree location)",
                "• Camera permission (to capture tree photos)",
                "• Notification permission (for updates & tasks)",
                "",
                "We only use these permissions for app features.",
              ],
              color: AppColor.secondary,
            ),

            // Section 4: Account
            _buildTermSection(
              number: "4",
              title: "Account & Authentication",
              icon: Icons.account_circle_outlined,
              content: [
                "You are responsible for:",
                "• Keeping your login details safe",
                "• Not sharing your OTP or credentials with anyone",
              ],
              color: AppColor.accent,
            ),

            // Section 5: Liability
            _buildTermSection(
              number: "5",
              title: "Limitation of Liability",
              icon: Icons.info_outline,
              content: [
                "TreeLov is a tool to assist plantation and monitoring.",
                "We are not responsible for:",
                "• Wrong data entered by users",
                "• Missed tasks",
                "• Device or network failures",
              ],
              color: AppColor.textMuted,
            ),

            // Section 6: Termination
            _buildTermSection(
              number: "6",
              title: "Termination",
              icon: Icons.block_outlined,
              content: [
                "We may suspend or disable accounts if:",
                "• Fake data is submitted",
                "• Photos or locations are manipulated",
                "• Misuse or violation of rules occurs",
              ],
              color: AppColor.error,
            ),

            // Section 7: Updates
            _buildTermSection(
              number: "7",
              title: "Updates",
              icon: Icons.system_update_outlined,
              content: [
                "We may update features or Terms anytime.",
                "We will notify you in the app if major changes happen.",
              ],
              color: AppColor.skyBlue,
            ),

            // Section 8: Contact
            _buildTermSection(
              number: "8",
              title: "Contact",
              icon: Icons.contact_support_outlined,
              content: [
                "For any questions, support, or issues:",
                "📧 support@treelov.com",
              ],
              color: AppColor.success,
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "By using TreeLov, you accept these terms",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

  Widget _buildTermSection({
    required String number,
    required String title,
    required IconData icon,
    required List<String> content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: TextStyle(
                    fontSize: 14,
                    color: line.startsWith("⚠️")
                        ? AppColor.error
                        : AppColor.textSecondary,
                    height: 1.5,
                    fontWeight: line.startsWith("⚠️")
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              )).toList(),
            ),
          ),
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