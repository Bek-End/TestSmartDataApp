import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

//events
enum ThemeEvent { DARK_EVENT, LIGHT_EVENT }

//states
abstract class ThemeState {}

class DarkState extends ThemeState {
  final ThemeData themeData = ThemeData(
      accentColor: Colors.orange,
      brightness: Brightness.dark,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Color(0xFFc7c7c7),
          selectedItemColor: Colors.orange,
          elevation: 20));
}

class LightState extends ThemeState {
  final ThemeData themeData = ThemeData(
      brightness: Brightness.light,
      canvasColor: Colors.white,
      cardColor: Colors.grey[100],
      appBarTheme:
          AppBarTheme(brightness: Brightness.light, color: Colors.orange),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Color(0xFFFFFFFF),
          selectedItemColor: Colors.orange,
          elevation: 20));
}

//bloc
class ThemeBloc {
  BehaviorSubject<ThemeState> _subject = BehaviorSubject<ThemeState>();
  BehaviorSubject<ThemeState> get subject => _subject;

  ThemeState defaultTheme = LightState();

  ThemeState defaultState = DarkState();

  void mapEventToState(ThemeEvent event) {
    switch (event) {
      case ThemeEvent.DARK_EVENT:
        _subject.add(DarkState());
        break;
      case ThemeEvent.LIGHT_EVENT:
        _subject.add(LightState());
        break;
    }
  }
}

final ThemeBloc themeBloc = ThemeBloc();
bool check = true;
