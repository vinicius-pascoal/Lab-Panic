import 'package:flutter/material.dart';
import '../../config/colors.dart';

class PlayfieldBackground extends StatelessWidget {
  const PlayfieldBackground({
    required this.boardSize,
    required this.binZoneHeight,
  });

  final Size boardSize;
  final double binZoneHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border.withOpacity(0.55)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: _PlayfieldPainter(binZoneHeight: binZoneHeight),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            top: 18,
            child: Container(
              height: 1,
              color: AppColors.combo.withOpacity(0.24),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayfieldPainter extends CustomPainter {
  _PlayfieldPainter({required this.binZoneHeight});

  final double binZoneHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = AppColors.border.withOpacity(0.24)
      ..strokeWidth = 1;
    final zonePaint = Paint()
      ..color = AppColors.backgroundSecondary.withOpacity(0.78);
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.03);

    final zoneTop = size.height - binZoneHeight;
    canvas.drawRect(
      Rect.fromLTWH(0, zoneTop, size.width, binZoneHeight),
      zonePaint,
    );
    canvas.drawLine(
      Offset(0, zoneTop),
      Offset(size.width, zoneTop),
      borderPaint,
    );

    const step = 32.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, zoneTop), gridPaint);
    }
    for (double y = 0; y <= zoneTop; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlayfieldPainter oldDelegate) {
    return oldDelegate.binZoneHeight != binZoneHeight;
  }
}
