import 'package:get/get.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/position_model.dart';
import 'package:squad_makers/model/squad_model.dart';

import '../model/club_model.dart';

class AppViewModel extends GetxController {
  bool _isLoadingScreen = false;

  MyInfo _myInfo = MyInfo(
    date: DateTime.now(),
    email: '',
    image: '',
    name: '',
    nickname: '',
    myclubs: [],
    invitions: [],
    uid: '',
  );

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
      clubuser: 0);

  ClubModel get clubModel => _clubModel;
  set clubModel(ClubModel clubModel) {
    _clubModel = clubModel;
    update();
  }

  SquadModel _squadModel = SquadModel(
      clubname: '',
      playerlist: [],
      tacticsinfo: '',
      subplayers: [],
      userlist: []);

  SquadModel get squadModel => _squadModel;
  set squadModel(SquadModel SquadModel) {
    _squadModel = squadModel;
    update();
  }

  bool get isLoadingScreen => _isLoadingScreen;

  set isLoadingScreen(bool isLoadingScreen) {
    _isLoadingScreen = isLoadingScreen;
    update();
  }
}
