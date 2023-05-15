import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

class ClubInfoPage extends StatefulWidget {
  ClubInfoPage({Key? key}) : super(key: key);

  @override
  State<ClubInfoPage> createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
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
        actions: [
          Row(
            children: [
              TextButton.icon(
                //user 정보에서 user가 설정한 image로 변경하기
                icon: Icon(
                  size: width * 0.05,
                  Icons.circle,
                  color: Colors.black,
                ),
                label: Text(
                  appdata.myInfo.name, // username 또한 user 정보에서 불러와서 넣기
                  style: TextStyle(
                      fontFamily: 'Garton',
                      fontSize: width * 0.04,
                      color: Colors.black),
                ),
                onPressed: () {},
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(appdata.clubModel.name,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Garton',
                    fontSize: width * 0.07)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          SizedBox(
            height: height * 0.03,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              radius: width * 0.15,
              backgroundImage: NetworkImage(appdata.clubModel.image)),
          SizedBox(
            height: height * 0.03,
          ),
          Text(appdata.clubModel.info, style: TextStyle()),
          SizedBox(
            height: height * 0.03,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (appdata.clubModel.clubmaster == appdata.myInfo.uid)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0x805EA152),
                    padding: EdgeInsets.all(5),
                  ),
                  onPressed: () {},
                  child: Text('초대하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontFamily: 'Simple',
                        color: Colors.black,
                      ))),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0x805EA152),
                  padding: EdgeInsets.all(5),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('선수 명단',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontFamily: 'Simple',
                                color: Colors.black,
                              )),
                          content: SingleChildScrollView(
                            child: ListBody(children: [
                              Text(appdata.clubModel.clubuserlist[0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    fontFamily: 'Simple',
                                    color: Colors.black,
                                  ))
                            ]),
                            // child: Container(
                            //   height: height * 0.4,
                            //   child: ListView.builder(
                            //     shrinkWrap: true,
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount:
                            //         appdata.clubModel.clubuserlist.length,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return Container(
                            //         color: Color(0x805EA152),
                            //         child: Center(
                            //             child: Text(appdata
                            //                 .clubModel.clubuserlist[index])),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ),
                          actions: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0x805EA152),
                                  padding: EdgeInsets.all(5),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('확인',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    ))),
                          ],
                        );
                      });
                },
                child: Text('선수명단',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontFamily: 'Simple',
                      color: Colors.black,
                    ))),
          ]),
          SizedBox(
            height: height * 0.05,
          ),
          Text('Squad 목록',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.05,
                fontFamily: 'Simple',
                color: Colors.black,
              )),
          Container(
            width: width * 0.7,
            height: height * 0.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xff5EA152),
                )),
            child: Column(children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0x805EA152),
                    padding: EdgeInsets.all(5),
                  ),
                  onPressed: () {},
                  child: Text('새 스쿼드',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontFamily: 'Simple',
                        color: Colors.black,
                      )))
            ]),
          ),
          SizedBox(
            height: height * 0.1,
          )
        ])),
      ),
    );
  }
}
