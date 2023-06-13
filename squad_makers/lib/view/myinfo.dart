import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/controller/Auth_controller.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/controller/checkValidation.dart';
import 'package:squad_makers/utils/hash_password.dart';
import 'package:squad_makers/utils/loding.dart';
import '../classes/toast_massage.dart';
import '../controller/image_picker.dart';
import '../view_model/app_view_model.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final storage = FlutterSecureStorage();
  PasswordValidation passwordValidation = PasswordValidation();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  late bool isOk;
  AppViewModel appdata = Get.find();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.checkUserState(storage);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    nicknameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetBuilder(builder: (AppViewModel appdata) {
      return Loading(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.2,
            automaticallyImplyLeading: false,
            toolbarHeight: height * 0.08,
            backgroundColor: Color(0x805EA152),
            centerTitle: true,
            title: Text('My Info',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Garton',
                    fontSize: width * 0.08)),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Stack(
                  children: [
                    appdata.myInfo.image == ""
                        ? SizedBox(
                            width: width * 0.35,
                            height: height * 0.35,
                            child: CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/basic.png')),
                          )
                        : SizedBox(
                            width: width * 0.35,
                            height: height * 0.35,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(appdata.myInfo.image)),
                          ),
                    Positioned(
                        right: width * 0.005,
                        top: height * 0.17,
                        child: Container(
                          width: width * 0.12,
                          height: height * 0.12,
                          child: CircleAvatar(
                            backgroundColor: Color(0x805EA152),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  appdata.isLoadingScreen = true;
                                  XFile? result =
                                      await imagePickUploader.getImage();

                                  String resultImage = await imagePickUploader
                                      .uploadProfileImageToStorage(result!);

                                  appdata.myInfo.image = resultImage;

                                  appdata.isLoadingScreen = false;

                                  toastMessage('프로필 사진이 변경되었습니다.');
                                } catch (e) {
                                  toastMessage('오류가 발생했습니다.');
                                  print(e);
                                }
                                setState(() {});
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                              iconSize: 15,
                              color: Colors.blue,
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ),
                        ))
                  ],
                ),
                Container(
                  width: width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xff5EA152),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appdata.myInfo.name.isEmpty
                          ? Text('없음')
                          : Text(
                              '유저 이름 : ' + appdata.myInfo.name,
                              style: TextStyle(
                                  fontFamily: 'Simple',
                                  fontSize: width * 0.05,
                                  color: Colors.black),
                            ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  var width = MediaQuery.of(context).size.width;
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  return AlertDialog(
                                    title: Text('이름 수정',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontFamily: 'Simple',
                                          color: Colors.black,
                                        )),
                                    content: SingleChildScrollView(
                                      child: SizedBox(
                                        width: width,
                                        height: height * 0.1,
                                        child: appdata.myInfo.name.isEmpty
                                            ? Text('없음')
                                            : TextFormField(
                                                controller: nameController,
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    nameController.clear();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xff5EA152),
                                                      )),
                                                  hintText: appdata.myInfo.name,
                                                ),
                                                keyboardType:
                                                    TextInputType.name,
                                                style: TextStyle(
                                                  fontFamily: 'Simple',
                                                  fontSize: width * 0.05,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                    actions: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0x805EA152),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                ),
                                                onPressed: () {
                                                  appdata.myInfo.name =
                                                      nameController.text;
                                                  databasecontroller
                                                      .updataMyName(
                                                          appdata.myInfo.uid,
                                                          nameController.text);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('확인',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Simple',
                                                      color: Colors.black,
                                                    ))),
                                            SizedBox(
                                              width: width * 0.2,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0x805EA152),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('취소',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Simple',
                                                      color: Colors.black,
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            size: width * 0.05,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  width: width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xff5EA152),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appdata.myInfo.nickname.isEmpty
                          ? Text('없음')
                          : Text(
                              '유저 별명 : ' + appdata.myInfo.nickname,
                              style: TextStyle(
                                  fontFamily: 'Simple',
                                  fontSize: width * 0.05,
                                  color: Colors.black),
                            ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  var width = MediaQuery.of(context).size.width;
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  return AlertDialog(
                                    title: Text('별명 수정',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontFamily: 'Simple',
                                          color: Colors.black,
                                        )),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: width,
                                            height: height * 0.1,
                                            child:
                                                appdata.myInfo.nickname.isEmpty
                                                    ? Text('없음')
                                                    : TextFormField(
                                                        controller:
                                                            nicknameController,
                                                        onChanged: (value) {
                                                          if (value.isEmpty) {
                                                            nicknameController
                                                                .clear();
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    width: 1,
                                                                    color: Color(
                                                                        0xff5EA152),
                                                                  )),
                                                          hintText: appdata
                                                              .myInfo.nickname,
                                                        ),
                                                        keyboardType:
                                                            TextInputType.name,
                                                        style: TextStyle(
                                                          fontFamily: 'Simple',
                                                          fontSize:
                                                              width * 0.05,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0x805EA152),
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            onPressed: () async {
                                              isOk = await databasecontroller
                                                  .isDuplicatedNickname(
                                                      nicknameController.text);
                                              if (!isOk) {
                                                toastMessage('사용가능한 별명입니다!');
                                              } else {
                                                toastMessage('중복된 별명입니다.');
                                              }
                                            },
                                            child: Text('중복 검사',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  fontFamily: 'Simple',
                                                  color: Colors.black,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0x805EA152),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                ),
                                                onPressed: () {
                                                  if (!isOk) {
                                                    appdata.myInfo.nickname =
                                                        nicknameController.text;
                                                    databasecontroller
                                                        .updataMynickname(
                                                            appdata.myInfo.uid,
                                                            nicknameController
                                                                .text);
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    toastMessage(
                                                        '중복검사를 다시 해주세요');
                                                  }
                                                },
                                                child: const Text('확인',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Simple',
                                                      color: Colors.black,
                                                    ))),
                                            SizedBox(
                                              width: width * 0.2,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0x805EA152),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('취소',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Simple',
                                                      color: Colors.black,
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            size: width * 0.05,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  height: height * 0.07,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xff5EA152),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appdata.myInfo.email.isEmpty
                          ? Text('없음')
                          : Text(
                              '이메일 : ' + appdata.myInfo.email,
                              style: TextStyle(
                                  fontFamily: 'Simple',
                                  fontSize: width * 0.05,
                                  color: Colors.black),
                            ),
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(
                      //       Icons.edit,
                      //       size: width * 0.05,
                      //     ))
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0x805EA152),
                  ),
                  child: Text(
                    '비밀번호 변경',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.04,
                        fontFamily: 'Simple',
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              '비밀번호 변경',
                              style: TextStyle(
                                fontFamily: 'Simple',
                                fontSize: width * 0.05,
                                color: Colors.black,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: passwordController,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        passwordController.clear();
                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xff5EA152),
                                            )),
                                        hintText: '***********'),
                                    obscureText: true,
                                    style: TextStyle(
                                      fontFamily: 'Garton',
                                      fontSize: width * 0.05,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0x805EA152),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    onPressed: () {
                                      var correct = checkPossiblePasswordText(
                                          passwordController.text);
                                      if (correct.isCorrectWord == true) {
                                        toastMessage('변경가능한 비밀번호 입니다!');
                                      } else {
                                        toastMessage('비밀번호 조건이 충족되지 않습니다!');
                                      }
                                    },
                                    child: Text('비밀번호 검사',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontFamily: 'Simple',
                                          color: Colors.black,
                                        )),
                                  ),
                                  Text(
                                    '비밀번호 변경시 로그아웃 되므로 다시 로그인 해주세요!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0x805EA152),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        onPressed: () {
                                          var correct =
                                              checkPossiblePasswordText(
                                                  passwordController.text);
                                          if (correct.isCorrectWord == true) {
                                            passwordValidation.changePassword(
                                                hashPassword(
                                                    passwordController.text),
                                                storage);
                                          } else {
                                            toastMessage('비밀번호 검사를 다시 해주세요!');
                                          }
                                        },
                                        child: const Text('확인',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Simple',
                                              color: Colors.black,
                                            ))),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0x805EA152),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('취소',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Simple',
                                              color: Colors.black,
                                            ))),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0x805EA152),
                    ),
                    onPressed: () => {authController.logout(storage)},
                    child: Text(
                      '로그아웃',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontFamily: 'Simple',
                          fontWeight: FontWeight.bold),
                    ))
              ]),
            ),
          ),
        ),
      );
    });
  }
}
