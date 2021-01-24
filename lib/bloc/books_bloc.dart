import 'package:rxdart/subjects.dart';
import 'package:test_app/models/book_model/book_model.dart';
import 'package:test_app/models/book_model/book_response.dart';
import 'package:test_app/models/favourite_model/favourite_response.dart';
import 'package:test_app/repository/project_repo.dart';

//events
abstract class BooksEvents {}

class BooksInitialEvent extends BooksEvents {}

class BooksAddToFavsEvent extends BooksEvents {
  final int bookId;

  BooksAddToFavsEvent({this.bookId});
}

//states
abstract class BooksStates {}

class BooksInitialState extends BooksStates {
  final List<Data> books;
  final List<Data> favBooks;
  BooksInitialState({this.books, this.favBooks});
}

class BooksAddToFavsState extends BooksStates {
  final List<Data> books;
  final List<Data> favBooks;
  BooksAddToFavsState({this.books, this.favBooks});
}

class BooksLoadingState extends BooksStates {}

class BooksErrorState extends BooksStates {}

//bloc
class BooksBloc {
  BehaviorSubject<BooksStates> _subject = BehaviorSubject<BooksStates>();
  BehaviorSubject<BooksStates> get subject => _subject;

  BooksStates defaultState = BooksLoadingState();

  void mapEventToState(BooksEvents event) async {
    switch (event.runtimeType) {
      case BooksInitialEvent:
        _subject.sink.add(BooksLoadingState());
        BookResponse bookResponse = await projectRepo.getBooks();
        BookResponse favBooksResponse = await projectRepo.getFavBooks();
        _subject.sink.add(BooksInitialState(
            books: bookResponse.bookModel.data,
            favBooks: favBooksResponse.bookModel.data));
        break;
      case BooksAddToFavsEvent:
        _subject.sink.add(BooksLoadingState());
        BooksAddToFavsEvent addToFavouriteEvent = event;
        FavouriteResponse favouriteResponse =
            await projectRepo.addToFavBooks(addToFavouriteEvent.bookId);
        BookResponse favBooksResponse = await projectRepo.getFavBooks();
        BookResponse bookResponse = await projectRepo.getBooks();
        if (favouriteResponse.error == "Error adding fav books" ||
            favouriteResponse.favouriteModel.data.status != "ok") {
          _subject.sink.add(BooksErrorState());
        } else {
          _subject.sink.add(BooksAddToFavsState(
              books: bookResponse.bookModel.data,
              favBooks: favBooksResponse.bookModel.data));
        }
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final booksBloc = BooksBloc();
