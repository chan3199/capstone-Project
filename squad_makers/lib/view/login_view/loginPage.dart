import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/controller/auth_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view/main_view/mainPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';
import '../../controller/checkValidation.dart';

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
  final findcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  void dispose() {
    passwordcontroller.dispose();
    emailcontroller.dispose();
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
                child: SafeArea(
                    child: Center(
                        child: Form(
                  key: _formKey,
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
                          height: height * 0.1,
                          width: width * 0.7,
                          child: TextFormField(
                            key: ValueKey(1),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ('이메일을 입력해주세요.');
                              } else if (!validateEmail(value)) {
                                return ('유효한 이메일을 입력해주세요.');
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value!;
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                emailcontroller.clear();
                              }
                            },
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
                        height: height * 0.05,
                      ),
                      Text(
                        '비밀번호',
                        style: TextStyle(fontSize: width * 0.05),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Column(
                        children: [
                          Container(
                              height: height * 0.1,
                              width: width * 0.7,
                              child: TextFormField(
                                style: TextStyle(fontFamily: 'Garton'),
                                controller: passwordcontroller,
                                key: ValueKey(2),
                                obscureText: true,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    passwordcontroller.clear();
                                  }
                                },
                                validator: (value) {
                                  if (!checkPossiblePasswordText(
                                          passwordcontroller.text)
                                      .isCorrectWord) {
                                    return '비밀번호를 제대로 입력해주세요.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  password = value!;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff5EA152),
                                        )),
                                    hintText: '비밀번호 입력',
                                    hintStyle: TextStyle(fontFamily: 'Simple')),
                                keyboardType: TextInputType.visiblePassword,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: height * 0.03,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text('비밀번호 찾기',
                                      style: TextStyle(
                                          fontSize: width * 0.03,
                                          color: Colors.black)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              '비밀번호 찾기',
                                              style: TextStyle(
                                                  fontFamily: 'Simple'),
                                            ),
                                            content: SizedBox(
                                                height: height * 0.18,
                                                width: width,
                                                child: Form(
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        onSaved: (value) {
                                                          email = value!;
                                                        },
                                                        controller:
                                                            findcontroller,
                                                        onChanged: (value) {
                                                          if (value.isEmpty) {
                                                            findcontroller
                                                                .clear();
                                                          }
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    width: 1,
                                                                    color: Color(
                                                                        0xff5EA152),
                                                                  )),
                                                          hintText:
                                                              'email입력, abc@email.com',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          authController
                                                              .resetPassword(
                                                                  findcontroller
                                                                      .text);
                                                        },
                                                        child: Text(
                                                          '이메일 보내기',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  '확인',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  '닫기',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: width * 0.15,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0x805EA152),
                          ),
                          onPressed: () async {
                            _tryValidation();
                            if (_formKey.currentState!.validate()) {
                              appdata.isLoadingScreen = true;

                              if (await authController.login(
                                      emailcontroller.text,
                                      passwordcontroller.text,
                                      storage) ==
                                  true) {
                                appdata.isLoadingScreen = false;
                                toastMessage('접속 성공 !');
                                Get.off(() => MainPage());
                              } else {
                                appdata.isLoadingScreen = false;
                                toastMessage('로그인 실패');
                              }
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
                  ),
                ))),
              )),
        ),
      );
    });
  }
}
