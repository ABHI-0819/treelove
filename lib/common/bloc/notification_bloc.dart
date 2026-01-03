import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/bloc/api_state.dart';
import '../../core/network/base_network_status.dart';
import '../../core/utils/logger.dart';
import '../models/notifications_response_model.dart';
import '../models/response.mode.dart';
import '../repositories/notification_repository.dart';


class NotificationBloc extends Bloc<ApiEvent, ApiState<NotificationResponse, ResponseModel>> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(ApiInitial()) {
    on<ApiListFetch>(_fetchNotifications);
  }

  Future<void> _fetchNotifications(
      ApiListFetch event,
      Emitter<ApiState<NotificationResponse, ResponseModel>> emit,
      ) async {
    emit(ApiLoading());
    try {
      debugLog("Fetching notifications...", name: "NotificationBloc");

      final result = await repository.fetchNotifications();

      switch (result.status) {
        case ApiStatus.success:
          emit(ApiSuccess(result.response));
          break;
        case ApiStatus.refreshTokenExpired:
          emit(TokenExpired(result.response));
          break;
        case ApiStatus.unAuthorized:
          emit(ApiFailure(ResponseModel(
            message: "Unauthorized access. Please login again.",
          )));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      debugLog("Error fetching notifications: $e", name: "NotificationBloc");
      emit(ApiFailure(ResponseModel(message: 'Something went wrong.')));
    }
  }
}