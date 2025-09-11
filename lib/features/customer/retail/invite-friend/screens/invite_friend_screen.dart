import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
/*
class InviteAndEarnScreen extends StatefulWidget {
  static const route='/invite-friend';
  const InviteAndEarnScreen({super.key});

  @override
  State<InviteAndEarnScreen> createState() => _InviteAndEarnScreenState();
}

class _InviteAndEarnScreenState extends State<InviteAndEarnScreen> {
  String referralLink = "Chris/connect/register";
  double totalEarnings = 2.0;

  bool showReferrals = false;

  final List<Map<String, dynamic>> referrals = [
    {"name": "Givanni", "amount": 1, "status": "Completed"},
    {"name": "Toba", "amount": 1, "status": "Completed"},
    {"name": "Elizabeth", "amount": 0, "status": "Pending"},
    {"name": "Teeh", "amount": 0, "status": "Pending"},
  ];

  void _copyReferralLink() {
    Clipboard.setData(ClipboardData(text: referralLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Referral link copied!")),
    );
  }

  void _shareReferralLink() {
    Share.share(
      "🌱 Join me and earn rewards! Register here: $referralLink",
      subject: "Invite & Earn",
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite & Earn"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Gift Icon
            Center(
              child: Image.asset(
                "assets/gift.png", // put a gift image in assets
                height: 120,
              ),
            ),
            const SizedBox(height: 16),

            // Title + Reward Info
            const Text(
              "Refer 10 FRIENDS and earn coin",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              "\$10",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Referral link + copy
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      referralLink,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyReferralLink,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Share Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _shareReferralLink,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Share & Earn Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Total Earnings + Referrals dropdown
            InkWell(
              onTap: () {
                setState(() {
                  showReferrals = !showReferrals;
                });
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Earnings: \$${totalEarnings.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        const Text("Referrals",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        Icon(showReferrals
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Referrals List
            if (showReferrals)
              Expanded(
                child: ListView.builder(
                  itemCount: referrals.length,
                  itemBuilder: (context, index) {
                    final item = referrals[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      title: Text(item["name"]),
                      subtitle: Text("\$${item["amount"]}"),
                      trailing: Text(
                        item["status"],
                        style: TextStyle(
                          color: _getStatusColor(item["status"]),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

 */

import 'package:flutter_animate/flutter_animate.dart';

/*
class InviteAndEarnScreen extends StatefulWidget {
  static const route = '/invite-friend';
  const InviteAndEarnScreen({super.key});

  @override
  State<InviteAndEarnScreen> createState() => _InviteAndEarnScreenState();
}

class _InviteAndEarnScreenState extends State<InviteAndEarnScreen> {
  String referralLink = "Chris/connect/register";
  double totalEarnings = 2.0;
  bool showReferrals = false;

  // Color Palette
  static const Color primary = Color(0xFF00473C);
  static const Color primaryDark = Color(0xFF002D26);
  static const Color primaryLight = Color(0xFF1C665A);
  static const Color background = Color(0xFFF8F4E3);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color accent = Color(0xFFEAB308); // Golden accent
  static const Color success = Color(0xFF059669);
  static const Color pending = Color(0xFFD97706);

  final List<Map<String, dynamic>> referrals = [
    {"name": "Givanni", "amount": 1, "status": "Completed"},
    {"name": "Toba", "amount": 1, "status": "Completed"},
    {"name": "Elizabeth", "amount": 0, "status": "Pending"},
    {"name": "Teeh", "amount": 0, "status": "Pending"},
  ];

  void _copyReferralLink() {
    Clipboard.setData(ClipboardData(text: referralLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Referral link copied!"),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _shareReferralLink() {
    Share.share(
      "🌟 Join me and earn rewards! Register here: $referralLink",
      subject: "Invite & Earn",
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return success;
      case "Pending":
        return pending;
      default:
        return textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                // Header Section
                _buildHeader(),
                const SizedBox(height: 40),

                // Main Reward Card
                _buildRewardCard(),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 32),

                // Earnings Summary
                _buildEarningsSummary(),
                const SizedBox(height: 20),

                // Referrals List
                if (showReferrals) _buildReferralsList(),
              ],
            ),
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
              color: cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: primary,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "Invite & Earn",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: primary,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 44), // Balance the back button
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildRewardCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gift Icon
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: cardBackground.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 40,
              color: cardBackground.withOpacity(0.9),
            ),
          ).animate().scale(duration: 800.ms, curve: Curves.easeOut),

          const SizedBox(height: 24),

          // Reward Text
          Text(
            "Invite 10 Friends",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: cardBackground.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),

          // Reward Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
              Text(
                "10",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: cardBackground,
                  height: 1.0,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            "Earn rewards for each successful referral",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: cardBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Referral Link Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your referral link",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      referralLink,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _copyReferralLink,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        color: primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 1000.ms).slideX(begin: -0.2),

        const SizedBox(height: 20),

        // Share Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _shareReferralLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: accent.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Share & Earn Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 1200.ms).scale(),
      ],
    );
  }

  Widget _buildEarningsSummary() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showReferrals = !showReferrals;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: success,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Earnings",
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${totalEarnings.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${referrals.length} Referrals",
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  showReferrals
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: textSecondary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1400.ms).slideX(begin: 0.2);
  }

  Widget _buildReferralsList() {
    return Column(
      children: referrals.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primary.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item["name"][0].toUpperCase(),
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name and Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Earned: \$${item["amount"]}",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(item["status"]).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item["status"],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(item["status"]),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(
          duration: (1600 + (index * 200)).ms,
        ).slideY(begin: 0.1);
      }).toList(),
    );
  }
}

 */
class InviteAndEarnScreen extends StatefulWidget {
  static const route = '/invite-friend';
  const InviteAndEarnScreen({super.key});

  @override
  State<InviteAndEarnScreen> createState() => _InviteAndEarnScreenState();
}

class _InviteAndEarnScreenState extends State<InviteAndEarnScreen> {
  String referralLink = "Chris/connect/register";
  int totalPoints = 200;
  bool showReferrals = false;

  // Color Palette
  static const Color primary = Color(0xFF00473C);
  static const Color primaryDark = Color(0xFF002D26);
  static const Color primaryLight = Color(0xFF1C665A);
  static const Color background = Color(0xFFF8F4E3);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color accent = Color(0xFFEAB308); // Golden accent
  static const Color success = Color(0xFF059669);
  static const Color pending = Color(0xFFD97706);

  final List<Map<String, dynamic>> referrals = [
    {"name": "Givanni", "points": 100, "status": "Completed"},
    {"name": "Toba", "points": 100, "status": "Completed"},
    {"name": "Elizabeth", "points": 0, "status": "Pending"},
    {"name": "Teeh", "points": 0, "status": "Pending"},
  ];

  void _copyReferralLink() {
    Clipboard.setData(ClipboardData(text: referralLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Referral link copied!"),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _shareReferralLink() {
    Share.share(
      "🌟 Join me and earn rewards! Register here: $referralLink",
      subject: "Invite & Earn",
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return success;
      case "Pending":
        return pending;
      default:
        return textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                // Header Section
                _buildHeader(),
                const SizedBox(height: 40),

                // Main Reward Card
                _buildRewardCard(),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 32),

                // Earnings Summary
                _buildEarningsSummary(),
                const SizedBox(height: 20),

                // Referrals List
                if (showReferrals) _buildReferralsList(),
              ],
            ),
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
              color: cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: primary,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "Invite & Earn",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: primary,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 44), // Balance the back button
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildRewardCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gift Icon
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: cardBackground.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 40,
              color: cardBackground.withOpacity(0.9),
            ),
          ).animate().scale(duration: 800.ms, curve: Curves.easeOut),

          const SizedBox(height: 24),

          // Reward Text
          Text(
            "Invite 10 Friends",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: cardBackground.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),

          // Reward Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "1,000",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: cardBackground,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "pts",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            "Earn points for each successful referral",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: cardBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Referral Link Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your referral link",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      referralLink,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _copyReferralLink,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        color: primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 1000.ms).slideX(begin: -0.2),

        const SizedBox(height: 20),

        // Share Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _shareReferralLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: accent.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Share & Earn Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 1200.ms).scale(),
      ],
    );
  }

  Widget _buildEarningsSummary() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showReferrals = !showReferrals;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: success,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Points",
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${totalPoints}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          "pts",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${referrals.length} Referrals",
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  showReferrals
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: textSecondary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1400.ms).slideX(begin: 0.2);
  }

  Widget _buildReferralsList() {
    return Column(
      children: referrals.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primary.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item["name"][0].toUpperCase(),
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name and Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Earned: ${item["points"]} pts",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(item["status"]).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item["status"],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(item["status"]),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(
          duration: (1600 + (index * 200)).ms,
        ).slideY(begin: 0.1);
      }).toList(),
    );
  }
}