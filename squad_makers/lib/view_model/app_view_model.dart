import 'package:get/get.dart';
import 'package:squad_makers/model/user_model.dart';
import 'package:squad_makers/model/position_model.dart';
import 'package:squad_makers/model/squadApp_model.dart';

import '../model/club_model.dart';

class AppViewModel extends GetxController {
  bool _isLoadingScreen = false;
  bool _istacticSwitch = false;
  String _squadname = '';

  MyInfo _myInfo = MyInfo(
      date: DateTime.now(),
      email: '',
      image: '',
      name: '',
      nickname: '',
      myclubs: [],
      invitions: [],
      uid: '');
  //password: '');

  MyInfo get myInfo => _myInfo;

  set myInfo(MyInfo myInfo) {
    _myInfo = myInfo;
    update();
  }

  PositionInfo _positionInfo =
      PositionInfo(docId: '', name: '', Information: '', image: []);

  PositionInfo get positionInfo => _positionInfo;
  set positionInfo(PositionInfo positionInfo) {
    _positionInfo = positionInfo;
    update();
  }

  ClubModel _clubModel = ClubModel(
      date: DateTime.now(),
      name: '',
      image: '',
      info: '',
      clubmaster: '',
      clubuserlist: [],
      squadlist: [],
      clubuser: 0,
      adminlist: []);

  ClubModel get clubModel => _clubModel;

  set clubModel(ClubModel clubModel) {
    _clubModel = clubModel;
    update();
  }

  String get squadname => _squadname;

  set squadname(String squadname) {
    _squadname = squadname;
    update();
  }

  SquadAppModel _squadmodel = SquadAppModel(
    date: DateTime.now(),
    clubname: '',
    squadname: '',
    tacticsinfo: {},
    playerlist: [],
    subplayers: [],
    userlist: [],
  );

  SquadAppModel get squadmodel => _squadmodel;

  set squadmodel(SquadAppModel squadmodel) {
    _squadmodel = squadmodel;
    update();
  }

  bool get isLoadingScreen => _isLoadingScreen;

  set isLoadingScreen(bool isLoadingScreen) {
    _isLoadingScreen = isLoadingScreen;
    update();
  }

  bool get istacticSwitch => _istacticSwitch;

  set istacticSwitch(bool istacticSwitch) {
    _istacticSwitch = istacticSwitch;
    update();
  }
}
