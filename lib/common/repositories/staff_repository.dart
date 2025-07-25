import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/vendor/Staff/models/staff_request_model.dart';
import '../../features/vendor/Staff/models/staff_response_model.dart';
import '../models/response.mode.dart';

class StaffRepository {
   final ApiConnection  api;

  StaffRepository({required this.api});

  Future<ApiResult> createStaff(AddStaffRequestModel request) async {
    final pref = SecurePreference();
    final token = await pref.getString(Keys.accessToken);  // fetch once async
    ApiResult result = await api.apiConnectionMultipart<StaffResponseModel>(
        BaseNetwork.staffCreationUrl,
        BaseNetwork.getHeaderWithToken(token),
        'post',
        staffResponseModelFromJson,
        fields: request.toFields(),
        files: request.getFiles()
    );
    if (result.status == ApiStatus.success) {
      return result;
    }
    return result;
  }

   ///  Fetch Staff List
   Future<ApiResult> fetchStaffList({int page = 1, int pageSize = 20, String? search}) async {
     // Fetch token once
     final pref = SecurePreference();
     final token = await pref.getString(Keys.accessToken);

     // Build query params
     final queryParams = {
       "page": page.toString(),
       "page_size": pageSize.toString(),
       if (search != null && search.isNotEmpty) "search": search,
     };

     // Call API
     ApiResult result = await api.getApiConnection<StaffListResponseModel>(
       BaseNetwork.staffCreationUrl,
       BaseNetwork.getJsonHeadersWithToken(token), // ✅ Pass token
       //
       staffListResponseModelFromJson,        // ✅ Parse JSON into model
     );

     return result;
   }

   /// Staff Suspend
   Future<ApiResult> suspendStaff({required String userId}) async {
     final pref = SecurePreference();
     final token = await pref.getString(Keys.accessToken);
     final url = "${BaseNetwork.staffListUrl}$userId/suspend/";
     ApiResult result = await api.apiConnectionMultipart<ResponseModel>(
         url,
         BaseNetwork.getHeaderWithToken(token),
         'post',
         responseModelFromJson,
     );
     return result;
   }
  /// staff Activate
}
