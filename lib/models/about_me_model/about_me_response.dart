import 'package:test_app/models/about_me_model/about_me_model.dart';

class AboutMeResponse{
  final AboutMeModel aboutMeModel;
  final String error;

  AboutMeResponse(this.aboutMeModel, this.error);

  AboutMeResponse.fromjson(var json):aboutMeModel = AboutMeModel.fromJson(json),error="";

  AboutMeResponse.withError(String errorValue): aboutMeModel=AboutMeModel(),error=errorValue;
}