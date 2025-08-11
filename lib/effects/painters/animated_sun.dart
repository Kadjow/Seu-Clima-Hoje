import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedSun extends StatefulWidget {
  const AnimatedSun({Key? key}) : super(key: key);

  @override
  State<AnimatedSun> createState() => _AnimatedSunState();
}

class _AnimatedSunState extends State<AnimatedSun>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _SunPainter(_controller.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class _SunPainter extends CustomPainter {
  final double progress;

  _SunPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.25);
    const sunRadius = 60.0;

    // Gradiente de fundo (céu animado)
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(Colors.lightBlue.shade300, Colors.lightBlue.shade400, progress)!,
        Color.lerp(Colors.lightBlue.shade200, Colors.lightBlue.shade300, progress)!,
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    // Sol
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow.shade300,
          Colors.yellow.shade600,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: sunRadius));

    canvas.drawCircle(center, sunRadius, sunPaint);

    // Raios do sol animados
    final raysPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const raysCount = 24;
    for (int i = 0; i < raysCount; i++) {
      final angle = (2 * pi * i / raysCount) + (progress * 2 * pi);
      final start = Offset(
        center.dx + cos(angle) * (sunRadius + 5),
        center.dy + sin(angle) * (sunRadius + 5),
      );
      final end = Offset(
        center.dx + cos(angle) * (sunRadius + 20),
        center.dy + sin(angle) * (sunRadius + 20),
      );
      canvas.drawLine(start, end, raysPaint);
    }

    final glowPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.2 + 0.2 * sin(progress * 2 * pi))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawCircle(center, sunRadius + 25, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _SunPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
