import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/models/login_model/login_response.dart';
import 'package:test_app/repository/project_repo.dart';

//states
enum LoginCheckStates {
  PASSWORDS_NOT_EQUAL_STATE,
  WRONG_EMAIL_INPUT_STATE,
  USER_NOT_FOUND_STATE,
  LOADING_STATE,
  USER_LOGGED_IN_STATE,
  FILL_EMPTY_FIELDS_STATE,
  INITIAL_STATE
}

//events
class LoginCheckEvent {
  final String email;
  final String password;
  final String confirmPassword;
  LoginCheckEvent({this.email, this.password, this.confirmPassword});
}

//bloc
class LoginCheckBloc {
  BehaviorSubject<LoginCheckStates> _subject =
      BehaviorSubject<LoginCheckStates>();
  BehaviorSubject<LoginCheckStates> get subject => _subject;

  LoginCheckStates defaultLoginState = LoginCheckStates.INITIAL_STATE;

  void checkCredentials(LoginCheckEvent event) async {
    if (event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      _subject.sink.add(LoginCheckStates.FILL_EMPTY_FIELDS_STATE);
    } else if (!EmailValidator.validate(event.email)) {
      _subject.sink.add(LoginCheckStates.WRONG_EMAIL_INPUT_STATE);
    } else if (event.password != event.confirmPassword) {
      _subject.sink.add(LoginCheckStates.PASSWORDS_NOT_EQUAL_STATE);
    } else {
      _subject.sink.add(LoginCheckStates.LOADING_STATE);
      LoginResponse loginResponse = await projectRepo.loginUser(
          event.email, event.password, event.confirmPassword);
      if (loginResponse.error == "Error logging in") {
        _subject.sink.add(LoginCheckStates.USER_NOT_FOUND_STATE);
      } else {
        _subject.sink.add(LoginCheckStates.USER_LOGGED_IN_STATE);

        switchScreenBloc.mapEventToState(SwitchScreenEvent.MAIN_EVENT);
      }
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final loginCheckBloc = LoginCheckBloc();
