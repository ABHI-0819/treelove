import 'package:flutter/material.dart';

class TreeMaintenanceHistoryScreen extends StatefulWidget {
  static const route = '/tree-maintenance-history';
  final String treeSpecies;
  final String location;
  final String treeId;

  const TreeMaintenanceHistoryScreen({
    super.key,
    required this.treeSpecies,
    required this.location,
    required this.treeId,
  });

  @override
  State<TreeMaintenanceHistoryScreen> createState() => _TreeMaintenanceHistoryScreenState();
}

class _TreeMaintenanceHistoryScreenState extends State<TreeMaintenanceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> maintenanceHistory = [
      {
        'date': '12 July 2025',
        'activity': 'Watering',
        'status': 'Completed',
        'remarks': 'Healthy growth, adequate moisture',
      },
      {
        'date': '5 July 2025',
        'activity': 'Fertilization',
        'status': 'Completed',
        'remarks': 'Used vermicompost',
      },
      {
        'date': '28 June 2025',
        'activity': 'Pest Control',
        'status': 'Rescheduled',
        'remarks': 'Postponed due to rainfall',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text("Maintenance History", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFEFCF3),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Tree Info Header
              Text(
                '${widget.treeSpecies} (${widget.treeId})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 20),

              /// Maintenance Logs
              Expanded(
                child: ListView.builder(
                  itemCount: maintenanceHistory.length,
                  itemBuilder: (context, index) {
                    final item = maintenanceHistory[index];
                    return _buildMaintenanceCard(item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceCard(Map<String, String> item) {
    Color statusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
          return Colors.green;
        case 'rescheduled':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    IconData statusIcon(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
          return Icons.check_circle;
        case 'rescheduled':
          return Icons.schedule;
        default:
          return Icons.info_outline;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date + Activity
          Text(
            '${item['date']} • ${item['activity']}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          /// Status + Remarks
          Row(
            children: [
              Icon(
                statusIcon(item['status'] ?? ''),
                size: 18,
                color: statusColor(item['status'] ?? ''),
              ),
              const SizedBox(width: 6),
              Text(
                item['status'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: statusColor(item['status'] ?? ''),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Text(
                  item['remarks'] ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


