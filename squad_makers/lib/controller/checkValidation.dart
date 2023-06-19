import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/auth_controller.dart';
import 'package:squad_makers/view_model/app_view_model.dart';
import '../utils/toast_massage.dart';

class PasswordValidation {
  AppViewModel appData = Get.find();
  void changePassword(String currentPassword, String newPassword,
      FlutterSecureStorage storage) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(
            email: appData.myInfo.email, password: currentPassword));
        await user.updatePassword(newPassword);
        //userController.updataMyPassword(appData.myInfo.uid, newPassword);
        authController.logout(storage);
        print('비밀번호 변경 성공');
        toastMessage('비밀번호가 변경되었습니다!');
      } catch (e) {
        print('비밀번호 변경 실패: $e');
        toastMessage('비밀번호가 변경에 실패하였습니다!');
      }
    } else {
      print('사용자를 찾을 수 없습니다.');
    }
  }
}

bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return regex.hasMatch(email);
}

bool validateName(String name) {
  RegExp isKorean = RegExp(r'^[ㄱ-ㅎ가-힣]*$');
  RegExp isEng = RegExp(r'^[a-zA-Z]*$');
  RegExp regKorean = RegExp(r'[\uac00-\ud7af]{2,4}', unicode: true);
  RegExp regEng = RegExp(r'^[a-zA-Z]{2,10}$');
  if (isKorean.hasMatch(name)) {
    return regKorean.hasMatch(name);
  } else if (isEng.hasMatch(name)) {
    return regEng.hasMatch(name);
  } else {
    return false;
  }
}

bool validateClubname(String clubname) {
  RegExp isOk = RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z0-9]+$');
  return isOk.hasMatch(clubname);
}

bool validateSquadname(String squadname) {
  RegExp isOk = RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z0-9]+$');
  return isOk.hasMatch(squadname);
}

class CorrectWordParameter {
  bool is8Characters;
  bool is1Symbol;
  bool is1Letter;
  bool is1Number;
  CorrectWordParameter(
      {this.is8Characters = false,
      this.is1Symbol = false,
      this.is1Letter = false,
      this.is1Number = false});
  bool get isCorrectWord =>
      (is8Characters && is1Symbol && is1Letter && is1Number);
}

CorrectWordParameter checkPossiblePasswordText(String value) {
  var correctWordParameter = CorrectWordParameter();
  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'^[a-zA-Z0-9 ]+$');

  //문자가 비었는지 확인
  if (value.isEmpty) {
    // 문자가 비었다면 모드 false로 리턴
    return CorrectWordParameter();
  }

  //8자 이상인지 확인
  if (value.length >= 8) {
    correctWordParameter.is8Characters = true;
  } else {
    correctWordParameter.is8Characters = false;
  }

  //특수기호가 있는지 확인
  if (!validSpecial.hasMatch(value)) {
    correctWordParameter.is1Symbol = true;
  } else {
    correctWordParameter.is1Symbol = false;
  }

  //문자가 있는지 확인
  if (!validAlphabet.hasMatch(value)) {
    correctWordParameter.is1Letter = false;
  } else {
    correctWordParameter.is1Letter = true;
  }

  //숫자가 있는지 확인
  if (validNumbers.hasMatch(value)) {
    correctWordParameter.is1Number = true;
  } else {
    correctWordParameter.is1Number = false;
  }
  return correctWordParameter;
}
