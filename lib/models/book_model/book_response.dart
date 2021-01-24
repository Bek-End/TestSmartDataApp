import 'package:test_app/models/book_model/book_model.dart';

class BookResponse {
  final BookModel bookModel;
  final String error;

  BookResponse(this.bookModel, this.error);

  BookResponse.fromJson(var json)
      : bookModel = BookModel.fromJson(json),
        error = "";

  BookResponse.withError(String errorValue)
      : bookModel = BookModel(),
        error = errorValue;
}
