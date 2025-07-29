

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/fieldworker/activity/models/project_area_list_response.dart';

class ProjectAreaRepository {
  final ApiConnection  api;
  ProjectAreaRepository({required this.api});

  /// Fetches a list of projects with optional filters.
  final pref = SecurePreference();

  Future<ApiResult> fetchProjectAreas({
    String? filter,
    String? search,
    int? page,
    int? limit,
  }) async {

    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(baseUrl: BaseNetwork.projectAreasURl,status: filter,searchQuery: search);
    ApiResult result = await api.getApiConnection<ProjectAreasResponse>(
      // BaseNetwork.projectListURL,
      url,
      BaseNetwork.getJsonHeadersWithToken(token),
      projectAreasResponseFromJson,
    );

    return result;
  }


  /*
  Future<ApiResult> fetchProjectDetails({
    required String projectId
  }) async {
    final pref = SecurePreference();
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(baseUrl:BaseNetwork.projectDashboardURL ,projectId: projectId);
    // final url = '${BaseNetwork.projectDashboardURL}$projectId/';
    //projectDashboardURL
    ApiResult result = await api.getApiConnection<ProjectDetailResponse>(
      url,
      BaseNetwork.getJsonHeadersWithToken(token),
      projectDetailResponseFromJson,
    );
    return result;
  }

   */
}