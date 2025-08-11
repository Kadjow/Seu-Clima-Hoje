import 'package:flutter/material.dart';

class AnimatedThunderstorm extends StatefulWidget {
  const AnimatedThunderstorm({Key? key}) : super(key: key);

  @override
  State<AnimatedThunderstorm> createState() => _AnimatedThunderstormState();
}

class _AnimatedThunderstormState extends State<AnimatedThunderstorm>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black.withOpacity(0.2)),
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 0.7).animate(
            CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
          ),
          child: Container(color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }
}
