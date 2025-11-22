import 'dart:io';

import 'package:treelove/common/models/response.mode.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/logger.dart';
import '../../features/authentication/models/register_request_model.dart';

class SignInRepository{
  final ApiConnection ? api;
  SignInRepository({this.api});

  Future<ApiResult> addSignInRecord({required RegistrationRequest request}) async {
    return await api!.apiConnectionMultipart<ResponseModel>(
        BaseNetwork.normalRegisterUrl,
        BaseNetwork.getMultipartHeaders(),
        'post',
        responseModelFromJson,
        fields: request.toMultipart(),
        fileKey: 'profile_picture',
        files: request.profilePicture != null ? [request.profilePicture!] : [],
        isLogIn: true
    );
  }
}