import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/enums.dart';

class BinPanel extends StatelessWidget {
  const BinPanel({required this.shape});

  final ShapeType shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: shape.color.withOpacity(0.28), width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Center(child: _binImageFor(shape))),
          const SizedBox(height: 8),
          Text(
            shape.shortLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _binImageFor(ShapeType shape) {
    final asset = switch (shape) {
      ShapeType.circle => 'assets/images/caixa_circulo.png',
      ShapeType.square => 'assets/images/caixa_quadrado.png',
      ShapeType.triangle => 'assets/images/caixa_triangulo.png',
    };

    return SizedBox(height: 48, child: Image.asset(asset, fit: BoxFit.contain));
  }
}
