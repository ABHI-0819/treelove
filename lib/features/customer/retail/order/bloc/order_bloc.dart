import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/order_repository.dart';
import 'package:treelove/features/customer/retail/order/models/order_list_response.dart';
import 'package:treelove/features/customer/retail/order/models/order_place_request.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/base_network_status.dart';
import '../../../../../core/utils/logger.dart';
import '../models/order_place_response.dart';
import '../models/order_tracking_response.dart';

class OrderPlaceBloc extends Bloc<ApiEvent, ApiState<OrderPlacedResponse, ResponseModel>> {
  final OrderRepository repository;

  OrderPlaceBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<OrderPlaceRequest>>(_onMakeOrder); // We'll pass a `Map<String, dynamic>` for form data
  }

  Future<void> _onMakeOrder(
      ApiAdd<OrderPlaceRequest> event,
      Emitter<ApiState<OrderPlacedResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.makeOrder(fields: event.data);
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
    } catch (e,stackTrace) {
      debugLog(e.toString(),name: "Ma ka Bhosda..",stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong')));
    }
  }


}

class OrderListBloc extends Bloc<ApiEvent, ApiState<OrderListResponse, ResponseModel>> {
  final OrderRepository repository;

  OrderListBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_onFetchTreeSpecies);
  }

  Future<void> _onFetchTreeSpecies(
      ApiListFetch event,
      Emitter<ApiState<OrderListResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchOrders();
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
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}


class OrderTrackerBloc extends Bloc<ApiEvent, ApiState<OrderTrackingResponse, ResponseModel>> {
  final OrderRepository repository;

  OrderTrackerBloc(this.repository) : super(ApiInitial()) {
    on<ApiFetch>(_onGetOrderTracking);
  }

  Future<void> _onGetOrderTracking(
      ApiFetch event,
      Emitter<ApiState<OrderTrackingResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.fetchOrderTracking(orderId: event.orderId!);
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
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e, stackTrace) {
      // You might have a debugLog function here for error logging
      // debugLog(e.toString(), stackTrace: stackTrace);
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}