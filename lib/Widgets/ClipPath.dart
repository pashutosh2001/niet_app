import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(5, size.height - 30, 25, size.height - 25);
    path.lineTo(size.width - 25, size.height - 25);
    path.quadraticBezierTo(
        size.width - 5, size.height - 25, size.width, size.height);
    // path.lineTo(size.width , 25);
    path.lineTo(size.width, 0);

    path.close();

    return path;
    // path.
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
