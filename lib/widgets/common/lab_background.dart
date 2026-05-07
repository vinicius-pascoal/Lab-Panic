import 'package:flutter/material.dart';
import '../../config/colors.dart';

class LabBackground extends StatelessWidget {
  const LabBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/fundo.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),

        // Gradient overlay to keep UI readable over the image
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.72),
                  AppColors.backgroundSecondary.withOpacity(0.56),
                  AppColors.background.withOpacity(0.72),
                ],
              ),
            ),
          ),
        ),

        // Orbs and overlay elements
        const Positioned(
          top: -120,
          right: -80,
          child: _GlowOrb(color: AppColors.combo, size: 260),
        ),
        const Positioned(
          bottom: 60,
          left: -100,
          child: _GlowOrb(color: AppColors.circle, size: 220),
        ),
        const Positioned.fill(child: _GridOverlay()),

        // The app content floats above the background
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

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

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _GridPainter()));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
