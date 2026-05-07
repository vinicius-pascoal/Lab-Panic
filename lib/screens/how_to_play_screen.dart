import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/enums.dart';
import '../widgets/common/lab_background.dart';
import '../widgets/common/primary_action_button.dart';
import '../widgets/common/info_card.dart';
import '../widgets/game/game_components.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LabBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Como jogar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InfoCard(
                        title: 'Objetivo',
                        child: Text(
                          'Organize as formas que caem no recipiente certo antes que elas cruzem a linha de segurança.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 14),
                      InfoCard(
                        title: 'Formas e recipientes',
                        child: Column(
                          children: const [
                            MatchRow(
                              shape: ShapeType.circle,
                              label: 'vai para o recipiente circular',
                            ),
                            SizedBox(height: 10),
                            MatchRow(
                              shape: ShapeType.square,
                              label: 'vai para o recipiente quadrado',
                            ),
                            SizedBox(height: 10),
                            MatchRow(
                              shape: ShapeType.triangle,
                              label: 'vai para o recipiente triangular',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      InfoCard(
                        title: 'Regras rápidas',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            RuleBullet(text: 'Cada acerto vale +100 pontos.'),
                            RuleBullet(
                              text: 'Combo de 3 acertos dá bônus de +50.',
                            ),
                            RuleBullet(
                              text: 'Combo de 5 acertos dá bônus de +100.',
                            ),
                            RuleBullet(text: 'Você começa com 3 vidas.'),
                            RuleBullet(text: 'Erros e perdas reduzem 1 vida.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryActionButton(
                label: 'Voltar',
                icon: Icons.arrow_back_rounded,
                onPressed: onBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
