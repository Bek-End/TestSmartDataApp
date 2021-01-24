import 'package:test_app/models/author_model/author_model.dart';

class AuthorResponse {
  final AuthorModel authorModel;
  final String error;

  AuthorResponse(this.authorModel, this.error);

  AuthorResponse.fromJson(var json)
      : authorModel = AuthorModel.fromJson(json),
        error = "";

  AuthorResponse.withError(String errorValue)
      : authorModel = AuthorModel(),
        error = errorValue;
}
