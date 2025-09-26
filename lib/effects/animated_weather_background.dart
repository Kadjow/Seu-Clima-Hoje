import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_app/context/animation_context.dart';
import 'package:weather_app/effects/painters/animated_sun.dart';

class AnimatedWeatherBackground extends StatefulWidget {
  final String condition;

  const AnimatedWeatherBackground({Key? key, required this.condition})
      : super(key: key);

  @override
  State<AnimatedWeatherBackground> createState() =>
      _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<_Particle> _particles = [];

  double _lightningOpacity = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(() {
        if (widget.condition == 'thunderstorm') {
          if (_random.nextDouble() < 0.005) {
            _lightningOpacity = 1;
          } else {
            _lightningOpacity = (_lightningOpacity - 0.05).clamp(0, 1);
          }
        }
        setState(() {});
      });

    for (int i = 0; i < 100; i++) {
      _particles.add(_Particle(_random));
    }
  }

  void _updateAnimationStatus() {
    final enabled = AnimationContext.of(context).enabled;
    if (enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimationStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundColor() {
    switch (widget.condition) {
      case 'rain':
      case 'drizzle':
        return Colors.blueGrey.shade800;
      case 'snow':
        return Colors.blueGrey.shade200;
      case 'mist':
        return Colors.grey.shade600;
      case 'clouds':
        return Colors.blueGrey.shade700;
      case 'thunderstorm':
        return Colors.indigo.shade900;
      default:
        return Colors.lightBlue.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animEnabled = AnimationContext.of(context).enabled;
    if (!animEnabled) {
      return Container(color: _backgroundColor());
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        for (var p in _particles) {
          p.update(widget.condition);
        }

        return Container(
          color: _backgroundColor(),
          child: Stack(
            children: [
              if (widget.condition == 'clear') const AnimatedSun(),
              if (widget.condition == 'clouds')
                CustomPaint(
                  painter: _CloudPainter(_controller.value),
                  size: Size.infinite,
                ),
              CustomPaint(
                painter: _WeatherPainter(widget.condition, _particles),
                size: Size.infinite,
              ),
              if (widget.condition == 'thunderstorm')
                Container(
                  color: Colors.white.withOpacity(_lightningOpacity),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double speed;
  double size;
  final Random random;

  _Particle(this.random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        speed = 0.002 + random.nextDouble() * 0.004,
        size = 2 + random.nextDouble() * 3;

  void update(String condition) {
    y += speed;
    if (y > 1.0) {
      y = 0;
      x = random.nextDouble();
    }
  }
}

class _WeatherPainter extends CustomPainter {
  final String condition;
  final List<_Particle> particles;

  _WeatherPainter(this.condition, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var p in particles) {
      final dx = p.x * size.width;
      final dy = p.y * size.height;

      switch (condition) {
        case 'rain':
        case 'drizzle':
          paint.color = Colors.blueAccent.withOpacity(0.7);
          paint.strokeWidth = 2;
          canvas.drawLine(Offset(dx, dy), Offset(dx, dy + 10), paint);
          break;

        case 'snow':
          paint.color = Colors.white.withOpacity(0.8);
          canvas.drawCircle(Offset(dx, dy), p.size, paint);
          break;

        case 'mist':
          paint.color = Colors.white.withOpacity(0.1);
          canvas.drawCircle(Offset(dx, dy), p.size * 2, paint);
          break;

        default:
          paint.color = Colors.transparent;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CloudPainter extends CustomPainter {
  final double progress;

  _CloudPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);

    final cloudWidth = 150.0;
    final offsetX = (size.width + cloudWidth) * progress - cloudWidth;

    for (int i = 0; i < 3; i++) {
      final y = 50.0 + i * 60;
      canvas.drawOval(
        Rect.fromLTWH(offsetX - (i * 80), y, cloudWidth, 60),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
