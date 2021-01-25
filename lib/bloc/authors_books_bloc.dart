import 'package:rxdart/rxdart.dart';
import 'package:test_app/models/book_model/book_model.dart';
import 'package:test_app/models/book_model/book_response.dart';
import 'package:test_app/models/favourite_model/favourite_response.dart';
import 'package:test_app/repository/project_repo.dart';

//events
abstract class AuthorsBooksEvents {}

class AuthorsBooksInitialEvent extends AuthorsBooksEvents {
  final List<Data> book;
  AuthorsBooksInitialEvent(this.book);
}

class AuthorsBooksAddToFavouriteEvent extends AuthorsBooksEvents {
  final int bookId;
  final List<Data> book;
  AuthorsBooksAddToFavouriteEvent(this.bookId, this.book);
}

//states
abstract class AuthorsBooksStates {}

class AuthorsBooksInitialState extends AuthorsBooksStates {
  final List<Data> book;
  final List<Data> favBooks;
  AuthorsBooksInitialState({this.book, this.favBooks});
}

class AuthorsBooksAddToFavouriteState extends AuthorsBooksStates {}

class AuthorsBooksErrorState extends AuthorsBooksStates {}

class AuthorsBooksSuccessState extends AuthorsBooksStates {
  final int bookId;
  AuthorsBooksSuccessState(this.bookId);
}

//bloc
class AuthorsBooksBloc {
  BehaviorSubject<AuthorsBooksStates> _subject =
      BehaviorSubject<AuthorsBooksStates>();
  BehaviorSubject<AuthorsBooksStates> get subject => _subject;

  void mapEventToState(AuthorsBooksEvents event) async {
    switch (event.runtimeType) {
      case AuthorsBooksInitialEvent:
        AuthorsBooksInitialEvent authorsBooksInitialEvent = event;
        BookResponse bookResponse = await projectRepo.getFavBooks();
        _subject.sink.add(AuthorsBooksInitialState(
            book: authorsBooksInitialEvent.book,
            favBooks: bookResponse.bookModel.data));
        break;
      case AuthorsBooksAddToFavouriteEvent:
        AuthorsBooksAddToFavouriteEvent addToFavouriteEvent = event;
        FavouriteResponse favouriteResponse = await projectRepo.addToFavBooks(addToFavouriteEvent.bookId);
        if (favouriteResponse.error == "Error adding fav books" ||
            favouriteResponse.favouriteModel.data.status != "ok") {
          _subject.sink.add(AuthorsBooksErrorState());
        } else {
          mapEventToState(AuthorsBooksInitialEvent(addToFavouriteEvent.book));
        }
        break;
    }
  }

  dispose() {
    _subject?.close();
  }
}

final authorsBooksBloc = AuthorsBooksBloc();
