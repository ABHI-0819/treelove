
import 'package:treelove/common/models/response.mode.dart';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../features/authentication/models/otp_send_request.dart';
import '../../features/authentication/models/otp_verify_request.dart';
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

   /// -------------------------------
  /// SEND / RESEND OTP
  /// -------------------------------
  Future<ApiResult> sendOtp({
    required OtpSendRequest request,
  }) async {
    return await api!.apiConnectionMultipart<ResponseModel>(
      BaseNetwork.sendOtpURL,
      BaseNetwork.getMultipartHeaders(),
      'post',
      responseModelFromJson,
      fields: request.toMultipart()
    );
  }

  /// -------------------------------
  /// VERIFY OTP
  /// -------------------------------
  Future<ApiResult> verifyOtp({
    required OtpVerifyRequest request,
  }) async {
    return await api!.apiConnectionMultipart<ResponseModel>(
      BaseNetwork.verifyOtpURL,
      BaseNetwork.getMultipartHeaders(),
      'post',
      responseModelFromJson,
      fields: request.toMultipart()
    );
  }
}
