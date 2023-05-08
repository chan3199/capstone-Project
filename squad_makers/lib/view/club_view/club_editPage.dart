import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/controller/image_picker.dart';

class ClubEditPage extends StatefulWidget {
  const ClubEditPage({super.key});

  @override
  State<ClubEditPage> createState() => _ClubEditPageState();
}

class _ClubEditPageState extends State<ClubEditPage> {
  final clubnameController = TextEditingController();
  final clubinfoController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _image;

  Widget _clubimage() {
    return _image == null
        ? ElevatedButton(
            onPressed: () async {
              _image = await imagePickUploader.getImage();
            },
            child: CircleAvatar(
              backgroundColor: Color(0xffd6d6d6),
              radius: 50,
              child: Icon(
                Icons.image,
                color: Colors.white,
                size: 50,
              ),
            ),
            style:
                ElevatedButton.styleFrom(elevation: 0, shape: CircleBorder()),
          )
        : ElevatedButton(
            onPressed: () async {
              _image = await imagePickUploader.getImage();
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(File(_image!.path)),
            ),
            style:
                ElevatedButton.styleFrom(elevation: 0, shape: CircleBorder()),
          );
  }

  @override
  void dispose() {
    clubnameController.dispose();
    clubinfoController.dispose();
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
                  _clubimage(),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    '클럽 이름',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: clubnameController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            clubnameController.clear();
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
                          hintText: '클럽 이름을 입력해주세요.',
                        ),
                        keyboardType: TextInputType.name,
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    '클럽 소개',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      height: height * 0.07,
                      width: width * 0.7,
                      child: TextFormField(
                        controller: clubinfoController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            clubinfoController.clear();
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
                          hintText: '클럽을 간단히 소개해주세요',
                        ),
                        keyboardType: TextInputType.name,
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0x805EA152),
                      ),
                      onPressed: () => {},
                      child: Text(
                        '클럽 생성',
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
