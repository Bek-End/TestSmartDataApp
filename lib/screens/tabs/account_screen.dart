import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:test_app/bloc/about_me_bloc.dart';
import 'package:test_app/bloc/theme_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkModeEnabled = check;
  @override
  void initState() {
    super.initState();
    aboutMeBloc.mapEventToState(AboutMeEvents.INITIAL_EVENT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account screen"),
        centerTitle: true,
        actions: [
          Container(
            width: 60,
            margin: EdgeInsets.only(right: 5),
            padding: EdgeInsets.all(3),
            child: DayNightSwitcher(
                cloudsColor: Colors.white54,
                dayBackgroundColor: Colors.grey,
                isDarkModeEnabled: isDarkModeEnabled,
                onStateChanged: onStateChanged),
          )
        ],
      ),
      body: StreamBuilder(
          stream: aboutMeBloc.subject.stream,
          builder: (context, AsyncSnapshot<AboutMeStates> snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.runtimeType) {
                case AboutMeInitialState:
                  AboutMeInitialState aboutMeInitialState = snapshot.data;
                  return SafeArea(
                      child: Container(
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(color: Colors.black12),
                          child: Icon(
                            EvaIcons.personOutline,
                            size: 150,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aboutMeInitialState.aboutMeModel.data.name,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    aboutMeInitialState.aboutMeModel.data.email)
                              ],
                            )),
                      ),
                      Expanded(
                          child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Log out",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            IconButton(
                              icon: Icon(
                                EvaIcons.logOutOutline,
                                color: Colors.orange,
                                size: 40,
                              ),
                              onPressed: () => aboutMeBloc
                                  .mapEventToState(AboutMeEvents.LOG_OUT_EVENT),
                            ),
                          ],
                        ),
                      ))
                    ],
                  )));
                case AboutMeErrorState:
                  return Center(
                    child: Text("Error"),
                  );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              return Center(
                child: buildLoadingWidget(),
              );
            }
          }),
    );
  }

  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      check = !check;
      this.isDarkModeEnabled = check;
    });
    switch (isDarkModeEnabled) {
      case true:
        themeBloc.mapEventToState(ThemeEvent.DARK_EVENT);
        break;
      case false:
        themeBloc.mapEventToState(ThemeEvent.LIGHT_EVENT);
        break;
    }
  }
}
