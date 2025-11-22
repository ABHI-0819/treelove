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
  static const String BASE_Image_URL ="http://43.205.169.130/";
  static const String BASE_Share_URL = 'http://43.205.169.130';

  static const String loginURL = "${_BASE_URL}api/v1/auth/login/";
  static const String loginOAuthURL = "${_BASE_URL}api/v1/auth/oidc/login/";
  static const String normalRegisterUrl = "${_BASE_URL}api/v1/auth/register/complete/";
  static const String refreshTokenURL = "${_BASE_URL}api/v1/auth/token/refresh/";
  static const String logoutURL = "${_BASE_URL}api/v1/auth/logout/";
  static const String servicesURL = "${_BASE_URL}api/v1/projects/service-types/";

  static const String projectListURL = "${_BASE_URL}api/v1/projects/projects/";
  static const String projectDashboardURL = "${_BASE_URL}api/v1/projects/vendor-dashboard/";
  static const String projectAreaURL =  "${_BASE_URL}api/v1/projects/project-areas/";


  static const String treeDiseasesURL = "${_BASE_URL}api/v1/trees/tree-diseases/";

  //TODO: Retailer URL :
  static const String treeSpeciesURL = "${_BASE_URL}api/v1/trees/tree-species/";
  static const String cartItemsURL = "${_BASE_URL}api/v1/orders/order-items/";
  static const String allCartItemsUrl ="${_BASE_URL}api/v1/orders/order-items/cart-items/";
  static const String orderPlaceUrl = "${_BASE_URL}api/v1/orders/orders/";
  static const String orderTrackingUrl = "${_BASE_URL}api/v1/orders/order-tracking/";
  static const String grievanceCreateURL = "${_BASE_URL}api/v1/grievance/";
  static const String grievanceCategoriesURL = "${_BASE_URL}api/v1/grievance/grievance-categories/";
  ///orders/order-items
  static const String paymentURL ="${_BASE_URL}api/v1/payments/payments/";
  static const String inquiryUrl = "${_BASE_URL}api/v1/inquiries/";


  //TODO: Fieldworker URL :
  static const String plantationListURL = "${_BASE_URL}api/v1/survey/plantation/";
  static const String plantationCreateURL= "${_BASE_URL}api/v1/survey/plantation/";
  static const String maintenanceCreatedURL="${_BASE_URL}api/v1/survey/maintenance/";
  static const String monitorCreatedURL ="${_BASE_URL}api/v1/survey/monitoring/";
  static const String monitorAddURL ="${_BASE_URL}api/v1/survey/plantation/";
  static const String projectAreasURl = "${_BASE_URL}api/v1/projects/project-areas/";
  static const String satelliteMonitorResultUrl = "${_BASE_URL}api/v1/survey/satellite-monitoring/";
  //http://43.205.169.130/api/v1/projects/fieldworker-dashboard/
  static const String fieldworkerDashboardUrl = "${_BASE_URL}api/v1/projects/fieldworker-dashboard/";

  //TODO: Vendor URL :
  static const String taskAllocationUrl = "${_BASE_URL}api/v1/projects/fieldworker-assignments/";
  static const String staffCreationUrl = "${_BASE_URL}api/v1/auth/vendor/fieldworkers/";
  static const String staffListUrl = "${_BASE_URL}api/v1/auth/vendor/fieldworkers/";
  static const String serviceDetailUrl = "${_BASE_URL}api/v1/projects/service-detail/";


  //TODO: B2B URL:
  static const String b2bDashboardUrl = "${_BASE_URL}api/v1/projects/client/home-dashboard/";
  static const String b2bProjectDashboardURL = "${_BASE_URL}api/v1/projects/client-dashboard/";
  static const String maintenanceActivityUrl ="${_BASE_URL}api/v1/survey/maintenance-activity/";

  static const String notificationUrl =  "${_BASE_URL}api/v1/notifications/device-tokens/register/";
  static const String notificationsListUrl ="${_BASE_URL}api/v1/notifications/";

  //http://10.202.100.187:9004/swagger/
/*
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

 */
  /// ✅ Standard JSON headers (for all authenticated API calls)
  /// Token is added automatically by ApiConnection
  static Map<String, String> getJsonHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// ✅ Form-urlencoded headers (for token refresh)
  static Map<String, String> getHeaderForLogin() {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };
  }

  /// ✅ Multipart headers (for file uploads)
  /// ⚠️ DO NOT set Content-Type - http package sets it automatically with boundary
  static Map<String, String> getMultipartHeaders() {
    return {
      'Accept': 'application/json',
    };
  }

  /// ✅ JSON headers for login/signup (no token required)
  static Map<String, String> getJsonHeaderForLogin() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

}