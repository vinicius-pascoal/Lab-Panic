import 'package:flutter/material.dart';
import '../../config/colors.dart';

class LabPulseLogo extends StatelessWidget {
  const LabPulseLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [AppColors.combo, AppColors.backgroundSecondary],
          radius: 0.92,
        ),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.combo.withOpacity(0.3),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textPrimary.withOpacity(0.28),
                  width: 1.5,
                ),
              ),
            ),
            const Icon(
              Icons.science_rounded,
              color: AppColors.textPrimary,
              size: 48,
            ),
          ],
        ),
      ),
    );
  }
}
