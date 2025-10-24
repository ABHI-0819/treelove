import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/features/fieldworker/activity/models/maintenance_request_model.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/customer/retail/my-trees/models/maintenance_history_list_response.dart';
import '../../features/fieldworker/activity/models/maintenance_activity_response_model.dart';
import '../../features/fieldworker/activity/models/maintenance_created_response_model.dart';

class MaintenanceRepository{
  final ApiConnection api;
  MaintenanceRepository({required this.api});

  final pref = SecurePreference();
  Future<ApiResult> addMaintenanceRecord(MaintenanceRequestModel request) async {
    debugLog(request.toJson().toString(),name: "Request Checking");
    debugLog(request.toJsonString().toString(),name: "Request Checking String");
    final token = await pref.getString(Keys.accessToken);
    return await api.apiConnectionMultipart<MaintenanceResponse>(
        BaseNetwork.maintenanceCreatedURL,
        BaseNetwork.getHeaderWithToken(token),
        'post',
        maintenanceResponseFromJson,
        fields: request.toFields(),
        fileKey: 'media',
        files: request.media
    );
  }

  Future<ApiResult> fetchMaintenanceActivityList() async {
    ApiResult result  = await api.getApiConnection(
        BaseNetwork.maintenanceActivityUrl,
        BaseNetwork.getJsonHeaders(),
        maintenanceActivityResponseModelFromJson
    );
     return result;
  }

  Future<ApiResult> fetchMaintenanceHistoryList({required String id})async{
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(baseUrl: BaseNetwork.maintenanceCreatedURL,plantation: id);
    ApiResult result=  await api.getApiConnection<MaintenanceHistoryListResponse>(
      url, // assuming endpoint like /monitor/{id}/
      BaseNetwork.getHeaderWithToken(token),
      maintenanceHistoryListResponseFromJson,  // JSON deserializer
    );
    return result;
  }

}