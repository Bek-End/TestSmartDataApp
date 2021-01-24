import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app/bloc/books_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';
import 'package:test_app/models/book_model/book_model.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    booksBloc.mapEventToState(BooksInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: booksBloc.subject.stream,
          initialData: booksBloc.defaultState,
          // ignore: missing_return
          builder: (context, AsyncSnapshot<BooksStates> snapshot) {
            BooksInitialState booksInitialState;
            switch (snapshot.data.runtimeType) {
              case BooksInitialState:
                booksInitialState = snapshot.data;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: ListView(
                    children: _buildLisTile(
                        booksInitialState.books, booksInitialState.favBooks),
                  ),
                );

              case BooksAddToFavsState:
                BooksAddToFavsState booksAddToFavsState = snapshot.data;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: ListView(
                    children: _buildLisTile(booksAddToFavsState.books,
                        booksAddToFavsState.favBooks),
                  ),
                );

              case BooksLoadingState:
                return Center(child: buildLoadingWidget());

              case BooksErrorState:
                return Center(child: Text("Error"));
            }
          }),
    );
  }
}

List<Widget> _buildLisTile(List<Data> books, List<Data> favBooks) {
  List<Widget> slidable = [];
  for (int i = 0; i < books.length; i++) {
    if (favBooks.contains(books[i])) {
      slidable.add(Slidable(
          actionExtentRatio: 0.25,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                onTap: () => booksBloc
                    .mapEventToState(BooksAddToFavsEvent(bookId: books[i].id)),
              ),
            )
          ],
          actionPane: SlidableDrawerActionPane()));
    }
  }
  return slidable;
}
