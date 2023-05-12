import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/Auth_controller.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/model/club_model.dart';
import 'package:squad_makers/view/myinfo.dart';

class MyClubPage extends StatelessWidget {
  const MyClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  'username', // username 또한 user 정보에서 불러와서 넣기
                  style: TextStyle(
                      fontFamily: 'Garton',
                      fontSize: width * 0.04,
                      color: Colors.black),
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
        title: Text('Club',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Garton',
                fontSize: width * 0.08)),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text('클럽 리스트'),
          FutureBuilder(
              future: databasecontroller.getclublist(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('오류가 발생했습니다.'));
                } else if (snapshot.data == null) {
                  return Container();
                }
                List<dynamic> clublist = snapshot.data!;
                return SizedBox(
                  height: height,
                  child: ListView.builder(
                    itemCount: clublist.length,
                    itemBuilder: (context, index) {
                      ClubModel clubmodel = clublist.elementAt(index);
                      return Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              backgroundImage: NetworkImage(clubmodel.image)),
                          SizedBox(width: 10),
                          Text(clubmodel.name,
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          SizedBox(width: 10),
                          Text(clubmodel.info,
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          SizedBox(width: 10),
                          Text(clubmodel.clubuser.toString(),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey))
                        ],
                      );
                    },
                  ),
                );
              })
        ],
      )),
    );
  }
}
