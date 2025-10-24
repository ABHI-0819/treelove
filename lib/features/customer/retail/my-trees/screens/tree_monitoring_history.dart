import 'package:flutter/material.dart';
/*
class TreeMonitoringHistoryScreen extends StatefulWidget {
  static const route = '/tree-monitoring-history';
  final String treeSpecies;
  final String location;
  final String treeId;

  const TreeMonitoringHistoryScreen({
    super.key,
    required this.treeSpecies,
    required this.location,
    required this.treeId,
  });

  @override
  State<TreeMonitoringHistoryScreen> createState() =>
      _TreeMonitoringHistoryScreenState();
}

class _TreeMonitoringHistoryScreenState
    extends State<TreeMonitoringHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> monitoringHistory = [
      {
        'date': '15 Aug 2025',
        'health': 'Healthy 🌳',
        'girth': '65 cm',
        'height': '12.5 m',
        'remarks': 'Good canopy growth, no pest detected',
      },
      {
        'date': '1 Aug 2025',
        'health': 'Good 🙂',
        'girth': '64 cm',
        'height': '12.2 m',
        'remarks': 'Slight yellowing on lower leaves',
      },
      {
        'date': '18 July 2025',
        'health': 'Require Attention 🛠️',
        'girth': '63 cm',
        'height': '12.0 m',
        'remarks': 'Signs of fungal infection near roots',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text(
          "Monitoring History",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 20),

              /// Monitoring Logs (sexy cards)
              Expanded(
                child: ListView.builder(
                  itemCount: monitoringHistory.length,
                  itemBuilder: (context, index) {
                    final item = monitoringHistory[index];
                    return _buildMonitoringCard(item, index, monitoringHistory.length);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(
      Map<String, String> item, int index, int total) {
    return Container(
      margin: EdgeInsets.only(bottom: index == total - 1 ? 0 : 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date
          Text(
            item['date'] ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 14),

          buildTreeInfoWrap(),

          const Divider(height: 24, thickness: 1, color: Color(0xFFE0E0E0)),

          /// Remarks
          Text(
            item['remarks'] ?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.orange,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTreeInfoWrap() {
    return Wrap(// horizontal gap
    // vertical gap if wrapped
      // alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.start,

      children: [
        _buildInfoItem( "Health", "Good"),
        _buildInfoItem( "Girth", "2.3 m"),
        _buildInfoItem( "Height", "12 m"),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return SizedBox(
      width: 90, // keeps them aligned; adjust as per design
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }


}

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/monitor_repository.dart';
import 'package:treelove/features/customer/retail/my-trees/bloc/monitor_history_bloc.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/api_connection.dart';
import '../models/monitor_history_list_response.dart';

class TreeMonitoringHistoryScreen extends StatefulWidget {
  static const route = '/tree-monitoring-history';
  final String treeId;

  const TreeMonitoringHistoryScreen({
    super.key,
    required this.treeId,
  });

  @override
  State<TreeMonitoringHistoryScreen> createState() =>
      _TreeMonitoringHistoryScreenState();
}

class _TreeMonitoringHistoryScreenState extends State<TreeMonitoringHistoryScreen> {

  late MonitoringHistoryBloc monitoringHistoryBloc;

  @override
  void initState() {
    super.initState();
    monitoringHistoryBloc = MonitoringHistoryBloc(MonitorRepository(api: ApiConnection()));
    monitoringHistoryBloc.add(ApiListFetch(id: widget.treeId));
  }

  @override
  void dispose() {
    monitoringHistoryBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text(
          "Monitoring History",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFEFCF3),
        scrolledUnderElevation: 0,
      ),
      body: BlocProvider(
  create: (context) => monitoringHistoryBloc,
  child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<MonitoringHistoryBloc, ApiState<MonitoringHistoryListResponse, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ApiSuccess<MonitoringHistoryListResponse, ResponseModel>) {
                      final records = state.data.data;
                      if (records.isEmpty) {
                        return const Center(child: Text('No monitoring records found.'));
                      }
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return _buildMonitoringCardFromModel(records[index], index, records.length);
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
                              state is TokenExpired<MonitoringHistoryListResponse, ResponseModel>
                                  ? 'Session expired. Please log in again.'
                                  :  'Failed to load data.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                monitoringHistoryBloc.add(ApiListFetch(id: widget.treeId));
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
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

  Widget _buildMonitoringCardFromModel(MonitoringRecord record, int index, int total) {
    String formatDate(DateTime date) {
      return '${date.day} ${_monthNames[date.month]} ${date.year}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: index == total - 1 ? 0 : 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(record.monitoringDate),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoItem("Health", record.remarks),
              _buildInfoItem("Girth", "N/A"), // You don't have girth in model!
              _buildInfoItem("Height", "N/A"), // You don't have height in model!
              // ⚠️ Note: Your MonitoringRecord doesn't include girth/height!
              // If you need them, update your API/model.
            ],
          ),

          const Divider(height: 24, thickness: 1, color: Color(0xFFE0E0E0)),

          Text(
            record.remarks,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.orange,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
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
