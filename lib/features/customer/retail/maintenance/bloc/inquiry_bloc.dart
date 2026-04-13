import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_event.dart';

import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/inquiries_repository.dart';
import '../../../../../core/network/base_network_status.dart';
import '../models/inquiry_model.dart';
import '../models/inquiry_request_model.dart';

class InquiryBloc extends Bloc<ApiEvent, ApiState<dynamic, ResponseModel>> {
  final InquiriesRepository repository;

  InquiryBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<InquiryRequestModel>>(_submitInquiry);
    on<ApiFetch>(_fetchInquiries);
  }

  Future<void> _fetchInquiries(
    ApiFetch event,
    Emitter<ApiState<dynamic, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());
    try {
      final result = await repository.getInquiries();
      switch (result.status) {
        case ApiStatus.success || ApiStatus.created:
          emit(ApiSuccess(result.response));
          break;
        default:
          emit(ApiFailure(ResponseModel(message: result.response ?? 'Failed to fetch inquiries.')));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'An error occurred while fetching inquiries.')));
    }
  }

  Future<void> _submitInquiry(
    ApiAdd<InquiryRequestModel> event,
    Emitter<ApiState<dynamic, ResponseModel>> emit,
  ) async {
    emit(ApiLoading());
    try {
      final result = await repository.postInquiries(event.data);
      switch (result.status) {
        case ApiStatus.success || ApiStatus.created :
          emit(ApiSuccess(result.response));
          break;
        default:
          emit(ApiFailure(result.response));
      }
    } catch (e) {
      emit(ApiFailure(ResponseModel(message: 'Failed to Submit Inquiry.')));
    }
  }
}