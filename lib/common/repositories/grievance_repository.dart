import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/logger.dart';
import '../../features/customer/retail/grievance/model/grievance_category_list_response.dart';
import '../../features/customer/retail/grievance/model/grievance_list_response.dart';
import '../../features/customer/retail/grievance/model/grievance_request.dart';
import '../../features/customer/retail/grievance/model/grievance_response.dart';

class GrievanceRepository {
  final ApiConnection ? api;
  final SecurePreference pref = SecurePreference();

  GrievanceRepository({ this.api});

  /// Submit a new grievance
  Future<ApiResult> postGrievance(GrievanceRequestModel request) async {
    debugLog(request.toJsonString(), name: "Grievance Request");

    final token = await pref.getString(Keys.accessToken);

    return await api!.apiConnectionMultipart<GrievanceResponse>(
      BaseNetwork.grievanceCreateURL,
      BaseNetwork.getMultipartHeaders(),// e.g., '/api/grievances/'
      // BaseNetwork.getHeaderWithToken(token),
      'post',
      grievanceResponseFromJson,            // your deserializer
      fields: request.toFields(),
      fileKey: 'image',
      files: request.image != null ? [request.image!] : [], // List<XFile>?
    );
  }

  /// Fetch all grievances
  Future<ApiResult> fetchAllGrievances() async {
    final token = await pref.getString(Keys.accessToken);
    return await api!.getApiConnection<GrievanceListResponse>(
      BaseNetwork.grievanceCreateURL,
      BaseNetwork.getJsonHeaders(),// e.g., '/api/grievances/'
      // BaseNetwork.getHeaderWithToken(token),
      grievanceListResponseFromJson,
    );
  }

  /// Fetch all categories
  Future<ApiResult> fetchGrievanceCategories() async {
    final token = await pref.getString(Keys.accessToken);
    return await api!.getApiConnection<GrievanceCategoryListResponse>(
      BaseNetwork.grievanceCategoriesURL, // e.g., '/api/v1/grievance/grievance-categories/'
      // BaseNetwork.getHeaderWithToken(token),
      BaseNetwork.getJsonHeaders(),
      grievanceCategoryListResponseFromJson,
    );
  }
}