import 'package:flutter/foundation.dart';

class BaseNetwork {
  static BaseNetwork _baseNetwork = BaseNetwork._internal();


  BaseNetwork._internal();
  factory BaseNetwork() {
    return _baseNetwork;
  }
  //202.189.224.222:9071 Internal Server



  static const String _BASE_URL_Release = "";
  static const String _BASE_URL_Debug = "";
  static const String BASE_URL_IMAGE ="";




  /*
  static const String _BASE_URL_Release = "http://202.189.224.222:9071/";
  static const String _BASE_URL_Debug = "http://202.189.224.222:9071/";
  static const String BASE_URL_IMAGE ="http://202.189.224.222:9071";
   */


  static const String _BASE_URL = kDebugMode ? _BASE_URL_Debug : _BASE_URL_Release;

  static const String FailedMessage = 'Connection Failed, Please try Again';
  static const String NetworkError= 'Oh no! Something went wrong';

  //http://10.202.100.187:9004/swagger/

  static Map<String, String> getJsonHeaders() {
    return {
      'content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Map<String, String> getHeaderForLogin() {
    return {"Content-Type": "application/x-www-form-urlencoded", "accept": "application/json"};
  }

  static Map<String, String> getJsonHeaderForLogin() {
    return {"Content-Type": "application/json", "accept": "application/json"};
  }

}