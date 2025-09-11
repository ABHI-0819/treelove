import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/logger.dart';
import '../../features/fieldworker/activity/models/tree_diseases_list_response_model.dart';

class TreeDiseasesRepository{
  final ApiConnection ? api;
  final pref = SecurePreference();

  TreeDiseasesRepository({this.api});
  Future<ApiResult> getTreeDiseaseList({String ? diseasesId}) async {
    final url = diseasesId != null
        ? '${BaseNetwork.treeDiseasesURL}/${diseasesId}/'
        : BaseNetwork.treeDiseasesURL;
    ApiResult result = await api!.getApiConnection(url, BaseNetwork.getJsonHeaders(), treeDiseaseListResponseFromJson);
    debugLog(result.status.toString(),name: "Tree Diseases Loaded");
    if (result.status == ApiStatus.success) {
      return result;
    }
    return result;
  }
}