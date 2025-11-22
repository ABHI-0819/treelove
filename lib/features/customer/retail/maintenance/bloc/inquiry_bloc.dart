import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/inquiries_repository.dart';
import 'package:treelove/features/customer/retail/maintenance/models/inquiry_request_model.dart';
import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/base_network_status.dart';


class InquiryBloc extends Bloc<ApiEvent, ApiState<ResponseModel, ResponseModel>> {
  final InquiriesRepository repository;

  InquiryBloc(this.repository) : super(ApiInitial()) {
    on<ApiAdd<InquiryRequestModel>>(_submitInquiry);
  }

  Future<void> _submitInquiry(
      ApiAdd<InquiryRequestModel> event,
      Emitter<ApiState<ResponseModel, ResponseModel>> emit,
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