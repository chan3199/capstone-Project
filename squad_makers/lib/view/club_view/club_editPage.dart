import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/controller/club_controller.dart';
import 'package:squad_makers/controller/database_service.dart';
import 'package:squad_makers/controller/storage_controller.dart';
import 'package:squad_makers/view/club_view/club_mainPage.dart';

import '../../controller/checkValidation.dart';
import '../../view_model/app_view_model.dart';

class ClubEditPage extends StatefulWidget {
  const ClubEditPage({super.key});

  @override
  State<ClubEditPage> createState() => _ClubEditPageState();
}

class _ClubEditPageState extends State<ClubEditPage> {
  final clubnameController = TextEditingController();
  final clubinfoController = TextEditingController();
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String clubname = '';
  String clubinfo = '';
  XFile? _image;

  Widget _clubimage() {
    return _image == null
        ? ElevatedButton(
            onPressed: () async {
              final image =
                  await _picker.pickImage(source: ImageSource.gallery);
              setState(() {
                if (image != null) {
                  _image = image;
                }
              });
            },
            child: CircleAvatar(
              backgroundColor: Color(0xffd6d6d6),
              radius: 50,
              child: Icon(
                Icons.image,
                color: Colors.white,
                size: 50,
              ),
            ),
            style:
                ElevatedButton.styleFrom(elevation: 0, shape: CircleBorder()),
          )
        : ElevatedButton(
            onPressed: () async {
              final image =
                  await _picker.pickImage(source: ImageSource.gallery);
              setState(() {
                if (image != null) {
                  _image = image;
                }
              });
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(File(_image!.path)),
            ),
            style:
                ElevatedButton.styleFrom(elevation: 0, shape: CircleBorder()),
          );
  }

  @override
  void dispose() {
    clubnameController.dispose();
    clubinfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetBuilder(builder: (AppViewModel appdata) {
      return Loading(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SafeArea(
                      child: Center(
                          child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Image.asset('assets/maintext.png',
                          height: height * 0.1, width: width * 0.5),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text(
                        '클럽 사진',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      _clubimage(),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(
                        '클럽 이름',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                          height: height * 0.07,
                          width: width * 0.7,
                          child: TextFormField(
                            controller: clubnameController,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                clubnameController.clear();
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5EA152),
                                  )),
                              hintText: '클럽 이름을 입력해주세요.',
                            ),
                            keyboardType: TextInputType.name,
                          )),
                      TextButton(
                          onPressed: () {
                            if (!(clubnameController.text == '') &&
                                validateName(clubnameController.text)) {
                              toastMessage('사용가능한 클럽 이름입니다!');
                            } else if (!validateName(clubnameController.text)) {
                              toastMessage('클럽 이름은 한글 2~4자, 영문 2~10자 이내입니다.');
                            } else if (clubnameController.text == '') {
                              toastMessage('클럽 이름을 입력해주세요');
                            }
                          },
                          child: Text(
                            '중복 검사',
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text(
                        '클럽 소개',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                          height: height * 0.07,
                          width: width * 0.7,
                          child: TextFormField(
                            controller: clubinfoController,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                clubinfoController.clear();
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5EA152),
                                  )),
                              hintText: '클럽을 간단히 소개해주세요',
                            ),
                            keyboardType: TextInputType.name,
                          )),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0x805EA152),
                          ),
                          onPressed: () async {
                            appdata.isLoadingScreen = true;
                            if (_image != null) {
                              String resultURL = await storageController
                                  .uploadClubImageToStorage(
                                      clubnameController.text, _image!);
                              DatabaseService(uid: appdata.myInfo.uid)
                                  .setClubData(clubnameController.text,
                                      resultURL, clubinfoController.text);
                            }

                            appdata.myInfo.myclubs.add(clubnameController.text);

                            clubController.addclubs(
                                appdata.myInfo.uid, appdata.myInfo.myclubs);

                            toastMessage('클럽 생성이 완료되었습니다.');
                            appdata.isLoadingScreen = false;
                            Get.off(ClubMainPage());
                          },
                          child: Text(
                            '클럽 생성',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.04,
                                fontFamily: 'Garton',
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ))))),
        ),
      );
    });
  }
}
