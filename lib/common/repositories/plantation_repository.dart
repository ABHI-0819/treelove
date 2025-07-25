import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../features/fieldworker/plantation/models/plantation_model.dart';

class PlantationRepository {
  final ApiConnection api;

  PlantationRepository({required this.api});

  Future<ApiResult> createPlantation(PlantationRequestModel request) async {
    return await api.apiConnectionMultipart<PlantationResponseModel>(
      BaseNetwork.plantationCreateURL,
      BaseNetwork.getHeaderForLogin(),
      'post',
      plantationResponseModelFromJson,
      fields: request.toJson(),
    );
  }
}

