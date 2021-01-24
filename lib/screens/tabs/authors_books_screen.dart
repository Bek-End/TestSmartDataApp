import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app/bloc/authors_books_bloc.dart';
import 'package:test_app/bloc/switch_authors_books_screen_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';
import 'package:test_app/models/book_model/book_model.dart';

class AuthorsBooksScreen extends StatefulWidget {
  @override
  _AuthorsBooksScreenState createState() => _AuthorsBooksScreenState();
}

class _AuthorsBooksScreenState extends State<AuthorsBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authorsBooksBloc.subject.stream,
      initialData: authorsBooksBloc.defaultAuthorsBooksState,
      builder:
          // ignore: missing_return
          (BuildContext context, AsyncSnapshot<AuthorsBooksStates> snapshot) {
        switch (snapshot.data.runtimeType) {
          case AuthorsBooksInitialState:
            AuthorsBooksInitialState authorsBooksInitialState = snapshot.data;
            return scaffold(
                context: context,
                child: ListView(
                  children: _buildSwipableListTile(
                      authorsBooksInitialState.book,
                      authorsBooksInitialState.favBooks),
                ));

          case AuthorsBooksLoadingState:
            return Center(
              child: buildLoadingWidget(),
            );

          case AuthorsBooksErrorState:
            return Center(
              child: Text("Error"),
            );

        }
      },
    );
  }

  Widget scaffold({BuildContext context, Widget child}) => WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          switchAuthorsBooksScreenBloc
              .mapEventToState(AuthorsBooksScreenEvents.AUTHORS_SCREEN_EVENT);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Author's Books"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(EvaIcons.arrowBack),
              onPressed: () => switchAuthorsBooksScreenBloc.mapEventToState(
                  AuthorsBooksScreenEvents.AUTHORS_SCREEN_EVENT),
            ),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: child),
        ),
      );

  List<Widget> _buildSwipableListTile(List<Data> books, List<Data> favBooks) {
    List<Widget> slidable = [];
    for (int i = 0; i < books.length; i++) {
      if (favBooks.contains(books[i])) {
        slidable.add(Slidable(
            actionExtentRatio: 0.25,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: (books[i].image != null)
                        ? Image.network(books[i].image)
                        : Text(
                            "B",
                            style: TextStyle(color: Colors.white),
                          )),
                title: Text(books[i].name),
                subtitle: Text(books[i].desc),
              ),
            ),
            secondaryActions: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: IconSlideAction(
                  foregroundColor: Colors.white,
                  caption: "Favourite",
                  color: Colors.orange,
                  icon: EvaIcons.heart,
                ),
              )
            ],
            actionPane: SlidableDrawerActionPane()));
      } else {
        slidable.add(Slidable(
            actionExtentRatio: 0.25,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: (books[i].image != null)
                        ? Image.network(books[i].image)
                        : Text(
                            "B",
                            style: TextStyle(color: Colors.white),
                          )),
                title: Text(books[i].name),
                subtitle: Text(books[i].desc),
              ),
            ),
            secondaryActions: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: IconSlideAction(
                  foregroundColor: Colors.white,
                  caption: "Favourites",
                  color: Colors.orange,
                  icon: EvaIcons.plusCircle,
                  onTap: () => authorsBooksBloc.mapEventToState(
                      AuthorsBooksAddToFavouriteEvent(books[i].id, books)),
                ),
              )
            ],
            actionPane: SlidableDrawerActionPane()));
      }
    }
    return slidable;
  }
}
