import 'package:flutter/material.dart';
import 'package:treelove/core/network/base_network.dart';

import '../config/themes/app_color.dart';

/*
class TreeDetailsBottomSheet extends StatelessWidget {
  final String treeName;
  final String scientificName;
  final String? imageUrl;
  final String health;
  final String growth;
  final String girth;
  final String direction;
  final DateTime? nextMaintenanceDate;
  final DateTime? nextMonitoringDate;
  final VoidCallback? onMaintenanceHistoryTap;
  final VoidCallback? onManualMonitorHistoryTap;
  final VoidCallback? onSatelliteMonitorHistoryTap;

  const TreeDetailsBottomSheet({
    Key? key,
    required this.treeName,
    required this.scientificName,
    this.imageUrl,
    required this.health,
    required this.growth,
    required this.girth,
    required this.direction,
    this.nextMaintenanceDate,
    this.nextMonitoringDate,
    this.onMaintenanceHistoryTap,
    this.onManualMonitorHistoryTap,
    this.onSatelliteMonitorHistoryTap,
  }) : super(key: key);

  static void show(
      BuildContext context, {
        required String treeName,
        required String scientificName,
        String? imageUrl,
        required String health,
        required String growth,
        required String girth,
        required String direction,
        DateTime? nextMaintenanceDate,
        DateTime? nextMonitoringDate,
        VoidCallback? onMaintenanceHistoryTap,
        VoidCallback? onManualMonitorHistoryTap,
        VoidCallback? onSatelliteMonitorHistoryTap,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TreeDetailsBottomSheet(
        treeName: treeName,
        scientificName: scientificName,
        imageUrl: imageUrl,
        health: health,
        growth: growth,
        girth: girth,
        direction: direction,
        nextMaintenanceDate: nextMaintenanceDate,
        nextMonitoringDate: nextMonitoringDate,
        onMaintenanceHistoryTap: onMaintenanceHistoryTap,
        onManualMonitorHistoryTap: onManualMonitorHistoryTap,
        onSatelliteMonitorHistoryTap: onSatelliteMonitorHistoryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 20),

                  // Image
                  _buildImage(),

                  const SizedBox(height: 24),

                  // Tree Details
                  _buildTreeDetails(),

                  const SizedBox(height: 24),

                  // Maintenance Section
                  _buildMaintenanceSection(context),

                  const SizedBox(height: 24),

                  // Monitoring Section
                  _buildMonitoringSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                treeName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                scientificName,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColor.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColor.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.navigation,
                size: 14,
                color: AppColor.primary,
              ),
              const SizedBox(width: 4),
              Text(
                direction,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
        )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.park_outlined,
            size: 48,
            color: AppColor.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No image',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.textMuted.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tree Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Health', health, Icons.favorite_outline),
        const SizedBox(height: 12),
        _buildDetailRow('Growth', growth, Icons.trending_up),
        const SizedBox(height: 12),
        _buildDetailRow('Girth', girth, Icons.straighten),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColor.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColor.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.accent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.accent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: AppColor.accent,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Maintenance',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextMaintenanceDate != null
                          ? _formatDate(nextMaintenanceDate!)
                          : 'Not scheduled',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Maintenance History',
          Icons.history,
          onMaintenanceHistoryTap,
        ),
      ],
    );
  }

  Widget _buildMonitoringSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monitoring',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.skyBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.skyBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: AppColor.skyBlue,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Monitoring',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextMonitoringDate != null
                          ? _formatDate(nextMonitoringDate!)
                          : 'Not scheduled',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Manual History',
                Icons.touch_app_outlined,
                onManualMonitorHistoryTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Satellite History',
                Icons.satellite_alt_outlined,
                onSatelliteMonitorHistoryTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label,
      IconData icon,
      VoidCallback? onTap,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColor.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

 */

// Example usage:
// TreeDetailsBottomSheet.show(
//   context,
//   treeName: 'Oak Tree',
//   scientificName: 'Quercus robur',
//   imageUrl: 'https://example.com/tree.jpg',
//   health: 'Excellent',
//   growth: 'Normal',
//   girth: '2.5m',
//   direction: 'North',
//   nextMaintenanceDate: DateTime(2025, 11, 15),
//   nextMonitoringDate: DateTime(2025, 10, 20),
//   onMaintenanceHistoryTap: () => print('Maintenance history'),
//   onManualMonitorHistoryTap: () => print('Manual monitor history'),
//   onSatelliteMonitorHistoryTap: () => print('Satellite monitor history'),
// );

import 'package:flutter/material.dart';

/*
class TreeDetailsBottomSheet extends StatelessWidget {
  final String treeName;
  final String scientificName;
  final String? imageUrl;
  final String health;
  final String growth;
  final String girth;
  final String direction;
  final DateTime? nextMaintenanceDate;
  final DateTime? nextMonitoringDate;
  final VoidCallback? onMaintenanceHistoryTap;
  final VoidCallback? onManualMonitorHistoryTap;
  final VoidCallback? onSatelliteMonitorHistoryTap;

  const TreeDetailsBottomSheet({
    Key? key,
    required this.treeName,
    required this.scientificName,
    this.imageUrl,
    required this.health,
    required this.growth,
    required this.girth,
    required this.direction,
    this.nextMaintenanceDate,
    this.nextMonitoringDate,
    this.onMaintenanceHistoryTap,
    this.onManualMonitorHistoryTap,
    this.onSatelliteMonitorHistoryTap,
  }) : super(key: key);

  static void show(
      BuildContext context, {
        required String treeName,
        required String scientificName,
        String? imageUrl,
        required String health,
        required String growth,
        required String girth,
        required String direction,
        DateTime? nextMaintenanceDate,
        DateTime? nextMonitoringDate,
        VoidCallback? onMaintenanceHistoryTap,
        VoidCallback? onManualMonitorHistoryTap,
        VoidCallback? onSatelliteMonitorHistoryTap,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TreeDetailsBottomSheet(
        treeName: treeName,
        scientificName: scientificName,
        imageUrl: imageUrl,
        health: health,
        growth: growth,
        girth: girth,
        direction: direction,
        nextMaintenanceDate: nextMaintenanceDate,
        nextMonitoringDate: nextMonitoringDate,
        onMaintenanceHistoryTap: onMaintenanceHistoryTap,
        onManualMonitorHistoryTap: onManualMonitorHistoryTap,
        onSatelliteMonitorHistoryTap: onSatelliteMonitorHistoryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 20),

                  // Image
                  _buildImage(),

                  const SizedBox(height: 24),

                  // Tree Details
                  _buildTreeDetails(),

                  const SizedBox(height: 24),

                  // Maintenance Section
                  _buildMaintenanceSection(context),

                  const SizedBox(height: 24),

                  // Monitoring Section
                  _buildMonitoringSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                treeName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                scientificName,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColor.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColor.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.navigation,
                size: 14,
                color: AppColor.primary,
              ),
              const SizedBox(width: 4),
              Text(
                direction,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
        )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.park_outlined,
            size: 48,
            color: AppColor.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No image',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.textMuted.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tree Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Health', health, Icons.favorite_outline),
        const SizedBox(height: 12),
        _buildDetailRow('Growth', growth, Icons.trending_up),
        const SizedBox(height: 12),
        _buildDetailRow('Girth', girth, Icons.straighten),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColor.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColor.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.accent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.accent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: AppColor.accent,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Maintenance',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextMaintenanceDate != null
                          ? _formatDate(nextMaintenanceDate!)
                          : 'Not scheduled',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Maintenance History',
          Icons.history,
          onMaintenanceHistoryTap,
        ),
      ],
    );
  }

  Widget _buildMonitoringSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monitoring',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.skyBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.skyBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: AppColor.skyBlue,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Monitoring',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextMonitoringDate != null
                          ? _formatDate(nextMonitoringDate!)
                          : 'Not scheduled',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Manual History',
                Icons.touch_app_outlined,
                onManualMonitorHistoryTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Satellite History',
                Icons.satellite_alt_outlined,
                onSatelliteMonitorHistoryTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label,
      IconData icon,
      VoidCallback? onTap,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColor.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

 */

// Example usage:
// TreeDetailsBottomSheet.show(
//   context,
//   treeName: 'Oak Tree',
//   scientificName: 'Quercus robur',
//   imageUrl: 'https://example.com/tree.jpg',
//   health: 'Excellent',
//   growth: 'Normal',
//   girth: '2.5m',
//   direction: 'North',
//   nextMaintenanceDate: DateTime(2025, 11, 15),
//   nextMonitoringDate: DateTime(2025, 10, 20),
//   onMaintenanceHistoryTap: () => print('Maintenance history'),
//   onManualMonitorHistoryTap: () => print('Manual monitor history'),
//   onSatelliteMonitorHistoryTap: () => print('Satellite monitor history'),
// );

class TreeDetailsBottomSheet extends StatelessWidget {
  final String treeName;
  final String scientificName;
  final String? imageUrl;
  final String health;
  final String growth;
  final String girth;
  final String direction;
  final String? nextMaintenanceDate; // CHANGED: was DateTime?
  final String? nextMonitoringDate;
  final VoidCallback? onDirectionTap;
  final VoidCallback? onMaintenanceHistoryTap;
  final VoidCallback? onManualMonitorHistoryTap;
  final VoidCallback? onSatelliteMonitorHistoryTap;

  const TreeDetailsBottomSheet({
    Key? key,
    required this.treeName,
    required this.scientificName,
    this.imageUrl,
    required this.health,
    required this.growth,
    required this.girth,
    required this.direction,
    this.nextMaintenanceDate,
    this.nextMonitoringDate,
    this.onDirectionTap,
    this.onMaintenanceHistoryTap,
    this.onManualMonitorHistoryTap,
    this.onSatelliteMonitorHistoryTap,
  }) : super(key: key);

  static void show(
      BuildContext context, {
        required String treeName,
        required String scientificName,
        String? imageUrl,
        required String health,
        required String growth,
        required String girth,
        required String direction,
        String? nextMaintenanceDate,     // CHANGED
        String? nextMonitoringDate,
        VoidCallback? onDirectionTap,
        VoidCallback? onMaintenanceHistoryTap,
        VoidCallback? onManualMonitorHistoryTap,
        VoidCallback? onSatelliteMonitorHistoryTap,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TreeDetailsBottomSheet(
        treeName: treeName,
        scientificName: scientificName,
        imageUrl: imageUrl,
        health: health,
        growth: growth,
        girth: girth,
        direction: direction,
        nextMaintenanceDate: nextMaintenanceDate,
        nextMonitoringDate: nextMonitoringDate,
        onDirectionTap: onDirectionTap,
        onMaintenanceHistoryTap: onMaintenanceHistoryTap,
        onManualMonitorHistoryTap: onManualMonitorHistoryTap,
        onSatelliteMonitorHistoryTap: onSatelliteMonitorHistoryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * (isLargeScreen ? 0.75 : 0.85),
      ),
      decoration: const BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16 : 20,
                16,
                isSmallScreen ? 16 : 20,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(isSmallScreen, isLargeScreen),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Image
                  _buildImage(screenHeight, isSmallScreen, isLargeScreen),

                  SizedBox(height: isSmallScreen ? 20 : 24),

                  // Tree Details
                  _buildTreeDetails(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 20 : 24),

                  // Maintenance Section
                  _buildMaintenanceSection(context, isSmallScreen),

                  SizedBox(height: isSmallScreen ? 20 : 24),

                  // Monitoring Section
                  _buildMonitoringSection(context, isSmallScreen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen, bool isLargeScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                treeName,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : (isLargeScreen ? 26 : 24),
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                  letterSpacing: -0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                scientificName,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 15,
                  color: AppColor.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onDirectionTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColor.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.navigation,
                  size: isSmallScreen ? 12 : 14,
                  color: AppColor.primary,
                ),
                SizedBox(width: isSmallScreen ? 2 : 4),
                Text(
                  direction,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  /*
  Widget _buildImage(double screenHeight, bool isSmallScreen, bool isLargeScreen) {
    final imageHeight = isLargeScreen
        ? screenHeight * 0.25
        : isSmallScreen
        ? screenHeight * 0.18
        : screenHeight * 0.2;

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(isSmallScreen),
        )
            : _buildImagePlaceholder(isSmallScreen),
      ),
    );
  }

   */
  Widget _buildImage(double screenHeight, bool isSmallScreen, bool isLargeScreen) {
    final imageHeight = isLargeScreen
        ? screenHeight * 0.25
        : isSmallScreen
        ? screenHeight * 0.18
        : screenHeight * 0.2;

    final hasValidImageUrl = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: hasValidImageUrl
            ? Image.network(
         BaseNetwork.BASE_Image_URL+imageUrl!,
          fit: BoxFit.contain, // ✅ Shows FULL image, no cropping
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildImagePlaceholder(isSmallScreen);
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder(isSmallScreen);
          },
        )
            : _buildImagePlaceholder(isSmallScreen),
      ),
    );
  }

  Widget _buildImagePlaceholder(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.park_outlined,
            size: isSmallScreen ? 36 : 48,
            color: AppColor.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No image',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: AppColor.textMuted.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeDetails(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tree Details',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isVeryNarrow = constraints.maxWidth < 300;
            if (isVeryNarrow) {
              return Column(
                children: [
                  _buildDetailColumn('Health', health, Icons.favorite_outline, isSmallScreen),
                  const SizedBox(height: 12),
                  _buildDetailColumn('Growth', growth, Icons.trending_up, isSmallScreen),
                  const SizedBox(height: 12),
                  _buildDetailColumn('Girth', girth, Icons.straighten, isSmallScreen),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDetailRow('Health', health, Icons.favorite_outline, isSmallScreen),
                  const SizedBox(height: 12),
                  _buildDetailRow('Growth', growth, Icons.trending_up, isSmallScreen),
                  const SizedBox(height: 12),
                  _buildDetailRow('Girth', girth, Icons.straighten, isSmallScreen),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColor.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: isSmallScreen ? 18 : 20,
              color: AppColor.secondary,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: AppColor.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 15,
                    color: AppColor.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, IconData icon, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColor.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: isSmallScreen ? 18 : 20,
              color: AppColor.secondary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: AppColor.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 15,
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maintenance',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
          decoration: BoxDecoration(
            color: AppColor.accent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.accent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: AppColor.accent,
                size: isSmallScreen ? 20 : 22,
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Maintenance',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDateString(nextMaintenanceDate),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Maintenance History',
          Icons.history,
          onMaintenanceHistoryTap,
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildMonitoringSection(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monitoring',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
          decoration: BoxDecoration(
            color: AppColor.skyBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.skyBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: AppColor.skyBlue,
                size: isSmallScreen ? 20 : 22,
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Monitoring',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDateString(nextMonitoringDate),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 340) {
              return Column(
                children: [
                  _buildActionButton(
                    'Manual History',
                    Icons.touch_app_outlined,
                    onManualMonitorHistoryTap,
                    isSmallScreen,
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    'Satellite History',
                    Icons.satellite_alt_outlined,
                    onSatelliteMonitorHistoryTap,
                    isSmallScreen,
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Manual History',
                      Icons.touch_app_outlined,
                      onManualMonitorHistoryTap,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: _buildActionButton(
                      'Satellite History',
                      Icons.satellite_alt_outlined,
                      onSatelliteMonitorHistoryTap,
                      isSmallScreen,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label,
      IconData icon,
      VoidCallback? onTap,
      bool isSmallScreen,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 14,
            horizontal: isSmallScreen ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 16 : 18,
                color: AppColor.primary,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateString(String? dateString) {
    if (dateString == null) return 'Not scheduled';

    try {
      final date = DateTime.parse(dateString); // Expects "YYYY-MM-DD"
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      // If parsing fails (e.g., invalid format), show raw or fallback
      return 'Invalid date';
      // Or: return dateString; // if you prefer to show as-is
    }
  }

  /*
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

   */
}