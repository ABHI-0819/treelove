import 'package:flutter/foundation.dart';

import '../storage/preference_keys.dart';
import '../storage/secure_storage.dart';

class BaseNetwork {
  static BaseNetwork _baseNetwork = BaseNetwork._internal();


  BaseNetwork._internal();
  factory BaseNetwork() {
    return _baseNetwork;
  }

  //202.189.224.222:9071 Internal Server
  static const String _BASE_URL_Release = "http://43.205.169.130/";
  static const String _BASE_URL_Debug = "http://43.205.169.130/";
  static const String _BASE_URL = kDebugMode ? _BASE_URL_Debug : _BASE_URL_Release;


  static const String FailedMessage = 'Connection Failed, Please try Again';
  static const String NetworkError= 'Oh no! Something went wrong';

  static const String loginURL = "${_BASE_URL}api/v1/auth/login/";
  static const String loginOAuthURL = "${_BASE_URL}api/v1/auth/oidc/login/";
  static const String refreshTokenURL = "${_BASE_URL}api/v1/auth/token/refresh/";
  static const String logoutURL = "${_BASE_URL}api/v1/auth/logout/";
  static const String servicesURL = "${_BASE_URL}api/v1/projects/service-types/";

  static const String projectListURL = "${_BASE_URL}api/v1/projects/projects/";
  static const String projectDashboardURL = "${_BASE_URL}api/v1/projects/vendor-dashboard/";



  //TODO: Retailer URL :
  static const String treeSpeciesURL = "${_BASE_URL}api/v1/trees/tree-species/";
  static const String cartItemsURL = "${_BASE_URL}api/v1/orders/order-items/";
  ///orders/order-items/
  static const String paymentURL ="${_BASE_URL}api/v1/payments/payments/";


  //TODO: Fieldworker URL :
  static const String plantationCreateURL= "${_BASE_URL}api/v1/survey/plantation/";
  static const String maintenanceAddURL="${_BASE_URL}api/v1/survey/plantation/";

  //TODO: Vendor URL :
  static const String taskAllocationUrl = "${_BASE_URL}api/v1/projects/fieldworker-assignments/";
  static const String staffCreationUrl = "${_BASE_URL}api/v1/auth/vendor/fieldworkers/";
  static const String staffListUrl = "${_BASE_URL}api/v1/auth/vendor/fieldworkers/";


  //http://10.202.100.187:9004/swagger/

  static Map<String, String> getJsonHeaders() {
    return {
      'content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Map<String, String> getJsonHeadersWithToken(String token) {
    return {
      'content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token",
    };
  }


  static Map<String, String> getHeaderForLogin() {
    return {"Content-Type": "application/x-www-form-urlencoded", "accept": "application/json"};
  }

  /// ✅ For authenticated APIs (token required)
  static Map<String, String> getHeaderWithToken(String token) {
    return {
      "Content-Type": "application/x-www-form-urlencoded",
      "accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }



  static Map<String, String> getJsonHeaderForLogin() {
    return {"Content-Type": "application/json", "accept": "application/json"};
  }

}