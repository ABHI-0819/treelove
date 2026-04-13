import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/core/network/base_network.dart';

enum ReportType { overall, maintenance, monitoring }

class ReportRepository {
  final ApiConnection api;

  ReportRepository({required this.api});

  Future<File?> downloadReport(String projectId, ReportType type) async {
    String url;
    String fileName;

    switch (type) {
      case ReportType.overall:
        url = "${BaseNetwork.reportOverallURL}?project_id=$projectId";
        fileName = "overall_report_${projectId.substring(0, 8)}.xlsx";
        break;
      case ReportType.maintenance:
        url = "${BaseNetwork.reportMaintenanceURL}?project_id=$projectId";
        fileName = "maintenance_report_${projectId.substring(0, 8)}.xlsx";
        break;
      case ReportType.monitoring:
        url = "${BaseNetwork.reportMonitoringURL}?project_id=$projectId";
        fileName = "monitoring_report_${projectId.substring(0, 8)}.xlsx";
        break;
    }

    final bytes = await api.getBinaryData(url);
    if (bytes == null) return null;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }
}
