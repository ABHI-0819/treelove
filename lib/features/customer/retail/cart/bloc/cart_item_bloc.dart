import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/core/utils/logger.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/cart_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../model/cart_item_list_model.dart';
import '../model/cart_item_model.dart';
import '../model/cart_item_update_request_model.dart';
import '../model/cart_request_model.dart';

class CartBloc extends Bloc<ApiEvent, ApiState<AddToCartResponseModel, ResponseModel>> {
  final CartRepository repository;

  CartBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<CartRequestDetail>>(_onAddToCart); // We'll pass a `Map<String, dynamic>` for form data
  }

  Future<void> _onAddToCart(
      ApiAdd<CartRequestDetail> event,
      Emitter<ApiState<AddToCartResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.addItemToCart(fields: event.data);
      switch (result.status) {
        case ApiStatus.success || ApiStatus.created:
          emit(ApiSuccess(result.response));
          break;
        // case ApiStatus.refreshTokenExpired:
        //   emit(TokenExpired(result.response)); // 🚀 go to SignIn
        //   break;
        // case ApiStatus.unAuthorized:
        //   emit(ApiFailure(ResponseModel(
        //     message: "Unauthorized access. Please login again.",
        //   )));
        //   break;
        case ApiStatus.failed:
          emit(ApiFailure(result.response));
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e,stackTrace) {
      debugLog(e.toString(),name: "Ma ka Bhosda..",stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong')));
    }
  }


}

class CartItemListBloc extends Bloc<ApiEvent, ApiState<CartItemListResponse, ResponseModel>> {
  final CartRepository repository;

  CartItemListBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onGetCartItems); // We'll pass a `Map<String, dynamic>` for form data
  }

  Future<void> _onGetCartItems(
      ApiListFetch event,
      Emitter<ApiState<CartItemListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.getAllCartItems(status: 'pending');
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response)); // 🚀 go to SignIn
          break;
        case ApiStatus.unAuthorized:
          emit(ApiFailure(ResponseModel(
            message: "Unauthorized access. Please login again.",
          )));
          break;
        case ApiStatus.failed:
          emit(ApiFailure(result.response));
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      debugLog(e.toString(), name: "Error fetching cart items", stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong')));
    }
  }


}

class CartUpdateBloc extends Bloc<ApiEvent, ApiState<ResponseModel, ResponseModel>> {
  final CartRepository repository;

  CartUpdateBloc(this.repository) : super(ApiInitial()) {
    on<ApiUpdate<CartItemUpdateRequestModel>>(_onUpdateCartItem);
  }

  Future<void> _onUpdateCartItem(
    ApiUpdate<CartItemUpdateRequestModel> event,
    Emitter<ApiState<ResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());

    try {
      final result =
          await repository.updateCartItem(request: event.data);

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;

        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response));
          break;

        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, st) {
      debugLog(e.toString(),
          name: "UpdateCartItemError", stackTrace: st);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong')));
    }
  }
}

class CartRemoveBloc
    extends Bloc<ApiEvent, ApiState<ResponseModel, ResponseModel>> {
  final CartRepository repository;

  CartRemoveBloc(this.repository) : super(ApiInitial()) {
    on<ApiDelete>(_onRemoveCartItem);
  }

  Future<void> _onRemoveCartItem(
    ApiDelete event,
    Emitter<ApiState<ResponseModel, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());

    try {
      final result =
          await repository.removeCartItme(cartId: event.id.toString());

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiDeleteSuccess(result.response));
          break;

        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response));
          break;

        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, st) {
      debugLog(e.toString(),
          name: "RemoveCartItemError", stackTrace: st);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong')));
    }
  }
}
