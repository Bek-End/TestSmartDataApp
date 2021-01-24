import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:test_app/bloc/switch_tabs_bloc.dart';
import 'package:test_app/bloc/theme_bloc.dart';
import 'package:test_app/screens/tabs/account_screen.dart';
import 'package:test_app/screens/tabs/author_list_screen.dart';
import 'package:test_app/screens/tabs/authors_books_screen.dart';
import 'package:test_app/screens/tabs/book_list_screen.dart';
import 'package:test_app/screens/tabs/favourite_books_list.dart';

class FrontPageScreen extends StatefulWidget {
  @override
  _FrontPageScreenState createState() => _FrontPageScreenState();
}

class _FrontPageScreenState extends State<FrontPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: switchTabsBloc.subject.stream,
          initialData: switchTabsBloc.defaultTab,
          builder: (BuildContext context, AsyncSnapshot<TabStates> snapshot) {
            switch (snapshot.data) {
              case TabStates.ACCOUNT_STATE:
                return AccountScreen();
              case TabStates.AUTHOR_LIST_STATE:
                return AuthorListScreen();
              case TabStates.BOOK_LIST_STATE:
                return BookListScreen();
              case TabStates.FAVOURITE_BOOKS_STATE:
                return FavouriteBooksListScreen();
              case TabStates.AUTHORS_BOOKS_STATE:
                return AuthorsBooksScreen();
              default:
                return Container(
                  child: Center(
                    child: Text("Tab error"),
                  ),
                );
            }
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: switchTabsBloc.subject.stream,
        initialData: switchTabsBloc.defaultTab,
        builder: (BuildContext context, AsyncSnapshot<TabStates> snapshot) {
          TabStates tabStates = snapshot.data;
          return StreamBuilder(
              stream: themeBloc.subject.stream,
              initialData: themeBloc.defaultState,
              builder: (context, AsyncSnapshot<ThemeState> snapshot) {
                ThemeState themeState = snapshot.data;
                return Theme(
                  data: Theme.of(context).copyWith(
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: (themeState.runtimeType == DarkState)?Color(0xFF212121):Colors.grey,
                    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                    primaryColor: Colors.white54,
                    // textTheme: Theme.of(context)
                    //     .textTheme
                    //     .copyWith(caption: new TextStyle(color: Colors.yellow))),
                  ),
                  child: BottomNavigationBar(
                      iconSize: 20,
                      unselectedFontSize: 9.5,
                      selectedFontSize: 9.5,
                      type: BottomNavigationBarType.shifting,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      currentIndex: tabStates.index,
                      onTap: (int i) {
                        switchTabsBloc.mapEventToState(TabEvents.values[i]);
                        print(TabEvents.values[i]);
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(
                              EvaIcons.peopleOutline,
                            ),
                            activeIcon: Icon(EvaIcons.people),
                            label: "Authors"),
                        BottomNavigationBarItem(
                          icon: Icon(EvaIcons.bookOutline),
                          label: "Books",
                          activeIcon: Icon(EvaIcons.book),
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(EvaIcons.heartOutline),
                            label: "My books",
                            activeIcon: Icon(EvaIcons.heart)),
                        BottomNavigationBarItem(
                            icon: Icon(EvaIcons.personOutline),
                            label: "Account",
                            activeIcon: Icon(EvaIcons.person))
                      ]),
                );
              });
        },
      ),
    );
  }
}
