import 'package:flutter/material.dart';
import '../../config/enums.dart';
import 'shape_glyph.dart';

class ShapeToken extends StatelessWidget {
  const ShapeToken({required this.shape, required this.size});

  final ShapeType shape;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ShapeGlyph(shape: shape),
    );
  }
}
