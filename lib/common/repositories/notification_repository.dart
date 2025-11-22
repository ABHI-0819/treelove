import 'package:treelove/core/network/base_network.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../models/notifications_response_model.dart';

class NotificationRepository{
  final ApiConnection api;
  NotificationRepository({required this.api});

  final pref = SecurePreference();

  Future<ApiResult> fetchNotifications() async {

    final token = await pref.getString(Keys.accessToken);
    ApiResult result=  await api.getApiConnection<NotificationResponse>(
      BaseNetwork.notificationsListUrl, // assuming endpoint like /monitor/{id}/
      BaseNetwork.getJsonHeaders(),
      // BaseNetwork.getHeaderWithToken(token),
      notificationResponseFromJson, // JSON deserializer
    );
    return result;
  }

}