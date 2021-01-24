import 'package:test_app/models/favourite_model/favourite_model.dart';

class FavouriteResponse{
  final FavouriteModel favouriteModel;
  final String error;

  FavouriteResponse(this.favouriteModel, this.error);

  FavouriteResponse.fromJson(var json):favouriteModel=FavouriteModel.fromJson(json),error="";

  FavouriteResponse.withError(String errorValue):favouriteModel=FavouriteModel(),error=errorValue;
}