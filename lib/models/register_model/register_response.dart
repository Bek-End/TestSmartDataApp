import 'package:test_app/models/register_model/register_model.dart';

class RegisterResponse{

  final RegisterModel registerModel;
  final String error;

  RegisterResponse({this.registerModel, this.error});

  RegisterResponse.fromJson(var json):registerModel=RegisterModel.fromJson(json),error="";

  RegisterResponse.withError(String errorValue):registerModel=RegisterModel(),error=errorValue;

}