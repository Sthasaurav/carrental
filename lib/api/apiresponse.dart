import 'package:firebase_2/api/networkstatus.dart';

class ApiResponse {
  dynamic data;
  String? errorMessage;
  NetworkStatus? networkStatus;
  ApiResponse({this.data, this.errorMessage, this.networkStatus});
}
