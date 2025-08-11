import 'package:flutter/material.dart';

class FogPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.3);

    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * 80.0, size.width, 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
