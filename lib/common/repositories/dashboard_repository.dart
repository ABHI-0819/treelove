import 'dart:convert';

import 'package:treelove/core/network/api_connection.dart';

import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/customer/b2b/dashboard/model/dashboard_response_model.dart';
import '../../features/fieldworker/home/models/fieldworker_dashboard_response_model.dart';
import '../models/response.mode.dart';

class DashboardRepository {
  final ApiConnection api;
  DashboardRepository({required this.api});
  final pref = SecurePreference();
  //b2bDashboardUrl
  Future<ApiResult> getB2BDashboardData() async {
    ApiResult result = await api.getApiConnection(
      BaseNetwork.b2bDashboardUrl,
      BaseNetwork.getJsonHeaders(),
      // BaseNetwork.getHeaderWithToken(token),
      dashboardResponseModelFromJson,
    );
    return result;
  }

  // field worker dashboard
  Future<ApiResult> getFieldWorkerDashboard() async {
    ApiResult result = await api.getApiConnection(
        BaseNetwork.fieldworkerDashboardUrl, BaseNetwork.getJsonHeaders(),
        // BaseNetwork.getHeaderWithToken(token),
        (String str) {
      final decoded = json.decode(str);
      return FieldworkerDashboardResponseModel.fromJson(decoded['data']);
    });
    return result;
  }
}
