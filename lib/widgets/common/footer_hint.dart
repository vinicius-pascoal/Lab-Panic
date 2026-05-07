import 'package:flutter/material.dart';

class FooterHint extends StatelessWidget {
  const FooterHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Dica: mantenha os olhos nas bordas do laboratório. A pressão sobe rápido.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
