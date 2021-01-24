import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/bloc/theme_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';
import 'package:test_app/screens/front_page_screen.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/register_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SwitchScreenState switchScreenState =
        Provider.of<SwitchScreenState>(context);
    ThemeState themeState = Provider.of<ThemeState>(context);
    Widget scaffold;
    ThemeData themeData;
    switch (switchScreenState) {
      case SwitchScreenState.LOGIN_STATE:
        switch (themeState.runtimeType) {
          case DarkState:
            scaffold = LoginScreen();
            themeData = DarkState().themeData;
            break;
          case LightState:
            scaffold = LoginScreen();
            themeData = LightState().themeData;
            break;
        }
        break;
      case SwitchScreenState.MAIN_STATE:
        switch (themeState.runtimeType) {
          case DarkState:
            scaffold = FrontPageScreen();
            themeData = DarkState().themeData;
            break;
          case LightState:
            scaffold = FrontPageScreen();
            themeData = LightState().themeData;
            break;
        }
        break;
      case SwitchScreenState.REGISTER_STATE:
        switch (themeState.runtimeType) {
          case DarkState:
            scaffold = RegisterScreen();
            themeData = DarkState().themeData;
            break;
          case LightState:
            scaffold = RegisterScreen();
            themeData = LightState().themeData;
            break;
        }
        break;
      case SwitchScreenState.LOADING_STATE:
        switch (themeState.runtimeType) {
          case DarkState:
            scaffold = buildLoadingWidgetLogin();
            themeData = DarkState().themeData;
            break;
          case LightState:
            scaffold = buildLoadingWidgetLogin();
            themeData = LightState().themeData;
            break;
        }
        break;
    }
    return materialApp(scaffold, themeData);
  }
}

MaterialApp materialApp(Widget scaffold, ThemeData themeData) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: scaffold,
    theme: themeData,
  );
}
