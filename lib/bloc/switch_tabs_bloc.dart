import 'package:rxdart/rxdart.dart';

enum TabEvents {
  AUTHOR_LIST_EVENT,
  BOOK_LIST_EVENT,
  FAVOURITE_BOOKS_EVENT,
  ACCOUNT_EVENT,
  AUTHORS_BOOKS_EVENT
}

enum TabStates {
  AUTHOR_LIST_STATE,
  BOOK_LIST_STATE,
  FAVOURITE_BOOKS_STATE,
  ACCOUNT_STATE,
  AUTHORS_BOOKS_STATE
}

class SwitchTabsBloc {
  BehaviorSubject<TabStates> _subject = BehaviorSubject<TabStates>();
  BehaviorSubject<TabStates> get subject => _subject;

  TabStates defaultTab = TabStates.AUTHOR_LIST_STATE;

  void mapEventToState(TabEvents event) {
    switch (event) {
      case TabEvents.ACCOUNT_EVENT:
        _subject.sink.add(TabStates.ACCOUNT_STATE);
        break;
      case TabEvents.AUTHOR_LIST_EVENT:
        _subject.sink.add(TabStates.AUTHOR_LIST_STATE);
        break;
      case TabEvents.BOOK_LIST_EVENT:
        _subject.sink.add(TabStates.BOOK_LIST_STATE);
        break;
      case TabEvents.FAVOURITE_BOOKS_EVENT:
        _subject.sink.add(TabStates.FAVOURITE_BOOKS_STATE);
        break;
      case TabEvents.AUTHORS_BOOKS_EVENT:
        _subject.sink.add(TabStates.AUTHORS_BOOKS_STATE);
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final switchTabsBloc = SwitchTabsBloc();
