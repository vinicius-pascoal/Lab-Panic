import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../widgets/common/lab_background.dart';
import '../widgets/common/score_card.dart';
import '../widgets/decorations/lab_pulse_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.bestScore});

  final int bestScore;

  @override
  Widget build(BuildContext context) {
    return LabBackground(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LabPulseLogo(size: 112),
              const SizedBox(height: 20),
              ScoreCard(
                title: 'Melhor pontuação',
                value: '$bestScore',
                accent: AppColors.combo,
              ),
              const SizedBox(height: 12),
              Text(
                'Arraste cada forma para o recipiente correto antes que a linha entre em falha.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
