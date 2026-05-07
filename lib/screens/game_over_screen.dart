import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../data/models/game_result.dart';
import '../widgets/common/lab_background.dart';
import '../widgets/common/primary_action_button.dart';
import '../widgets/common/secondary_action_button.dart';
import '../widgets/common/score_card.dart';
import '../widgets/decorations/record_badge.dart';
import '../widgets/common/top_badge.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({
    super.key,
    required this.result,
    required this.bestScore,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  final GameResult result;
  final int bestScore;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  @override
  Widget build(BuildContext context) {
    final isNewRecord = result.score >= bestScore && result.score > 0;

    return LabBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const TopBadge(text: 'COLAPSO CONTROLADO'),
              const Spacer(),
              const Icon(
                Icons.warning_amber_rounded,
                size: 92,
                color: AppColors.warning,
              ),
              const SizedBox(height: 18),
              const Text(
                'Fim de jogo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sua linha entrou em falha, mas o laboratório ainda pode melhorar esse resultado.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 22),
              ScoreCard(
                title: 'Pontuação final',
                value: '${result.score}',
                accent: AppColors.success,
              ),
              const SizedBox(height: 14),
              ScoreCard(
                title: 'Melhor pontuação',
                value: '$bestScore',
                accent: isNewRecord ? AppColors.combo : AppColors.square,
              ),
              const SizedBox(height: 10),
              if (isNewRecord) const RecordBadge(),
              const SizedBox(height: 22),
              PrimaryActionButton(
                label: 'Jogar novamente',
                icon: Icons.refresh_rounded,
                onPressed: onPlayAgain,
              ),
              const SizedBox(height: 12),
              SecondaryActionButton(
                label: 'Voltar ao menu',
                icon: Icons.home_rounded,
                onPressed: onBackToMenu,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
