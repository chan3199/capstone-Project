import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/classes/toast_massage.dart';
import 'package:squad_makers/controller/Auth_controller.dart';
import 'package:squad_makers/view/login_view/start_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.asyncMethod(userInfo, storage);
    });
  }

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
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                    height: height * 0.07,
                    width: width * 0.7,
                    child: TextFormField(
                      controller: emailcontroller,
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
                  height: height * 0.08,
                ),
                Text(
                  '비밀번호',
                  style: TextStyle(fontSize: width * 0.05),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                    height: height * 0.07,
                    width: width * 0.7,
                    child: TextFormField(
                      controller: passwordcontroller,
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
                    onPressed: () {
                      if (authController.login(emailcontroller.text,
                              passwordcontroller.text, storage) ==
                          true) {
                        toastMessage('접속 성공 !');
                        Get.offAll(startPage());
                      } else {
                        toastMessage('로그인 실패');
                      }
                    },
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
