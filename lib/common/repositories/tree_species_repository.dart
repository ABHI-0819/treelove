import 'package:treelove/core/utils/logger.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../features/customer/retail/tree-species/models/tree_species_model.dart';

class TreeSpeciesRepository{
  final ApiConnection? api;

  TreeSpeciesRepository({this.api});
  Future<ApiResult> getTreeList({String ? treeId}) async {
    final url = treeId != null
        ? '${BaseNetwork.treeSpeciesURL}/${treeId}/'
        : BaseNetwork.treeSpeciesURL;
    ApiResult result = await api!.getApiConnection(BaseNetwork.treeSpeciesURL, BaseNetwork.getJsonHeaders(), treeSpeciesListResponseFromJson);
    debugLog(result.status.toString(),name: "Bhosda Loaded");
    if (result.status == ApiStatus.success) {
      return result;
    }
    return result;
  }

  Future<ApiResult> getTreeDetail({required String  treeId}) async {
    final url = '${BaseNetwork.treeSpeciesURL}$treeId/';
    ApiResult result = await api!.getApiConnection(url, BaseNetwork.getJsonHeaders(), singleTreeSpeciesResponseFromJson);
    debugLog(result.status.toString(),name: "Bhosda Loaded");
    if (result.status == ApiStatus.success) {
      return result;
    }
    return result;
  }





}