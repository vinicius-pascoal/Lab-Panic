class GameConstants {
  // Timings
  static const Duration splashDuration = Duration(milliseconds: 1400);
  static const Duration gameTick = Duration(milliseconds: 16);
  static const Duration feedbackDuration = Duration(milliseconds: 800);
  static const Duration animationDuration = Duration(milliseconds: 280);

  // Layout
  static const double headerHeight = 112;
  static const double binZoneHeight = 182;
  static const double shapeSize = 68;

  // Game mechanics
  static const int initialLives = 3;
  static const int acertScore = 100;
  static const int combo3Bonus = 50;
  static const int combo5Bonus = 100;

  // Speed stages (pixels per second)
  static const double speedStage1 = 122; // 0-20s
  static const double speedStage2 = 168; // 20-45s
  static const double speedStage3 = 222; // 45-75s
  static const double speedStage4 = 282; // 75s+

  // Speed stage times (seconds)
  static const int speedStage1End = 20;
  static const int speedStage2End = 45;
  static const int speedStage3End = 75;

  // Storage keys
  static const String bestScoreKey = 'lab_panic_best_score';

  // Asset paths
  static const String backgroundImage = 'assets/images/fundo.png';
  static const String binCircleImage = 'assets/images/caixa_circulo.png';
  static const String binSquareImage = 'assets/images/caixa_quadrado.png';
  static const String binTriangleImage = 'assets/images/caixa_triangulo.png';
}

class LayoutConstants {
  static const double padding = 20.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double largePadding = 16.0;

  static const double borderRadius = 24.0;
  static const double smallBorderRadius = 18.0;
  static const double tinyBorderRadius = 20.0;
}
