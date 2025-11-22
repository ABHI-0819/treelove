import 'package:treelove/common/models/response.mode.dart';
import 'package:treelove/core/network/base_network.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/customer/retail/order/models/order_list_response.dart';
import '../../features/customer/retail/order/models/order_place_request.dart';
import '../../features/customer/retail/order/models/order_place_response.dart';
import '../../features/customer/retail/order/models/order_tracking_response.dart';

class OrderRepository{
  final ApiConnection ? api;
  OrderRepository({this.api});

  final pref = SecurePreference();



  Future<ApiResult> makeOrder({
    required OrderPlaceRequest fields,

  }) async {
    final token = await pref.getString(Keys.accessToken);
    ApiResult result = await api!.apiConnectionMultipart<OrderPlacedResponse>(
        BaseNetwork.orderPlaceUrl,
        BaseNetwork.getMultipartHeaders(),
        // BaseNetwork.getJsonHeadersWithToken(token), // use token if required
        'post',
        orderPlacedResponseFromJson,
        fields:fields.toJson()//fields.toJson(),
    );
    return result;
  }

  Future<ApiResult> fetchOrders() async {
    final token = await pref.getString(Keys.accessToken);
    ApiResult result = await api!.getApiConnection<OrderListResponse>(
        BaseNetwork.orderPlaceUrl,
        BaseNetwork.getJsonHeaders(),
        // BaseNetwork.getJsonHeadersWithToken(token), // use token if required
      orderListResponseFromJson,
    );
    return result;
  }


  Future<ApiResult> fetchOrderTracking({required String orderId}) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api!.generateUrl(baseUrl: BaseNetwork.orderTrackingUrl,orderId: orderId);
    ApiResult result = await api!.getApiConnection<OrderTrackingResponse>(
      url,
      BaseNetwork.getJsonHeaders(),
      // BaseNetwork.getJsonHeadersWithToken(token),
      orderTrackingResponseFromJson,
    );
    return result;
  }


}