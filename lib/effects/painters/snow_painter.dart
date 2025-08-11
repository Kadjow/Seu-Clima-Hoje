import 'package:flutter/material.dart';
import 'dart:math';

class SnowPainter extends CustomPainter {
  final Random _random = Random();
  final List<Offset> _flakes = [];

  SnowPainter() {
    for (int i = 0; i < 50; i++) {
      _flakes.add(Offset(_random.nextDouble() * 400, _random.nextDouble() * 800));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var flake in _flakes) {
      canvas.drawCircle(flake, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
