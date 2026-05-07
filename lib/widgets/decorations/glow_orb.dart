import 'package:flutter/material.dart';

class GlowOrb extends StatelessWidget {
  const GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.32), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}
