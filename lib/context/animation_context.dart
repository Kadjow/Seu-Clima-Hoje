import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimationContext extends StatefulWidget {
  final Widget child;
  const AnimationContext({super.key, required this.child});

  static _AnimationControllerInherited of(BuildContext context) {
    return _AnimationControllerInherited.of(context);
  }

  @override
  State<AnimationContext> createState() => _AnimationContextState();
}

class _AnimationContextState extends State<AnimationContext> {
  bool _enabled = true;

  bool get animationsEnabled => _enabled;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.getBool('animationsEnabled') ?? true;
    });
  }

  Future<void> toggle() async {
    setState(() {
      _enabled = !_enabled;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animationsEnabled', _enabled);
  }

  @override
  Widget build(BuildContext context) {
    return _AnimationControllerInherited(
      enabled: _enabled,
      toggle: toggle,
      child: widget.child,
    );
  }
}

class _AnimationControllerInherited extends InheritedWidget {
  final bool enabled;
  final Future<void> Function() toggle;

  const _AnimationControllerInherited({
    required this.enabled,
    required this.toggle,
    required super.child,
  });

  static _AnimationControllerInherited of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_AnimationControllerInherited>();
    assert(inherited != null, 'No AnimationContext found in context');
    return inherited!;
  }

  @override
  bool updateShouldNotify(
      covariant _AnimationControllerInherited oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
