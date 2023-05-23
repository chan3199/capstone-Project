import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/controller/Auth_controller.dart';
import 'package:squad_makers/controller/database_controller.dart';
import '../classes/toast_massage.dart';
import '../controller/image_picker.dart';
import '../view_model/app_view_model.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  static final storage = FlutterSecureStorage();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
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
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppViewModel appdata = Get.find();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                              XFile? result =
                                  await imagePickUploader.getImage();

                              String resultImage = await imagePickUploader
                                  .uploadProfileImageToStorage(result!);

                              appdata.myInfo.image = resultImage;

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
                              var height = MediaQuery.of(context).size.height;
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
                                    height: height * 0.3,
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
                                                    color: Color(0xff5EA152),
                                                  )),
                                              hintText: appdata.myInfo.name,
                                            ),
                                            keyboardType: TextInputType.name,
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
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            onPressed: () {
                                              databasecontroller.updataMyName(
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
                              var height = MediaQuery.of(context).size.height;
                              return AlertDialog(
                                title: Text('별명 수정',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    )),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width: width,
                                    height: height * 0.3,
                                    child: appdata.myInfo.nickname.isEmpty
                                        ? Text('없음')
                                        : TextFormField(
                                            controller: nicknameController,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                nicknameController.clear();
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
                                                    color: Color(0xff5EA152),
                                                  )),
                                              hintText: appdata.myInfo.nickname,
                                            ),
                                            keyboardType: TextInputType.name,
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
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            onPressed: () {
                                              databasecontroller
                                                  .updataMynickname(
                                                      appdata.myInfo.uid,
                                                      nicknameController.text);
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
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var width = MediaQuery.of(context).size.width;
                              var height = MediaQuery.of(context).size.height;
                              return AlertDialog(
                                title: Text('이메일 수정',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    )),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width: width,
                                    height: height * 0.3,
                                    child: appdata.myInfo.email.isEmpty
                                        ? Text('없음')
                                        : TextFormField(
                                            controller: emailController,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                emailController.clear();
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
                                                    color: Color(0xff5EA152),
                                                  )),
                                              hintText: appdata.myInfo.email,
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
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
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            onPressed: () {
                                              databasecontroller.updataMyEmail(
                                                  appdata.myInfo.uid,
                                                  emailController.text);
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
                      icon: Icon(
                        Icons.edit,
                        size: width * 0.05,
                      ))
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
    );
  }
}
