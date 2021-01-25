import 'package:rxdart/rxdart.dart';
import 'package:test_app/models/author_model/author_model.dart';
import 'package:test_app/models/author_model/author_response.dart';
import 'package:test_app/models/book_model/book_model.dart';
import 'package:test_app/models/book_model/book_response.dart';
import 'package:test_app/repository/project_repo.dart';

//events
enum AuthorEvents { INITIAL_EVENT }

//states
abstract class AuthorStates {}

class AuthorInitialState extends AuthorStates {
  final AuthorModel authorModel;
  final BookModel bookModel;
  AuthorInitialState({this.bookModel, this.authorModel});
}

class AuthorErrorState extends AuthorStates {}

//bloc
class AuthorBloc {
  BehaviorSubject<AuthorStates> _subject =
      BehaviorSubject<AuthorStates>();
  BehaviorSubject<AuthorStates> get subject => _subject;

  void mapEventToState(AuthorEvents event) async {
    if (event == AuthorEvents.INITIAL_EVENT) {
      AuthorResponse authorResponse = await projectRepo.getAuthors();
      BookResponse bookResponse = await projectRepo.getBooks();
      if (authorResponse.error == "Error getting authors" || bookResponse.error=="Error getting books") {
        _subject.sink.add(AuthorErrorState());
      } else {
        _subject.sink
            .add(AuthorInitialState(authorModel: authorResponse.authorModel,bookModel: bookResponse.bookModel));
      }
    }
  }

  void dispose() {
    _subject?.close();
  }

}

final authorBloc = AuthorBloc();
