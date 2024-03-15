import 'package:firebase_2/api/status_util.dart';

class ApiResponse{
  dynamic data;
  NetworkStatus? networkStatus;
  String? errormessage;
  ApiResponse({this.data,this.errormessage,this.networkStatus});
}