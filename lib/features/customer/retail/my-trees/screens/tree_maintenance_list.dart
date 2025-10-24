import 'package:flutter/material.dart';
/*
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

 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/maintenance_repository.dart';


import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/api_connection.dart';
import '../bloc/maintenance_history_bloc.dart';
import '../models/maintenance_history_list_response.dart';

class TreeMaintenanceHistoryScreen extends StatefulWidget {
  static const route = '/tree-maintenance-history';
  final String treeId;

  const TreeMaintenanceHistoryScreen({
    super.key,
    required this.treeId,
  });

  @override
  State<TreeMaintenanceHistoryScreen> createState() => _TreeMaintenanceHistoryScreenState();
}

class _TreeMaintenanceHistoryScreenState extends State<TreeMaintenanceHistoryScreen> {
  
  
  late MaintenanceHistoryBloc maintenanceHistoryBloc;
  
  @override
  void initState() {
    super.initState();
    maintenanceHistoryBloc = MaintenanceHistoryBloc(MaintenanceRepository(api: ApiConnection()));
    // Trigger data fetch when screen loads
    maintenanceHistoryBloc.add(ApiListFetch(id: widget.treeId));
  }

  @override
  void dispose() {
    maintenanceHistoryBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text("Maintenance History", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFEFCF3),
        scrolledUnderElevation: 0,
      ),
      body: BlocProvider(
  create: (context) =>maintenanceHistoryBloc,
  child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<MaintenanceHistoryBloc, ApiState<MaintenanceHistoryListResponse, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ApiSuccess<MaintenanceHistoryListResponse, ResponseModel>) {
                      final records = state.data.data; // List<MaintenanceRecord>
                      if (records.isEmpty) {
                        return const Center(child: Text('No maintenance records found.'));
                      }
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return _buildMaintenanceCardFromModel(records[index]);
                        },
                      );
                    } else if (state is ApiFailure || state is TokenExpired) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              state is TokenExpired<MaintenanceHistoryListResponse, ResponseModel>
                                  ? 'Session expired. Please log in again.'
                                  :  'Failed to load data.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                maintenanceHistoryBloc.add(ApiListFetch(id: widget.treeId));
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // ApiInitial or unknown
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
),
    );
  }

  Widget _buildMaintenanceCardFromModel(MaintenanceRecord record) {
    String formatDate(DateTime date) {
      return '${date.day} ${_monthNames[date.month]} ${date.year}';
    }

    String getStatusFromHealth(String health) {
      // You can map treeHealth to a status if needed
      // For now, we'll use "Completed" as default since it's historical data
      return 'Completed';
    }

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

    // Combine all maintenance activities into one string (or show first)
    String activities = record.maintenanceActivity
        .map((a) => a.name)
        .join(', ');

    String status = getStatusFromHealth(record.treeHealth);

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
          Text(
            '${formatDate(record.maintenanceDate)} • $activities',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                statusIcon(status),
                size: 18,
                color: statusColor(status),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: statusColor(status),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Text(
                  record.remarks,
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

  static const List<String> _monthNames = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
}


