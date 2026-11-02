import 'package:flutter/material.dart';

class AnimatedNumberText extends StatelessWidget {
  final double value;
  final TextStyle style;
  final Curve curve;
  final String Function(double value) formatter;

  const AnimatedNumberText({
    super.key,
    required this.value,
    required this.style,
    required this.formatter,
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween<double>(
        begin: 0,
        end: value,
      ),
      duration: const Duration(milliseconds: 400),
      curve: curve,
      builder: (context, animatedValue, _) {
        return Text(
          formatter(animatedValue),
          style: style,
        );
      },
    );
  }
}
