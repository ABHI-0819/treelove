import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/vendor/home/models/project_detail_model.dart';
import 'package:treelove/features/vendor/home/models/project_list_model.dart';

import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/customer/b2b/projects/model/b2b_project_detail_response_model.dart';

class ProjectRepository {
  final ApiConnection api;
  ProjectRepository({required this.api});

   final pref = SecurePreference();

  /// Fetches a list of projects with optional filters.
  Future<ApiResult> fetchProjects({
    String? filter,
    String? search,
    String? category,
    String? type,
    int? page,
    int? limit,
  }) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(
        baseUrl: BaseNetwork.projectListURL,
        status: filter,
        category: category,
        type : type,
        searchQuery: search);
    ApiResult result = await api.getApiConnection<ProjectListResponse>(
      // BaseNetwork.projectListURL,
      url,
      BaseNetwork.getJsonHeadersWithToken(token),
      projectListResponseFromJson,
    );

    return result;
  }

  Future<ApiResult> fetchProjectDetails({required String projectId}) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(
        baseUrl: BaseNetwork.projectDashboardURL, projectId: projectId);
    // final url = '${BaseNetwork.projectDashboardURL}$projectId/';
    //projectDashboardURL
    ApiResult result = await api.getApiConnection<ProjectDetailResponse>(
      url,
      BaseNetwork.getJsonHeadersWithToken(token),
      projectDetailResponseFromJson,
    );
    return result;
  }

  // B2B Project Details
  Future<ApiResult> fetchB2BProjectDetails({required String projectId}) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(
        baseUrl: BaseNetwork.b2bProjectDashboardURL, projectId: projectId);
    ApiResult result =
        await api.getApiConnection<B2BProjectDetailResponseModel>(
      url,
      BaseNetwork.getJsonHeadersWithToken(token),
      b2bProjectDetailResponseModelFromJson,
    );
    return result;
  }
  
}
