import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../features/vendor/task/models/task_allocation_request_model.dart';
import '../../features/vendor/task/models/task_allocation_response_model.dart';

class TaskAllocationRepository {
  final ApiConnection api;

  TaskAllocationRepository({required this.api});

  /// ✅ Create a new task allocation
  Future<ApiResult> createTaskAllocation(TaskAllocationRequestModel request) async {
    return await api.apiConnection<TaskAllocationResponseModel>(
      BaseNetwork.taskAllocationUrl,         // ✅ API endpoint
      BaseNetwork.getJsonHeaders(),                // ✅ headers
      'post',                                      // ✅ method
      taskAllocationResponseModelFromJson,         // ✅ response parser
      body: request.toJson(),                      // ✅ request body
    );
  }
}
