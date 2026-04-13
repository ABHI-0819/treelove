import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          if (record.thumbnail != null && record.thumbnail!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: record.thumbnail!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
            ),
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
              _buildInfoItem("Health", record.treeHealth ?? "Unknown"),
              _buildInfoItem("Girth", record.treeGirth != null ? "${record.treeGirth} ${record.treeGirthUnit ?? ''}" : "N/A"),
              _buildInfoItem("Height", record.treeHeight != null ? "${record.treeHeight} ${record.treeHeightUnit ?? ''}" : "N/A"),
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
