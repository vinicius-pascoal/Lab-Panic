import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/enums.dart';
import '../shapes/shape_glyph.dart';

class DraggableShape extends StatelessWidget {
  const DraggableShape({required this.shape, required this.size});

  final ShapeType shape;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withOpacity(0.45)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: ShapeGlyph(shape: shape),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.36),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: shape.color.withOpacity(0.3)),
          ),
          child: Text(
            shape.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: shape.color,
            ),
          ),
        ),
      ],
    );
  }
}
