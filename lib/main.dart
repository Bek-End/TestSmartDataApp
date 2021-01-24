import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/bloc/theme_bloc.dart';
import 'package:test_app/screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    switchScreenBloc.mapEventToState(SwitchScreenEvent.LOGIN_EVENT);
    return MultiProvider(
      providers: [
        StreamProvider<SwitchScreenState>.value(
          value: switchScreenBloc.subject.stream,
          initialData: switchScreenBloc.defaultScreen,
        ),
        StreamProvider<ThemeState>.value(
          value: themeBloc.subject.stream,
          initialData: themeBloc.defaultState,
        )
      ],
      child: MainScreen(),
    );
  }
}
