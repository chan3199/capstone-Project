import 'package:get/get.dart';
import 'package:squad_makers/model/myinfo.dart';

class AppViewModel extends GetxController {
  int _myVersion = 0;
  int _latestVersion = 0;

  bool _isLoadingScreen = false;
  String _userEmail = '';

  MyInfo _myInfo = MyInfo(
    date: DateTime.now(),
    email: '',
    image: '',
    password: '',
    name: '',
    myclubs: [],
    uid: '',
  );

  MyInfo get myInfo => _myInfo;

  set myInfo(MyInfo myInfo) {
    _myInfo = myInfo;
    update();
  }
}
