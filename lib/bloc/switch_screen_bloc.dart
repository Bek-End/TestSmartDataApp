import 'package:rxdart/rxdart.dart';
import 'package:test_app/repository/project_repo.dart';

enum SwitchScreenEvent { MAIN_EVENT, LOGIN_EVENT, REGISTER_EVENT }

enum SwitchScreenState { MAIN_STATE, LOGIN_STATE, REGISTER_STATE, LOADING_STATE }

class SwitchScreenBloc {
  BehaviorSubject<SwitchScreenState> _subject =
      BehaviorSubject<SwitchScreenState>();
  BehaviorSubject<SwitchScreenState> get subject => _subject;

  SwitchScreenState defaultScreen = SwitchScreenState.LOGIN_STATE;
  

  void mapEventToState(SwitchScreenEvent event) async{
    switch (event) {
      case SwitchScreenEvent.LOGIN_EVENT:
        _subject.sink.add(SwitchScreenState.LOADING_STATE);
        bool loginResponse = await projectRepo.localLoginUser();
        if(!loginResponse){
          _subject.sink.add(SwitchScreenState.LOGIN_STATE);
        }else{
          _subject.sink.add(SwitchScreenState.MAIN_STATE);
        }
        break;
      case SwitchScreenEvent.MAIN_EVENT:
        _subject.sink.add(SwitchScreenState.MAIN_STATE);
        break;
      case SwitchScreenEvent.REGISTER_EVENT:
        _subject.sink.add(SwitchScreenState.REGISTER_STATE);
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final switchScreenBloc = SwitchScreenBloc();
