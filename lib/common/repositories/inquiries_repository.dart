import 'package:treelove/common/models/response.mode.dart';
import 'package:treelove/features/customer/retail/maintenance/models/inquiry_request_model.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/utils/logger.dart';
import '../../features/customer/retail/maintenance/models/inquiry_model.dart';

class InquiriesRepository{
  final ApiConnection ? api;

  InquiriesRepository({this.api});

  /// Submit a new inquiry
  Future<ApiResult> postInquiries(InquiryRequestModel request) async {
    debugLog(request.toJsonString(), name: "Inquiries Request");

    return await api!.apiConnectionMultipart<ResponseModel>(
      BaseNetwork.inquiryUrl,
      BaseNetwork.getMultipartHeaders(),// e.g., '/api/grievances/'
      'post',
      responseModelFromJson,            // your deserializer
      fields: request.toFields(), // List<XFile>?
    );
  }

  /// Get list of inquiries
  Future<ApiResult> getInquiries() async {
    return await api!.getApiConnection<InquiryListResponse>(
      BaseNetwork.inquiryUrl,
      BaseNetwork.getJsonHeaders(),
      inquiryListResponseFromJson,
    );
  }
}