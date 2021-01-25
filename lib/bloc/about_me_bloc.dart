import 'package:rxdart/rxdart.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/models/about_me_model/about_me_model.dart';
import 'package:test_app/models/about_me_model/about_me_response.dart';
import 'package:test_app/repository/project_repo.dart';

//events
enum AboutMeEvents { INITIAL_EVENT, LOG_OUT_EVENT }

//states
abstract class AboutMeStates {}

class AboutMeInitialState extends AboutMeStates {
  final AboutMeModel aboutMeModel;
  AboutMeInitialState({this.aboutMeModel});
}

class AboutMeErrorState extends AboutMeStates {}

//bloc
class AboutMeBloc {
  BehaviorSubject<AboutMeStates> _subject = BehaviorSubject<AboutMeStates>();
  BehaviorSubject<AboutMeStates> get subject => _subject;

  void mapEventToState(AboutMeEvents event) async {
    switch (event) {
      case AboutMeEvents.INITIAL_EVENT:
        AboutMeResponse aboutMeResponse = await projectRepo.aboutMe();
        _subject.sink.add(
            AboutMeInitialState(aboutMeModel: aboutMeResponse.aboutMeModel));
        break;

      case AboutMeEvents.LOG_OUT_EVENT:
        bool res = await projectRepo.logOut();
        if (res) {
          switchScreenBloc.mapEventToState(SwitchScreenEvent.LOGIN_EVENT);
        } else {
          _subject.sink.add(AboutMeErrorState());
        }
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final aboutMeBloc = AboutMeBloc();