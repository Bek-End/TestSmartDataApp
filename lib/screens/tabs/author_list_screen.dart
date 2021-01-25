import 'package:flutter/material.dart';
import 'package:test_app/bloc/authors_bloc.dart';
import 'package:test_app/bloc/authors_books_bloc.dart';
import 'package:test_app/bloc/switch_authors_books_screen_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';
import 'package:test_app/models/author_model/author_model.dart';
import 'package:test_app/models/book_model/book_model.dart' as book;
import 'package:test_app/screens/tabs/authors_books_screen.dart';

class AuthorListScreen extends StatefulWidget {
  @override
  _AuthorListScreenState createState() => _AuthorListScreenState();
}

class _AuthorListScreenState extends State<AuthorListScreen> {
  @override
  void initState() {
    super.initState();
    authorBloc.mapEventToState(AuthorEvents.INITIAL_EVENT);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authorBloc.subject.stream,
        builder: (context, AsyncSnapshot<AuthorStates> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.runtimeType) {
              case AuthorInitialState:
                AuthorInitialState authorInitialState = snapshot.data;
                return StreamBuilder(
                    stream: switchAuthorsBooksScreenBloc.subject.stream,
                    initialData: switchAuthorsBooksScreenBloc.defaultScreen,
                    builder: (context,
                        AsyncSnapshot<AuthorsBooksScreenStates> snapshot) {
                      switch (snapshot.data) {
                        case AuthorsBooksScreenStates.AUTHORS_SCREEN_STATE:
                          return Scaffold(
                            appBar: AppBar(
                              title: Text("Authors"),
                              centerTitle: true,
                            ),
                            body: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: ListView(
                                  children: _buildLisTile(
                                      authorInitialState.authorModel,
                                      authorInitialState.bookModel),
                                )),
                          );
                          break;
                        case AuthorsBooksScreenStates
                            .AUTHORS_BOOKS_SCREEN_STATE:
                          return AuthorsBooksScreen();
                      }
                    });
                break;
              case AuthorErrorState:
                return Scaffold(
                  appBar: AppBar(title: Text("Authors"), centerTitle: true),
                  body: Center(
                    child: Text("Error"),
                  ),
                );
                break;
              default:
                return Container();
                break;
            }
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text("Authors"), centerTitle: true),
              body: Center(
                child: Text("Error"),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(title: Text("Authors"), centerTitle: true),
                body: Center(child: buildLoadingWidget()));
          }
        });
  }

  List<Widget> _buildLisTile(
      AuthorModel authorModel, book.BookModel bookModel) {
    int count = 0;
    List<Widget> _list = [];
    List<book.Data> bookList = [];
    for (int i = 0; i < authorModel.data.length; i++) {
      for (int j = 0; j < bookModel.data.length; j++) {
        if (authorModel.data[i].id == bookModel.data[j].authorId) {
          bookList.add(bookModel.data[j]);
          count++;
        }
      }
      print(bookList);
      _list.add(_buildListTileItem(authorModel.data[i].name,
          authorModel.data[i].image, count, bookList));
      count = 0;
      bookList = [];
    }
    return _list;
  }

  Widget _buildListTileItem(
      String name, String image, int count, List<book.Data> bookList) {
    return GestureDetector(
      onTap: () {
        switchAuthorsBooksScreenBloc.mapEventToState(
            AuthorsBooksScreenEvents.AUTHORS_BOOKS_SCREEN_EVENT);
        authorsBooksBloc.mapEventToState(AuthorsBooksInitialEvent(bookList));
        print("second check " + bookList.toString());
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListTile(
                  leading: (image == null)
                      ? Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                        )
                      : Image.network(image),
                  title: Text(name),
                  subtitle: Text("Number of books: $count"),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.orange,
              )
            ],
          ),
        ),
      ),
    );
  }
}
