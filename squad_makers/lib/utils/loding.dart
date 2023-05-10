import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/model/app_view_model.dart';

class Loading extends StatefulWidget {
  final Widget child;

  Loading({required this.child});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppViewModel appData = Get.find();
    return Stack(
      children: [
        widget.child,
        Visibility(
          visible: appData.isLoadingScreen,
          child: SizedBox.expand(
            child: Container(
              color: Colors.black.withOpacity(.3),
            ),
          ),
        ),
        Visibility(
          visible: appData.isLoadingScreen,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0x805EA152),
            ),
          ),
        ),
      ],
    );
  }
}

class StaticLoading extends StatelessWidget {
  const StaticLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Container(
            // color: Colors.black.withOpacity(.5),
            color: Colors.transparent,
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            color: Color(0x805EA152),
          ),
        ),
      ],
    );
  }
}
