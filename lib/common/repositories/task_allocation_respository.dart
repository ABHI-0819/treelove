import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/preference_keys.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/vendor/task/models/task_allocation_request_model.dart';
import '../../features/vendor/task/models/task_allocation_response_model.dart';

class TaskAllocationRepository {
  final ApiConnection api;
  final pref = SecurePreference();
  TaskAllocationRepository({required this.api});

  /// ✅ Create a new task allocation
  Future<ApiResult> createTaskAllocation(TaskAllocationRequestModel request) async {
    final token = await pref.getString(Keys.accessToken);
    return await api.apiConnectionMultipart<TaskAllocationResponseModel>(
      BaseNetwork.taskAllocationUrl,         // ✅ API endpoint
      // BaseNetwork.getHeaderWithToken(token),                // ✅ headers
      BaseNetwork.getMultipartHeaders(),
      'post',                                      // ✅ method
      taskAllocationResponseModelFromJson,         // ✅ response parser
      fields: request.toJson(),                      // ✅ request body
    );
  }
}
