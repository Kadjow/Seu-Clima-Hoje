import 'package:flutter/material.dart';

class CloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.shade300.withOpacity(0.7);
    canvas.drawCircle(Offset(size.width * 0.3, 100), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.5, 130), 80, paint);
    canvas.drawCircle(Offset(size.width * 0.7, 100), 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
