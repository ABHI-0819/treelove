import 'dart:convert';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/logger.dart';
import '../../features/fieldworker/activity/models/assigned_service_type_response.dart';
import '../../features/vendor/task/models/service_detail_response_model.dart';

class ServicesRepository {
  final ApiConnection ? api;
  ServicesRepository({this.api});

  Future<void> cacheServiceIds() async {
    try {
      final result = await api!.getApiConnection(
        BaseNetwork.servicesURL,
        BaseNetwork.getJsonHeaderForLogin(),
            (res) => json.decode(res) as Map<String, dynamic>,
        isLogIn: true
      );

      debugLog(result.response.toString(),);
      if (result.status == ApiStatus.success) {
        final List<dynamic> dataList = result.response["data"];

        // ✅ Find each required service
        String? plantationId;
        String? maintenanceId;
        String? monitoringId;

        for (var item in dataList) {
          final name = (item["name"] ?? "").toString().toLowerCase();

          if (name.contains("plantation")) {
            plantationId = item["id"];
          } else if (name.contains("maintenance")) {
            maintenanceId = item["id"];
          } else if (name.contains("monitoring")) {
            monitoringId = item["id"];
          }
        }

        // ✅ Store securely
        final securePref = SecurePreference();
        if (plantationId != null) {
          await securePref.setString(Keys.plantationServiceId, plantationId);
        }
        if (maintenanceId != null) {
          await securePref.setString(Keys.maintenanceServiceId, maintenanceId);
        }
        if (monitoringId != null) {
          await securePref.setString(Keys.monitoringServiceId, monitoringId);
        }

        debugLog("Services IDs cached successfully");
      }
    } catch (e) {
      debugLog("Failed to fetch/cache service IDs: $e");
    }
  }


  Future<ApiResult> getServiceDetails({required String serviceName,required String projectAreaId}) async {
      final url = api!.generateUrl(baseUrl: BaseNetwork.serviceDetailUrl,
          serviceName: serviceName,
          projectAreaId: projectAreaId);
      final result = await api!.getApiConnection(
        url,
        BaseNetwork.getJsonHeaders(),
            (res) => ServiceDetailResponse.fromJson(json.decode(res)),
      );
      if (result.status == ApiStatus.success) {
        return result;
      }
      return result;
    }


  Future<ApiResult> getAssignedServiceDetails({required String projectId,required String projectAreaId}) async {
    final url = api!.generateUrl(baseUrl: BaseNetwork.fieldworkerDashboardUrl,
        projectId: projectId,
        projectAreaId: projectAreaId);
    final result = await api!.getApiConnection(
      url,
      BaseNetwork.getJsonHeaders(),
          (res) => AssignedServiceTypeResponse.fromJson(json.decode(res)),
    );
    if (result.status == ApiStatus.success) {
      return result;
    }
    return result;
  }


}