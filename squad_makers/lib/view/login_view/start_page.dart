import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loginPage.dart';
import 'sign_upPage.dart';
import 'package:squad_makers/controller/Auth_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class startPage extends StatefulWidget {
  const startPage({super.key});

  @override
  State<startPage> createState() => _startPageState();
}

class _startPageState extends State<startPage> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authController.asyncMethod(userInfo, storage);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ball.png',
                height: height * 0.3,
                width: width * 0.5,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Image.asset('assets/maintext.png',
                  height: height * 0.1, width: width * 0.5),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.5)),
                  onPressed: () => Get.to(() => LoginPage()),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05,
                        fontFamily: 'Garton',
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.5)),
                  onPressed: () => Get.to(() => SignUpPage()),
                  child: Text(
                    'Sign-Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05,
                        fontFamily: 'Garton',
                        fontWeight: FontWeight.bold),
                  ))
            ],
          )),
        ));
  }
}
