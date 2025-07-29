import 'dart:convert';

import 'package:treelove/core/utils/logger.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/fieldworker/plantation/models/plantation_model.dart';
import '../models/planted.list.response.model.dart';

class PlantationRepository {
  final ApiConnection api;

  PlantationRepository({required this.api});
  final pref = SecurePreference();
  Future<ApiResult> createPlantation(PlantationRequestModel request) async {
    debugLog(request.toJson().toString(),name: "Request Checking");
    debugLog(request.toJsonString().toString(),name: "Request Checking String");
    final token = await pref.getString(Keys.accessToken);
    return await api.apiConnectionMultipart<PlantationResponseModel>(
      BaseNetwork.plantationCreateURL,
      BaseNetwork.getHeaderWithToken(token),
      'post',
      plantationResponseModelFromJson,
      fields: request.toJson(),
      fileKey: 'media',
      files: request.media
    );
  }

  ///  Fetch Plantation List
  Future<ApiResult> fetchPlantedList({ String ? areaId, String ? vendorId, String? createdBy}) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(baseUrl: BaseNetwork.plantationListURL,areaId:areaId,vendorId: vendorId,createdBy: createdBy);
    ApiResult result = await api.getApiConnection<PlantedListResponseModel>(
      url,
      BaseNetwork.getJsonHeadersWithToken(token), // ✅ Pass token
      plantedListResponseModelFromJson,        // ✅ Parse JSON into model
    );
    return result;
  }

}

