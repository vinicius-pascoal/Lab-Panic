import 'package:flutter/material.dart';
import '../../config/colors.dart';

class TopBadge extends StatelessWidget {
  const TopBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.76),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border.withOpacity(0.8)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
