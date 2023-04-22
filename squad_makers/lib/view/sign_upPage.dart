import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
                child: Center(
                    child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Image.asset('assets/maintext.png',
                    height: height * 0.1, width: width * 0.5),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  '이름',
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
                            borderSide:
                                BorderSide(width: 1, color: Colors.green)),
                        hintText: '이름 입력, 이름은 2글자 이상입니다.',
                      ),
                      keyboardType: TextInputType.name,
                    )),
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
                            borderSide:
                                BorderSide(width: 1, color: Colors.green)),
                        hintText: 'email 입력, ex)abc@email.com',
                      ),
                      keyboardType: TextInputType.name,
                    )),
                SizedBox(
                  height: height * 0.05,
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
                            borderSide:
                                BorderSide(width: 1, color: Colors.green)),
                        hintText: '비밀번호 입력',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    )),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                    height: height * 0.07,
                    width: width * 0.7,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.green)),
                        hintText: '비밀번호 확인, 비밀번호를 한번 더 입력해주세요.',
                      ),
                      keyboardType: TextInputType.name,
                    )),
                SizedBox(
                  height: height * 0.05,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.5)),
                    onPressed: () {},
                    child: Text(
                      'Sign-Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.05,
                          fontFamily: 'Garton',
                          fontWeight: FontWeight.bold),
                    ))
              ],
            )))));
  }
}
