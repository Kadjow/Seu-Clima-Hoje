import 'package:flutter/material.dart';
import 'dart:math';

class RainPainter extends CustomPainter {
  final Random _random = Random();
  final List<Offset> _drops = [];

  RainPainter() {
    for (int i = 0; i < 100; i++) {
      _drops.add(Offset(_random.nextDouble() * 400, _random.nextDouble() * 800));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade300
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var drop in _drops) {
      canvas.drawLine(drop, drop.translate(0, 10), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
