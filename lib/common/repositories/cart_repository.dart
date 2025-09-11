
import 'dart:convert';

import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/core/utils/logger.dart';

import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/customer/retail/cart/model/cart_item_list_model.dart';
import '../../features/customer/retail/cart/model/cart_item_model.dart';
import '../../features/customer/retail/cart/model/cart_request_model.dart';

class CartRepository{
  final ApiConnection ? api;
  CartRepository({this.api});
  final pref = SecurePreference();
  Future<ApiResult> addItemToCart({
    required CartRequestDetail fields,

  }) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api!.generateUrl(
      baseUrl:BaseNetwork.cartItemsURL,
        requireMaintenance:fields.isMaintenance?'yes':'no',
        requireMonitoring:fields.isMonitoring?'yes':'no'
    );
    ApiResult result = await api!.apiConnectionMultipart<AddToCartResponseModel>(
      // BaseNetwork.cartItemsURL,
      url,
      BaseNetwork.getHeaderWithToken(token),// use token if required
      'post',
      addToCartResponseModelFromJson,
      fields:fields.cartItemRequest.toJson()//fields.toJson(),
    );
    return result;
  }

//getAllCartItems

  Future<ApiResult> getAllCartItems({required String status}) async {
    final token = await pref.getString(Keys.accessToken);
    final url = api!.generateUrl(
        baseUrl: BaseNetwork.allCartItemsUrl, status: status);
    ApiResult result = await api!.getApiConnection<CartItemListResponse>(
      url,
      BaseNetwork.getHeaderForLogin(), // use token if required
      cartItemListResponseFromJson,
    );
    return result;
  }
}

