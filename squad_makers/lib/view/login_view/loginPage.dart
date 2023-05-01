import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../squadPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
                child: Center(
                    child: Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                ),
                Image.asset('assets/maintext.png',
                    height: height * 0.1, width: width * 0.5),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'e-mail',
                  style: TextStyle(fontSize: width * 0.05),
                ),
                Container(
                    height: height * 0.07,
                    width: width * 0.7,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xff5EA152),
                            )),
                        hintText: 'email 입력, ex)abc@email.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    )),
                SizedBox(
                  height: height * 0.10,
                ),
                Text(
                  '비밀번호',
                  style: TextStyle(fontSize: width * 0.05),
                ),
                Container(
                    height: height * 0.07,
                    width: width * 0.7,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xff5EA152),
                            )),
                        hintText: '비밀번호 입력',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    )),
                SizedBox(
                  height: height * 0.05,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0x805EA152),
                    ),
                    onPressed: () => Get.to(() => SquadPage()),
                    child: Text(
                      'login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.05,
                          fontFamily: 'Garton',
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ))),
          )),
    );
  }
}
