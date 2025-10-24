import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/logger.dart';
import '../../features/customer/retail/my-trees/models/monitor_history_list_response.dart';
import '../../features/fieldworker/activity/models/monitor_created_response_model.dart';
import '../../features/fieldworker/activity/models/monitor_request_model.dart';
import '../models/satellite_monitor_history_response.dart';
import '../models/satellite_monitor_response.dart';

class MonitorRepository {
  final ApiConnection api;
  MonitorRepository({required this.api});

  final pref = SecurePreference();

  Future<ApiResult> addMonitorRecord(MonitorRequestModel request) async {
    debugLog(request.toJson().toString(), name: "Monitor Request Checking");
    debugLog(request.toJsonString().toString(), name: "Monitor Request String");

    final token = await pref.getString(Keys.accessToken);

    return await api.apiConnectionMultipart<MonitorResponse>(
        BaseNetwork.monitorCreatedURL,                 // your monitor endpoint
        BaseNetwork.getHeaderWithToken(token),         // headers with token
        'post',
        monitorResponseFromJson,                       // JSON deserializer
        fields: request.toFields(),                    // convert request to fields
        fileKey: 'media',                              // match backend key
        files: request.media                           // pass list of files
    );
  }

  Future<ApiResult> fetchSatelliteMonitorById({required String id}) async {

    final token = await pref.getString(Keys.accessToken);
    final url=BaseNetwork.satelliteMonitorResultUrl+id+"/";
   ApiResult result=  await api.getApiConnection<SatelliteMonitorResponse>(
     url, // assuming endpoint like /monitor/{id}/
      BaseNetwork.getHeaderWithToken(token),
      satelliteMonitorResponseFromJson, // JSON deserializer
    );
   return result;
  }


  Future<ApiResult> fetchSatelliteMonitorHistory({required String Id}) async {

    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(baseUrl: BaseNetwork.satelliteMonitorResultUrl,plantation: Id);
    // final url=BaseNetwork.satelliteMonitorResultUrl+id+"/";
    ApiResult result=  await api.getApiConnection<SatelliteMonitoringHistoryResponse>(
      url, // assuming endpoint like /monitor/{id}/
      BaseNetwork.getHeaderWithToken(token),
      satelliteMonitoringHistoryResponseFromJson, // JSON deserializer
    );
    return result;
  }

  Future<ApiResult> fetchMonitorHistory({required String plantationId})async{
    final token = await pref.getString(Keys.accessToken);
    final url = api.generateUrl(baseUrl: BaseNetwork.monitorCreatedURL,plantation: plantationId);
    ApiResult result=  await api.getApiConnection<MonitoringHistoryListResponse>(
      url, // assuming endpoint like /monitor/{id}/
      BaseNetwork.getHeaderWithToken(token),
      monitoringHistoryListResponseFromJson, // JSON deserializer
    );
    return result;
  }

}
