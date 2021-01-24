
import 'package:rxdart/rxdart.dart';
import 'package:test_app/models/book_model/book_model.dart';
import 'package:test_app/models/book_model/book_response.dart';
import 'package:test_app/models/favourite_model/favourite_response.dart';
import 'package:test_app/repository/project_repo.dart';
//events
abstract class FavouriteEvents {}

class FavouriteInitialEvent extends FavouriteEvents {}

class FavouriteRemoveEvent extends FavouriteEvents {
  final int bookId;
  FavouriteRemoveEvent({this.bookId});
}

//states
abstract class FavouriteStates {}

class FavouriteInitialState extends FavouriteStates {
  final List<Data> favBooks;
  FavouriteInitialState({this.favBooks});
}

class FavouriteRemoveState extends FavouriteStates {
  final List<Data> favBooks;
  FavouriteRemoveState({this.favBooks});
}

class FavouriteLoadingState extends FavouriteStates {}

class FavouriteErrorState extends FavouriteStates {}

//bloc
class FavouriteBloc {
  BehaviorSubject<FavouriteStates> _subject =
      BehaviorSubject<FavouriteStates>();
  BehaviorSubject<FavouriteStates> get subject => _subject;

  FavouriteStates defaultState = FavouriteLoadingState();

  void mapEventToState(FavouriteEvents event) async {
    switch (event.runtimeType) {
      case FavouriteInitialEvent:
        _subject.sink.add(FavouriteLoadingState());
        BookResponse favouriteResponse = await projectRepo.getFavBooks();
        _subject.sink.add(
            FavouriteInitialState(favBooks: favouriteResponse.bookModel.data));
        break;
      case FavouriteRemoveEvent:
        _subject.sink.add(FavouriteLoadingState());
        FavouriteRemoveEvent removeEvent = event;
        FavouriteResponse favouriteResponse =
            await projectRepo.removeFromFavs(removeEvent.bookId);
        BookResponse bookResponse = await projectRepo.getFavBooks();
        if (favouriteResponse.error == "Error removing fav books" ||
            favouriteResponse.favouriteModel.data.status != "ok") {
          _subject.sink.add(FavouriteErrorState());
        } else {
          _subject.sink
              .add(FavouriteRemoveState(favBooks: bookResponse.bookModel.data));
        }
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final favouriteBloc = FavouriteBloc();
