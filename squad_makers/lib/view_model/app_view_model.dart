import 'package:get/get.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/position_model.dart';

import '../model/club_model.dart';

class AppViewModel extends GetxController {
  int _myVersion = 0;
  int _latestVersion = 0;

  bool _isLoadingScreen = false;
  String category = '';

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

  bool get isLoadingScreen => _isLoadingScreen;

  set isLoadingScreen(bool isLoadingScreen) {
    _isLoadingScreen = isLoadingScreen;
    update();
  }
}
