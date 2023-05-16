import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/Auth_controller.dart';
import 'package:squad_makers/view/club_view/club_mainPage.dart';
import 'package:squad_makers/view/myinfo.dart';
import 'package:squad_makers/view/positionInfoPage.dart';

mainBox(height, width, image, text, onTap) {
  return InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
            width: width * 0.7,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: AssetImage(image)),
              border: Border.all(color: Color(0xff5EA152)),
            )),
        SizedBox(
          height: height * 0.01,
        ),
        Text(
          text,
          style: TextStyle(
              fontFamily: 'Garton',
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold),
        )
      ]));
}

class SquadPage extends StatefulWidget {
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  // MyInfo myInfo = Get.find();

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
              Icons.email,
              color: Colors.white,
            ),
            onPressed: () {
              //          showDialog(
              // context: context,
              // barrierDismissible: false,
              // builder: (BuildContext context) {
              //   var width = MediaQuery.of(context).size.width;
              //   var height = MediaQuery.of(context).size.height;
              //   return AlertDialog(
              //     title: Text('선수 명단',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           fontSize: width * 0.05,
              //           fontFamily: 'Simple',
              //           color: Colors.black,
              //         )),
              //     content: SingleChildScrollView(
              //       child: SizedBox(
              //         width: width,
              //         height: height * 0.3,
              //         child: FutureBuilder(
              //             future: databasecontroller.getclubuserlist(
              //                 appdata.clubModel.clubuserlist),
              //             builder: (context, snapshot) {
              //               if (snapshot.hasError) {
              //                  return Center(child: Text('오류가 발생했습니다.'));
              //               } else if (snapshot.data == null) {
              //                 return Container();
              //               }
              //               List<dynamic> clubuserlist = snapshot.data!;
              //               return ListView.builder(
              //                 scrollDirection: Axis.vertical,
              //                 shrinkWrap: true,
              //                 itemCount: clubuserlist.length,
              //                 itemBuilder:
              //                     (BuildContext context, int index) {
              //                   MyInfo clubuser =
              //                       clubuserlist.elementAt(index);
              //                   return Container(
              //                     width: width * 0.8,
              //                     height: height * 0.05,
              //                     color: Color(0x805EA152),
              //                     child: Row(
              //                       children: [
              //                         Container(
              //                           width: width * 0.3,
              //                           height: height * 0.1,
              //                           child: Text(
              //                             "이름 : " + clubuser.name,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: width * 0.05,
              //                         ),
              //                         Container(
              //                           width: width * 0.3,
              //                           height: height * 0.1,
              //                           child: Text(
              //                             "닉네임 : " + clubuser.nickname,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   );
              //                 },
              //               );
              //             }),
              //       ),
              //     ),
              //     actions: [
              //       Center(
              //         child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: Color(0x805EA152),
              //               padding: EdgeInsets.all(5),
              //             ),
              //             onPressed: () {
              //               Navigator.of(context).pop();
              //             },
              //             child: Text('확인',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                   fontSize: 13,
              //                   fontFamily: 'Simple',
              //                   color: Colors.black,
              //                 ))),
              //       ),
              //     ],
              //   );
              // });
            },
          ),
          toolbarHeight: height * 0.08,
          backgroundColor: Color(0x805EA152),
          actions: [
            Row(
              children: [
                TextButton(
                  //user 정보에서 user가 설정한 image로 변경하기
                  child: Text(
                    '내 정보', // username 또한 user 정보에서 불러와서 넣기
                    style: TextStyle(
                        fontFamily: 'Garton',
                        fontSize: width * 0.04,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    Get.to(MyInfoPage());
                  },
                ),
                SizedBox(
                  width: width * 0.03,
                )
              ],
            ),
            // SizedBox(
            //   width: width * 0.03,
            // )
          ],
          centerTitle: true,
          title: Text('SquadMakers',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Garton',
                  fontSize: width * 0.08)),
        ),
        // drawer: Drawer(),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.08,
              ),
              mainBox(
                height,
                width,
                'assets/player1.png',
                'Position Info',
                () => Get.to(() => PositionInfoPage()),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              mainBox(height, width, 'assets/squad1.png', 'Squad Maker',
                  () => Get.to(() => ClubMainPage()))
            ],
          )),
        )));
  }
}
