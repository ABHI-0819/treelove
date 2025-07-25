import 'package:flutter/material.dart';
/*
class MaintenanceHistoryScreen extends StatelessWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> maintenanceHistory = [
      {
        'date': '12 July 2025',
        'activity': 'Watered trees',
        'status': 'Completed',
        'remarks': 'All saplings in healthy condition',
      },
      {
        'date': '5 July 2025',
        'activity': 'Fertilized soil',
        'status': 'Completed',
        'remarks': 'Used organic compost',
      },
      {
        'date': '28 June 2025',
        'activity': 'Pest control spray',
        'status': 'Missed',
        'remarks': 'Heavy rain, rescheduled',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text('Maintenance History'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: maintenanceHistory.length,
        itemBuilder: (context, index) {
          final item = maintenanceHistory[index];
          return _buildMaintenanceCard(item);
        },
      ),
    );
  }

  Widget _buildMaintenanceCard(Map<String, String> item) {
    Color statusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
          return Colors.green;
        case 'missed':
          return Colors.red;
        case 'scheduled':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['date'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['activity'] ?? '',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text(item['status'] ?? ''),
                backgroundColor: statusColor(item['status'] ?? ''),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
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



import 'package:flutter/material.dart';

class MaintenanceHistoryScreen extends StatelessWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> maintenanceHistory = [
      {
        'treeId': 'TL-001',
        'species': 'Neem',
        'date': '12 July 2025',
        'activity': 'Watering',
        'status': 'Completed',
        'remarks': 'Soil well-soaked, leaves healthy',
      },
      {
        'treeId': 'TL-002',
        'species': 'Peepal',
        'date': '5 July 2025',
        'activity': 'Fertilization',
        'status': 'Completed',
        'remarks': 'Added vermicompost',
      },
      {
        'treeId': 'TL-003',
        'species': 'Banyan',
        'date': '28 June 2025',
        'activity': 'Pest control',
        'status': 'Rescheduled',
        'remarks': 'Rainy weather',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text('Maintenance History'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: maintenanceHistory.length,
        itemBuilder: (context, index) {
          final item = maintenanceHistory[index];
          return _buildMaintenanceCard(item);
        },
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
          /// Tree ID and Species
          Text(
            '${item['treeId']} • ${item['species']}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 4),

          /// Date & Activity
          Text(
            '${item['date']} • ${item['activity']}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          /// Status Chip & Remarks
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

 */

import 'package:flutter/material.dart';

class TreeMaintenanceHistoryScreen extends StatelessWidget {
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
                '$treeSpecies ($treeId)',
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


