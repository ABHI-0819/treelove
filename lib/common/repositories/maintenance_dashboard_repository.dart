import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../models/maintenance_dashboard_model.dart';

class MaintenanceDashboardRepository {
  final ApiConnection api;
  MaintenanceDashboardRepository({required this.api});

  /// Fetches maintenance dashboard for a project.
  /// If [projectAreaId] is provided, fetches area-specific data.
  Future<ApiResult> fetchMaintenanceDashboard({
    required String projectId,
    String? projectAreaId,
  }) async {
    String url = '${BaseNetwork.maintenanceDashboardUrl}$projectId/';
    if (projectAreaId != null && projectAreaId.isNotEmpty) {
      url += '?project_area_id=$projectAreaId';
    }
    ApiResult result = await api.getApiConnection<MaintenanceDashboardModel>(
      url,
      BaseNetwork.getJsonHeaders(),
      maintenanceDashboardModelFromJson,
    );
    return result;
  }
}
