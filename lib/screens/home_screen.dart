import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../widgets/common/lab_background.dart';
import '../widgets/common/primary_action_button.dart';
import '../widgets/common/secondary_action_button.dart';
import '../widgets/common/score_card.dart';
import '../widgets/common/footer_hint.dart';
import '../widgets/decorations/lab_pulse_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.bestScore,
    required this.onPlay,
    required this.onHowToPlay,
  });

  final int bestScore;
  final VoidCallback onPlay;
  final VoidCallback onHowToPlay;

  @override
  Widget build(BuildContext context) {
    return LabBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Spacer(),
              const LabPulseLogo(size: 128),
              const SizedBox(height: 18),
              const Text(
                'LAB PANIC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Arraste cada forma para o recipiente correto antes que a linha entre em falha.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              ScoreCard(
                title: 'Melhor pontuação',
                value: '$bestScore',
                accent: AppColors.combo,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'Jogar',
                icon: Icons.play_arrow_rounded,
                onPressed: onPlay,
              ),
              const SizedBox(height: 12),
              SecondaryActionButton(
                label: 'Como jogar',
                icon: Icons.info_outline_rounded,
                onPressed: onHowToPlay,
              ),
              const Spacer(),
              const FooterHint(),
            ],
          ),
        ),
      ),
    );
  }
}
