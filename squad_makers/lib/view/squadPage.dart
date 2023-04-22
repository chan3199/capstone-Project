import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SquadPage extends StatelessWidget {
  const SquadPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.2,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          toolbarHeight: height * 0.08,
          backgroundColor: Colors.white,
          actions: [
            Row(
              children: [
                TextButton.icon(
                  //user 정보에서 user가 설정한 image로 변경하기
                  icon: Icon(
                    size: width * 0.07,
                    Icons.circle,
                    color: Colors.black,
                  ),
                  label: Text(
                    'username',
                    style: TextStyle(
                        fontFamily: 'Garton',
                        fontSize: width * 0.05,
                        color: Colors.black),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  width: width * 0.05,
                )
              ],
            ),
            // SizedBox(
            //   width: width * 0.03,
            // )
          ],
          title: Text('SquadMakers',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Garton',
                  fontSize: width * 0.07)),
        ),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Center(
              child: Column(
            children: [],
          )),
        )));
  }
}
