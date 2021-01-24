import 'package:test_app/models/login_model/login_model.dart';

class LoginResponse{
  final LoginModel loginModel;
  final String error;

  LoginResponse({this.loginModel, this.error});

  LoginResponse.fromjson(var json):loginModel=LoginModel.fromJson(json),error="";

  LoginResponse.withError(String errorValue):loginModel=LoginModel(),error=errorValue;
  
}