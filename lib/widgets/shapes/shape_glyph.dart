import 'package:flutter/material.dart';
import '../../config/enums.dart';

class ShapeGlyph extends StatelessWidget {
  const ShapeGlyph({super.key, required this.shape, this.size = 64});

  final ShapeType shape;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ShapeGlyphPainter(shape: shape)),
    );
  }
}

class _ShapeGlyphPainter extends CustomPainter {
  _ShapeGlyphPainter({required this.shape});

  final ShapeType shape;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = shape.color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.4);
    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    switch (shape) {
      case ShapeType.circle:
        canvas.drawCircle(rect.center, rect.width / 2, fillPaint);
        canvas.drawCircle(rect.center, rect.width / 2, strokePaint);
        break;
      case ShapeType.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(12)),
          fillPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(12)),
          strokePaint,
        );
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeGlyphPainter oldDelegate) =>
      oldDelegate.shape != shape;
}
