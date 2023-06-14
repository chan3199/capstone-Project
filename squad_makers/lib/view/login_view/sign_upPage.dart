import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/auth_controller.dart';
import 'package:squad_makers/controller/user_controller.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/controller/Database_controller.dart';
import 'package:squad_makers/controller/checkValidation.dart';
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
  final _formKey = GlobalKey<FormState>();
  late bool isOk;
  String email = '';
  String nickname = '';
  String password = '';
  String checkpass = '';
  String name = '';
  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

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
                      child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Image.asset('assets/maintext.png',
                        height: height * 0.05, width: width * 0.5),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Text(
                      '이름',
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                    Container(
                        height: height * 0.1,
                        width: width * 0.7,
                        child: Container(
                          child: TextFormField(
                            key: ValueKey(4),
                            controller: nameController,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                nameController.clear();
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '이름을 입력해주세요';
                              } else if (!validateName(nameController.text)) {
                                return '한글 2~4자, 영문 2~10자 이내입니다.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              name = value!;
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
                          ),
                        )),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '닉네임',
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                    Container(
                        height: height * 0.1,
                        width: width * 0.7,
                        child: TextFormField(
                          key: ValueKey(5),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '별명을 입력해주세요';
                            } else if (isOk) {
                              return '중복된 별병입니다.';
                            } else if (!validateName(nicknameController.text)) {
                              return '한글 2~4자, 영문 2~10자 이내입니다.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
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
                      height: height * 0.01,
                    ),
                    Text(
                      'e-mail',
                      style: TextStyle(fontSize: width * 0.04),
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
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '비밀번호',
                      style: TextStyle(
                          fontSize: width * 0.04, fontFamily: 'Simple'),
                    ),
                    Container(
                        height: height * 0.1,
                        width: width * 0.7,
                        child: TextFormField(
                          style: TextStyle(fontFamily: 'Garton'),
                          key: ValueKey(2),
                          obscureText: true,
                          controller: passwordController,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              passwordController.clear();
                            }
                          },
                          validator: (value) {
                            if (!checkPossiblePasswordText(
                                    passwordController.text)
                                .isCorrectWord) {
                              return '비밀번호를 다시 입력해주세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value!;
                          },
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontFamily: 'Simple'),
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
                      height: height * 0.01,
                    ),
                    Text(
                      '비밀번호 확인',
                      style: TextStyle(
                          fontSize: width * 0.04, fontFamily: 'Simple'),
                    ),
                    Container(
                        height: height * 0.1,
                        width: width * 0.7,
                        child: TextFormField(
                          style: TextStyle(fontFamily: 'Garton'),
                          key: ValueKey(3),
                          obscureText: true,
                          controller: checkpassController,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              checkpassController.clear();
                            }
                          },
                          validator: (value) {
                            if (!(passwordController.text ==
                                checkpassController.text)) {
                              return '비밀번호가 일치하지 않습니다!';
                            } else if (value!.isEmpty) {
                              return '비밀번호를 입력해주세요!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            checkpass = value!;
                          },
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontFamily: 'Simple'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0x805EA152),
                            ),
                            onPressed: () async {
                              isOk =
                                  await databasecontroller.isDuplicatedNickname(
                                      nicknameController.text);

                              _tryValidation();
                            },
                            child: Text(
                              '제출',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          width: width * 0.2,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0x805EA152),
                            ),
                            onPressed: () => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      authController.signUpUserCredential(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          nickname: nicknameController.text,
                                          name: nameController.text),
                                      Get.off(() => LoginPage())
                                    }
                                  else
                                    {toastMessage('회원가입 형식을 제대로 채워주세요!')}
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
                    ),
                  ],
                ),
              ))))),
    );
  }
}
