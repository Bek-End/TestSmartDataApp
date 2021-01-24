import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:test_app/bloc/theme_bloc.dart';

Widget buildLoadingWidget() {
  return StreamBuilder(
      stream: themeBloc.subject.stream,
      initialData: themeBloc.defaultState,
      // ignore: missing_return
      builder: (context, AsyncSnapshot<ThemeState> snapshot) {
        switch (snapshot.data.runtimeType) {
          case DarkState:
            return SizedBox(
                height: 20.0,
                width: 20.0,
                child: SpinKitDualRing(
                  size: 50,
                  color: Colors.white,
                ));
          case LightState:
            return SizedBox(
                height: 20.0,
                width: 20.0,
                child: SpinKitDualRing(
                  size: 50,
                  color: Colors.orange,
                ));
        }
      });
}

Widget buildLoadingWidgetLogin() {
  return Scaffold(
    appBar: AppBar(
      title: Text("Loading..."),
      centerTitle: true,
    ),
    body: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.0,
          width: 50.0,
          child: SpinKitDualRing(
            size: 50,
            color: Colors.orange,
          ),
        )
      ],
    )),
  );
}
