import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/models/login_model/login_response.dart';
import 'package:test_app/models/register_model/register_response.dart';
import 'package:test_app/repository/project_repo.dart';

//states
enum RegisterCheckStates {
  PASSWORDS_NOT_EQUAL_STATE,
  WRONG_EMAIL_INPUT_STATE,
  ERROR_REGISTER_STATE,
  LOADING_STATE,
  USER_LOGGED_IN_STATE,
  ERROR_LOGIN_STATE,
  FILL_EMPTY_FIELDS_STATE,
  INITIAL_STATE
}

//events
class RegisterCheckEvent {
  final String user;
  final String email;
  final String password;
  final String confirmPassword;
  RegisterCheckEvent(
      {this.user, this.email, this.password, this.confirmPassword});
}

//bloc
class RegisterCheckBloc {
  BehaviorSubject<RegisterCheckStates> _subject =
      BehaviorSubject<RegisterCheckStates>();
  BehaviorSubject<RegisterCheckStates> get subject => _subject;

  RegisterCheckStates defaultRegisterState = RegisterCheckStates.INITIAL_STATE;

  void checkCredentials(RegisterCheckEvent event) async {
    if (event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      _subject.sink.add(RegisterCheckStates.FILL_EMPTY_FIELDS_STATE);
    } else if (!EmailValidator.validate(event.email)) {
      _subject.sink.add(RegisterCheckStates.WRONG_EMAIL_INPUT_STATE);
    } else if (event.password != event.confirmPassword) {
      _subject.sink.add(RegisterCheckStates.PASSWORDS_NOT_EQUAL_STATE);
    } else {
      _subject.sink.add(RegisterCheckStates.LOADING_STATE);
      RegisterResponse registerResponse = await projectRepo.registerUser(
          event.user, event.email, event.password, event.confirmPassword);
      if (registerResponse.error == "Error registering user") {
        _subject.sink.add(RegisterCheckStates.ERROR_REGISTER_STATE);
      } else {
        LoginResponse loginResponse = await projectRepo.loginUser(
            event.email, event.password, event.confirmPassword);
        if (loginResponse.error == "Error logging in") {
          _subject.sink.add(RegisterCheckStates.ERROR_LOGIN_STATE);
        } else {
          _subject.sink.add(RegisterCheckStates.USER_LOGGED_IN_STATE);
          switchScreenBloc.mapEventToState(SwitchScreenEvent.MAIN_EVENT);
        }
      }
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final registerCheckBloc = RegisterCheckBloc();
