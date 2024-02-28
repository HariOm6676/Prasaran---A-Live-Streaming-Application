import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobilebody;
  final Widget dekstopbody;
  const ResponsiveLayout(
      {super.key, required this.mobilebody, required this.dekstopbody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return mobilebody;
      } else {
        return dekstopbody;
      }
    });
  }
}
