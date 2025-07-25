
import 'package:treelove/core/network/api_connection.dart';

import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../features/customer/retail/cart/model/cart_item_model.dart';

class CartRepository{
  final ApiConnection api;
  CartRepository(this.api);

  Future<ApiResult> addItemToCart({
    required Map<String, dynamic> fields,
  }) async {
    ApiResult result = await api.apiConnectionMultipart<AddToCartResponseModel>(
      BaseNetwork.cartItemsURL,
      BaseNetwork.getHeaderForLogin(), // use token if required
      'post',
      addToCartResponseModelFromJson,
      fields: fields,
    );
    if (result.status == ApiStatus.success) {
      // AddToCartResponseModel cart = result.response;
      return result;
    }
    return result;
  }

}

