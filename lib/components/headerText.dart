import 'package:flutter/material.dart';

Widget animatedGradientText({
  required String text,
  required Gradient gradient,
  double fontSize = 30.0,
  FontWeight fontWeight = FontWeight.bold,
  Duration duration = const Duration(seconds: 2),
}) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: duration,
    builder: (context, value, child) {
      return Opacity(
        opacity: value,
        child: ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white, // This color is masked by the gradient
            ),
          ),
        ),
      );
    },
  );
}
