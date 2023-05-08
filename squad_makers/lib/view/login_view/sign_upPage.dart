import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/Database_controller.dart';
import 'package:squad_makers/view/login_view/loginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final checkpassController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    nicknameController.dispose();
    passwordController.dispose();
    checkpassController.dispose();
    emailController.dispose();
    super.dispose();
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
                    height: height * 0.03,
                  ),
                  Text(
                    '이름',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: nameController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            nameController.clear();
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
                          hintText: '이름 입력, 이름은 2글자 이상입니다.',
                        ),
                        keyboardType: TextInputType.name,
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    '닉네임',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: nicknameController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            nicknameController.clear();
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
                          hintText: '재미있는 별명을 지어주세요',
                        ),
                        keyboardType: TextInputType.name,
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    'e-mail',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: emailController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            emailController.clear();
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
                          hintText: 'email 입력, ex)abc@email.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    '비밀번호',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: passwordController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            passwordController.clear();
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
                          hintText: '비밀번호 입력',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      )),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: checkpassController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            checkpassController.clear();
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
                          hintText: '비밀번호 확인, 비밀번호를 한번 더 입력해주세요.',
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
                      onPressed: () => {
                            databasecontroller.signUpUserCredential(
                                email: emailController.text,
                                password: passwordController.text,
                                nickname: nicknameController.text,
                                name: nameController.text),
                            Get.off(() => LoginPage())
                          },
                      child: Text(
                        'Sign-Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
                            fontFamily: 'Garton',
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ))))),
    );
  }
}
