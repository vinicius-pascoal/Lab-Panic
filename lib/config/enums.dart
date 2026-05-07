import 'package:flutter/material.dart';
import 'colors.dart';

enum AppScreen { splash, menu, howToPlay, game, gameOver }

enum ShapeType { circle, square, triangle }

extension ShapeTypeX on ShapeType {
  String get label => switch (this) {
    ShapeType.circle => 'Círculo',
    ShapeType.square => 'Quadrado',
    ShapeType.triangle => 'Triângulo',
  };

  String get shortLabel => switch (this) {
    ShapeType.circle => 'Círculo',
    ShapeType.square => 'Quadrado',
    ShapeType.triangle => 'Triângulo',
  };

  Color get color => switch (this) {
    ShapeType.circle => AppColors.circle,
    ShapeType.square => AppColors.square,
    ShapeType.triangle => AppColors.triangle,
  };

  IconData get icon => switch (this) {
    ShapeType.circle => Icons.circle,
    ShapeType.square => Icons.crop_square,
    ShapeType.triangle => Icons.change_history_rounded,
  };

  int get index => switch (this) {
    ShapeType.circle => 0,
    ShapeType.square => 1,
    ShapeType.triangle => 2,
  };
}
