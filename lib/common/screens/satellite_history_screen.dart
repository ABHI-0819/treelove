import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/satellite_bloc.dart';
import 'package:treelove/common/screens/satellite_monitoring_result_screen.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/authentication/screens/password_login_screen.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';

import '../../core/config/themes/app_color.dart';
/*
class SatelliteHistoryScreen extends StatefulWidget {
  static const route = '/satellite-history';

  const SatelliteHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SatelliteHistoryScreen> createState() => _SatelliteHistoryScreenState();
}

class _SatelliteHistoryScreenState extends State<SatelliteHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final satelliteData = [
      {
        "id": "bf29348b-273f-4bb3-a3e1-b735bcc8c911",
        "monitoring_date": "2025-10-04",
        "tree_species": {
          "local_name": "Peepal",
          "scientific_name": "Ficus religiosa",
        },
        "canopy_size": "3156350.0000",
        "confidence": "0.8500",
        "tree_health": "healthy",
        "created_at": "2025-10-04T12:59:47.493896+05:30",
      },
      {
        "id": "653a1175-f498-421d-9668-5841533e102d",
        "monitoring_date": "2025-10-04",
        "tree_species": {
          "local_name": "Peepal",
          "scientific_name": "Ficus religiosa",
        },
        "canopy_size": "3156350.0000",
        "confidence": "0.8500",
        "tree_health": "healthy",
        "created_at": "2025-10-04T16:41:50.978519+05:30",
      },
      {
        "id": "48426b02-1df3-455e-ab9b-4a4c8978aba8",
        "monitoring_date": "2025-10-07",
        "tree_species": {
          "local_name": "Peepal",
          "scientific_name": "Ficus religiosa",
        },
        "canopy_size": "3156350.0000",
        "confidence": "0.8500",
        "tree_health": "bad",
        "created_at": "2025-10-07T02:57:45.095558+05:30",
      }
    ];



    return Scaffold(
      // backgroundColor: AppColor.background,
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text("Satellite History",
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFEFCF3),
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: satelliteData.length,
        itemBuilder: (context, index) {
          final item = satelliteData[index];
          return _SatelliteCard(data: item);
        },
      ),
    );
  }
}

class _SatelliteCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _SatelliteCard({required this.data});

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatCanopySize(String size) {
    final sizeNum = double.parse(size);
    if (sizeNum >= 1000000) {
      return '${(sizeNum / 1000000).toStringAsFixed(2)} km²';
    }
    return '${(sizeNum / 1000).toStringAsFixed(2)} km²';
  }

  Color getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
        return AppColor.success;
      case 'bad':
        return AppColor.error;
      case 'moderate':
        return AppColor.warning;
      default:
        return AppColor.textMuted;
    }
  }

  Color getHealthBgColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
        return const Color(0xFFE8F5E9);
      case 'bad':
        return const Color(0xFFFFEBEE);
      case 'moderate':
        return const Color(0xFFFFF9C4);
      default:
        return AppColor.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final treeSpecies = data['tree_species'] as Map<String, dynamic>;
    final health = data['tree_health'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: AppColor.primary.withOpacity(0.06),
        child: InkWell(
          onTap: () {
            // Navigate to detail screen
            // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(data: data)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and health badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            treeSpecies['local_name'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            treeSpecies['scientific_name'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getHealthBgColor(health),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        health.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: getHealthColor(health),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Grid
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.calendar_today,
                        label: 'Monitoring Date',
                        value: formatDate(data['monitoring_date'] as String),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.nature,
                        label: 'Canopy Size',
                        value: formatCanopySize(data['canopy_size'] as String),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Footer
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColor.border),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: AppColor.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Confidence: ${(double.parse(data['confidence'] as String) * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.textMuted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'View Details →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColor.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColor.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

 */
// satellite_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Import your models & bloc
import '../../core/network/api_connection.dart';
import '../models/response.mode.dart';
import '../models/satellite_monitor_history_response.dart';
import '../bloc/api_event.dart'; // Assuming ApiListFetch is here
import '../bloc/api_state.dart';
import '../repositories/monitor_repository.dart'; // Assuming ApiState, ApiLoading, ApiSuccess, ApiFailure, etc.

class SatelliteHistoryScreen extends StatefulWidget {
  static const route = '/satellite-history';
  final String plantationId; // e.g., plantation ID or monitor ID

  const SatelliteHistoryScreen({Key? key,required this.plantationId}) : super(key: key);

  @override
  State<SatelliteHistoryScreen> createState() => _SatelliteHistoryScreenState();
}

class _SatelliteHistoryScreenState extends State<SatelliteHistoryScreen> {
  
  late SatelliteHistoryBloc satelliteHistoryBloc;
  @override
  void initState() {
    super.initState();
    satelliteHistoryBloc = SatelliteHistoryBloc(MonitorRepository(api: ApiConnection()));
    satelliteHistoryBloc.add(ApiListFetch(id: widget.plantationId));
    // Trigger data fetch on screen load
    // if (widget.id != null) {
    //   context.read<SatelliteHistoryBloc>().add(ApiListFetch(id: widget.id));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF3),
      appBar: AppBar(
        title: const Text(
          "Satellite History",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFEFCF3),
        scrolledUnderElevation: 0,
      ),
      body: BlocProvider(
  create: (context) =>satelliteHistoryBloc,
  child: BlocBuilder<SatelliteHistoryBloc, ApiState<SatelliteMonitoringHistoryResponse, ResponseModel>>(
        builder: (context, state) {
          if (state is ApiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApiSuccess<SatelliteMonitoringHistoryResponse, ResponseModel>) {
            final List<SatelliteMonitorData> entries = state.data.data;
            if (entries.isEmpty) {
              return const Center(child: Text('No satellite records found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return _SatelliteCard(data: entries[index]);
              },
            );
          }

          if (state is ApiFailure<SatelliteMonitoringHistoryResponse, ResponseModel>) {
            // final message = state is ApiFailure
            //     ? state.response.message
            //     : 'Session expired. Please log in again.';
            // final bool isTokenExpired = state is TokenExpired;
            // final String message = isTokenExpired
            //     ? 'Session expired. Please log in again.'
            //     : (state as ApiFailure).response.message ?? 'Something went wrong. Please try again.';
            final msg = state.error.message??"Something went wrong. Please try again";
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      satelliteHistoryBloc.add(
                          ApiListFetch(id: widget.plantationId));
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is TokenExpired<SatelliteMonitoringHistoryResponse, ResponseModel>) {
            final msg = state.error.message??'Something went wrong. Please try again';
            // final bool isTokenExpired = state is TokenExpired;
            // final String message = isTokenExpired
            //     ? 'Session expired. Please log in again.'
            //     : (state as ApiFailure).response.message ?? 'Something went wrong. Please try again.';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                        AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
                    },
                    child: Text('Go to Login'),
                  ),
                ],
              ),
            );
          }

          // Initial or unknown state
          return const Center(child: Text('Ready to load data...'));
        },
      ),
),
    );
  }
}

// ----------------------------
// _SatelliteCard - Updated to use SatelliteMonitorData
// ----------------------------
class _SatelliteCard extends StatelessWidget {
  final SatelliteMonitorData data;

  const _SatelliteCard({required this.data});

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String formatCanopySize(String size, String unit) {
    final sizeNum = double.tryParse(size) ?? 0.0;
    // Your API returns unit (e.g., "m²"), but you want to display in km²
    if (unit == 'm²') {
      final km2 = sizeNum / 1_000_000;
      return '${km2.toStringAsFixed(2)} km²';
    }
    // Fallback: just show as-is
    return '$size $unit';
  }

  Color getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
        return AppColor.success;
      case 'bad':
        return AppColor.error;
      case 'moderate':
        return AppColor.warning;
      default:
        return AppColor.textMuted;
    }
  }

  Color getHealthBgColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
        return const Color(0xFFE8F5E9);
      case 'bad':
        return const Color(0xFFFFEBEE);
      case 'moderate':
        return const Color(0xFFFFF9C4);
      default:
        return AppColor.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final health = data.treeHealth;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: AppColor.primary.withOpacity(0.06),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to detail screen with `data`
            AppRoute.goToNextPage(context: context, screen: SatelliteMonitoringResultScreen.route, arguments: {
              'monitorId':data.id
            });
            // Navigator.push(context, MaterialPageRoute(builder: (_) => SatelliteDetailScreen(data: data)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and health badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.treeSpecies.localName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.treeSpecies.scientificName,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getHealthBgColor(health),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        health.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: getHealthColor(health),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Grid
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.calendar_today,
                        label: 'Monitoring Date',
                        value: formatDate(data.monitoringDate),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.nature,
                        label: 'Canopy Size',
                        value: formatCanopySize(data.canopySize, data.canopySizeUnit),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Footer
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColor.border),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: AppColor.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Confidence: ${(double.tryParse(data.confidence) ?? 0.0 * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.textMuted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'View Details →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------
// Reusable Info Item
// ----------------------------
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColor.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColor.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

