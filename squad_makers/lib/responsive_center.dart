import 'package:flutter/material.dart';

class ResposiveCenter extends StatelessWidget {
  const ResposiveCenter(
      {super.key,
      required this.maxContentWidth,
      required this.padding,
      required this.child});
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
