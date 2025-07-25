import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/cart_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../model/cart_item_model.dart';

class CartBloc extends Bloc<ApiEvent, ApiState<AddToCartResponseModel, ResponseModel>> {
  final CartRepository repository;

  CartBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<Map<String, dynamic>>>(_onAddToCart); // We'll pass a `Map<String, dynamic>` for form data
  }

  Future<void> _onAddToCart(
      ApiAdd<Map<String, dynamic>> event,
      Emitter<ApiState<AddToCartResponseModel, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());

    try {
      final result = await repository.addItemToCart(fields: event.data);
      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(TokenExpired(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Something went wrong')));
    }
  }
}
