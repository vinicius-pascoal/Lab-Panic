import 'package:flutter/material.dart';
import '../../config/colors.dart';

class RecordBadge extends StatelessWidget {
  const RecordBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.combo.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.combo.withOpacity(0.52)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_rounded, color: AppColors.warning, size: 18),
          SizedBox(width: 8),
          Text(
            'Novo recorde de laboratório',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
