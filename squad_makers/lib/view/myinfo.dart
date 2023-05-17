import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/Auth_controller.dart';

import '../view_model/app_view_model.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.checkUserState(storage);
    });
  }

  AppViewModel appdata = Get.find();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        toolbarHeight: height * 0.08,
        backgroundColor: Color(0x805EA152),
        // actions: [
        //   Row(
        //     children: [
        //       TextButton.icon(
        //         //user 정보에서 user가 설정한 image로 변경하기
        //         icon: Icon(
        //           size: width * 0.05,
        //           Icons.circle,
        //           color: Colors.black,
        //         ),
        //         label: Text(
        //           'username', // username 또한 user 정보에서 불러와서 넣기
        //           style: TextStyle(
        //               fontFamily: 'Garton',
        //               fontSize: width * 0.04,
        //               color: Colors.black),
        //         ),
        //         onPressed: () {},
        //       ),
        //       SizedBox(
        //         width: width * 0.03,
        //       )
        //     ],
        //   ),
        //   // SizedBox(
        //   //   width: width * 0.03,
        //   // )
        // ],
        centerTitle: true,
        title: Text('My Info',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Garton',
                fontSize: width * 0.08)),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: height * 0.1,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: width * 0.15,
            child: Icon(
              Icons.circle,
              color: Colors.black,
              size: width * 0.3, // 수정된 부분
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            width: width * 0.5,
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      size: width * 0.05,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            width: width * 0.5,
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      size: width * 0.05,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            width: width * 0.7,
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
                    onPressed: () {},
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
    );
  }
}
