/*
import 'package:flutter/material.dart';

import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../../core/widgets/faq.dart';

class FaqScreen extends StatelessWidget {
  static const route = "/faq-section";
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          EasyFaq(
            question: 'How do I get started with Dart?',
            answer: 'Dart is the programming language optimized for UI. You can start learning Dart through its official documentation and interactive tours on dart.dev.',
            collapsedIcon: Icons.keyboard_arrow_down,
            expandedIcon: Icons.keyboard_arrow_down,
            iconColor: Colors.green.shade700,
            animationCurve: Curves.fastOutSlowIn,
          ),
        ],
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';

import '../../../../core/config/themes/app_color.dart';

class FaqScreen extends StatelessWidget {
  static const route = "/faq-section";
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text(
          'FAQ',
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
                    Icons.help_outline_rounded,
                    size: 50,
                    color: AppColor.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Frequently Asked Questions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Find answers to common questions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQ Items
            _FaqItem(
              number: "1",
              question: "What does this app do?",
              answer:
              "This app helps you plant, track, and monitor trees. You can add tree details, see them on the map, upload photos, and check updates about your plantations.",
              icon: Icons.eco_outlined,
              color: AppColor.primary,
            ),

            _FaqItem(
              number: "2",
              question: "Do I need to turn on my location?",
              answer:
              "Yes, only when you are adding a tree. We use your location to mark the exact spot of the tree on the map. We don't track your movement and don't use location in the background.",
              icon: Icons.location_on_outlined,
              color: AppColor.secondary,
            ),

            _FaqItem(
              number: "3",
              question: "Do you share my location or data with anyone?",
              answer:
              "No. We do not share your data or location with any third party.",
              icon: Icons.shield_outlined,
              color: AppColor.success,
            ),

            _FaqItem(
              number: "4",
              question: "Why does the app ask for camera permission?",
              answer:
              "The camera is used only to take tree photos for documentation and monitoring.",
              icon: Icons.camera_alt_outlined,
              color: AppColor.accent,
            ),

            _FaqItem(
              number: "5",
              question: "How is my data stored?",
              answer:
              "Your data is stored securely on our servers. Only authorized users (like admins or field workers) can view necessary information for plantation and monitoring tasks.",
              icon: Icons.storage_outlined,
              color: AppColor.skyBlue,
            ),

            _FaqItem(
              number: "6",
              question: "Can I update or delete a tree entry?",
              answer:
              "Yes. If you are a field worker or have permission, you can update or delete the tree record.",
              icon: Icons.edit_outlined,
              color: AppColor.secondaryDark,
            ),

            _FaqItem(
              number: "7",
              question: "What should I do if something is not working?",
              answer:
              "You can contact our support team from the app, or restart the app and try again.",
              icon: Icons.build_outlined,
              color: AppColor.warning,
            ),

            _FaqItem(
              number: "8",
              question: "Why do I receive notifications?",
              answer:
              "Notifications are sent only to update you about:\n• Tree status\n• Approvals\n• Tasks assigned\n• Important updates\n\nYou can disable notifications anytime from your phone settings.",
              icon: Icons.notifications_outlined,
              color: AppColor.primary,
            ),

            _FaqItem(
              number: "9",
              question: "Is the app free to use?",
              answer: "Yes, the app is completely free.",
              icon: Icons.attach_money_outlined,
              color: AppColor.success,
            ),

            _FaqItem(
              number: "10",
              question: "Can I use the app without an account?",
              answer:
              "No, you must log in so we can save your tree data safely and link it to your profile.",
              icon: Icons.account_circle_outlined,
              color: AppColor.secondary,
            ),

            const SizedBox(height: 24),
            /*
            // Contact Support Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.primary.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.contact_support_outlined,
                      size: 32,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Still have questions?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Feel free to reach out to our support team",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add your support contact logic here
                      // Example: launch email or open support chat
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text("Contact Support"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

             */
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String number;
  final String question;
  final String answer;
  final IconData icon;
  final Color color;

  const _FaqItem({
    required this.number,
    required this.question,
    required this.answer,
    required this.icon,
    required this.color,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isExpanded
              ? widget.color.withOpacity(0.3)
              : AppColor.border,
          width: _isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isExpanded
                ? widget.color.withOpacity(0.1)
                : Colors.black.withOpacity(0.04),
            blurRadius: _isExpanded ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Number Badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.number,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Question
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _isExpanded
                            ? widget.color
                            : AppColor.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Animated Icon
                  RotationTransition(
                    turns: _iconRotation,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.color,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Animated Answer
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 18,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.answer,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}