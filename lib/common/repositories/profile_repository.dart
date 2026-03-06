import 'package:treelove/core/network/base_network.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network_status.dart';
import '../models/profile_response_model.dart';
import '../models/update_profile_request_model.dart';

class ProfileRepository {
  final ApiConnection api;

  ProfileRepository({required this.api});

  // Add methods for profile-related API calls here
  Future<ApiResult> fetchUserProfile() async {
    return await api.getApiConnection(
      BaseNetwork.profileURL,
      BaseNetwork.getMultipartHeaders(), // headers if needed
      profileResponseModelFromJson, // parse response as needed
    );
  }

  Future<ApiResult> updateUserProfile(UpdateProfileRequest request) async {
    return await api.patchApiConnectionMultipart(
      BaseNetwork.profileURL,
      BaseNetwork.getMultipartHeaders(), // headers if needed
      fields: request.toJson(),
      profileResponseModelFromJson, // parse response as needed
      fileKey: "profile_picture",
      files: request.media,
    );
  }
}


