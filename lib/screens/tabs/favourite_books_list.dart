import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app/bloc/favourite_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';
import 'package:test_app/models/book_model/book_model.dart';

class FavouriteBooksListScreen extends StatefulWidget {
  @override
  _FavouriteBooksListScreenState createState() =>
      _FavouriteBooksListScreenState();
}

class _FavouriteBooksListScreenState extends State<FavouriteBooksListScreen> {
  @override
  void initState() {
    super.initState();
    favouriteBloc.mapEventToState(FavouriteInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite books"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: favouriteBloc.subject.stream,
        initialData: favouriteBloc.defaultState,
        builder:
            // ignore: missing_return
            (BuildContext context, AsyncSnapshot<FavouriteStates> snapshot) {
          switch (snapshot.data.runtimeType) {
            case FavouriteInitialState:
              FavouriteInitialState favouriteInitialState = snapshot.data;
              return Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: ListView(
                    children: _buildLisTile(favouriteInitialState.favBooks)),
              );
              break;
            case FavouriteRemoveState:
              FavouriteRemoveState favouriteRemoveState = snapshot.data;
              return Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: ListView(
                    children: _buildLisTile(favouriteRemoveState.favBooks)),
              );
              break;
            case FavouriteLoadingState:
              return Center(
                child: buildLoadingWidget(),
              );
            case FavouriteErrorState:
              return Center(
                child: Text("Error"),
              );
          }
        },
      ),
    );
  }

  List<Widget> _buildLisTile(List<Data> favBooks) {
    List<Widget> slidable = [];
    for (int i = 0; i < favBooks.length; i++) {
      slidable.add(Slidable(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: (favBooks[i].image != null)
                      ? Image.network(favBooks[i].image)
                      : Text(
                          "B",
                          style: TextStyle(color: Colors.white),
                        )),
              title: Text(favBooks[i].name),
              subtitle: Text(favBooks[i].desc),
            ),
          ),
          secondaryActions: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: IconSlideAction(
                foregroundColor: Colors.white,
                caption: "Delete",
                color: Colors.red,
                icon: EvaIcons.minusCircleOutline,
                onTap: () => favouriteBloc
                    .mapEventToState(FavouriteRemoveEvent(bookId: favBooks[i].id)),
              ),
            )
          ],
          actionPane: SlidableDrawerActionPane()));
    }
    return slidable;
  }
}
