import 'package:rxdart/rxdart.dart';

enum AuthorsBooksScreenEvents {
  AUTHORS_SCREEN_EVENT,
  AUTHORS_BOOKS_SCREEN_EVENT
}

enum AuthorsBooksScreenStates {
  AUTHORS_SCREEN_STATE,
  AUTHORS_BOOKS_SCREEN_STATE
}

class SwitchAuthorsBooksScreenBloc {
  BehaviorSubject<AuthorsBooksScreenStates> _subject =
      BehaviorSubject<AuthorsBooksScreenStates>();
  BehaviorSubject<AuthorsBooksScreenStates> get subject => _subject;

  AuthorsBooksScreenStates defaultScreen = AuthorsBooksScreenStates.AUTHORS_SCREEN_STATE;

  void mapEventToState(AuthorsBooksScreenEvents event) {
    switch (event) {
      case AuthorsBooksScreenEvents.AUTHORS_SCREEN_EVENT:
        _subject.sink.add(AuthorsBooksScreenStates.AUTHORS_SCREEN_STATE);
        break;
      case AuthorsBooksScreenEvents.AUTHORS_BOOKS_SCREEN_EVENT:
        _subject.sink.add(AuthorsBooksScreenStates.AUTHORS_BOOKS_SCREEN_STATE);
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final switchAuthorsBooksScreenBloc = SwitchAuthorsBooksScreenBloc();
