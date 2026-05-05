import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppScreen { splash, menu, howToPlay, game, gameOver }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.combo,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab Panic',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: AppColors.textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.45,
            color: AppColors.textSecondary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      home: LabPanicApp(),
    );
  }
}

class LabPanicApp extends StatefulWidget {
  const LabPanicApp({super.key});

  @override
  State<LabPanicApp> createState() => _LabPanicAppState();
}

class _LabPanicAppState extends State<LabPanicApp> {
  static const String _bestScoreKey = 'lab_panic_best_score';

  AppScreen _screen = AppScreen.splash;
  int _bestScore = 0;
  GameResult? _lastResult;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _loadBestScore();
    _splashTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _screen = AppScreen.menu;
      });
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _bestScore = prefs.getInt(_bestScoreKey) ?? 0;
    });
  }

  Future<void> _handleGameOver(GameResult result) async {
    if (result.score > _bestScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_bestScoreKey, result.score);
      if (mounted) {
        setState(() {
          _bestScore = result.score;
        });
      }
    }

    if (!mounted) return;

    setState(() {
      _lastResult = result;
      _screen = AppScreen.gameOver;
    });
  }

  void _openHowToPlay() {
    setState(() {
      _screen = AppScreen.howToPlay;
    });
  }

  void _startGame() {
    setState(() {
      _screen = AppScreen.game;
      _lastResult = null;
    });
  }

  void _backToMenu() {
    setState(() {
      _screen = AppScreen.menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (_screen) {
        AppScreen.splash => SplashScreen(
          key: const ValueKey('splash'),
          bestScore: _bestScore,
        ),
        AppScreen.menu => HomeScreen(
          key: const ValueKey('menu'),
          bestScore: _bestScore,
          onPlay: _startGame,
          onHowToPlay: _openHowToPlay,
        ),
        AppScreen.howToPlay => HowToPlayScreen(
          key: const ValueKey('how_to_play'),
          onBack: _backToMenu,
        ),
        AppScreen.game => GameScreen(
          key: const ValueKey('game'),
          onExitToMenu: _backToMenu,
          onGameOver: _handleGameOver,
        ),
        AppScreen.gameOver => GameOverScreen(
          key: const ValueKey('game_over'),
          result: _lastResult ?? const GameResult(score: 0, combo: 0),
          bestScore: _bestScore,
          onPlayAgain: _startGame,
          onBackToMenu: _backToMenu,
        ),
      },
    );
  }
}

class AppColors {
  static const background = Color(0xFF0B0F14);
  static const backgroundSecondary = Color(0xFF111827);
  static const surface = Color(0xFF1F2937);
  static const border = Color(0xFF4B5563);

  static const textPrimary = Color(0xFFF9FAFB);
  static const textSecondary = Color(0xFFCBD5E1);

  static const circle = Color(0xFF06B6D4);
  static const square = Color(0xFFF59E0B);
  static const triangle = Color(0xFFEF4444);

  static const success = Color(0xFF10B981);
  static const error = Color(0xFFDC2626);
  static const warning = Color(0xFFFBBF24);
  static const combo = Color(0xFF3B82F6);
}

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

class GameResult {
  const GameResult({required this.score, required this.combo});

  final int score;
  final int combo;
}

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
              const _LabPulseLogo(size: 112),
              const SizedBox(height: 20),
              _ScoreCard(
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
              const _LabPulseLogo(size: 128),
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
              _ScoreCard(
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
              const _FooterHint(),
            ],
          ),
        ),
      ),
    );
  }
}

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
                      _InfoCard(
                        title: 'Objetivo',
                        child: Text(
                          'Organize as formas que caem no recipiente certo antes que elas cruzem a linha de segurança.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _InfoCard(
                        title: 'Formas e recipientes',
                        child: Column(
                          children: const [
                            _MatchRow(
                              shape: ShapeType.circle,
                              label: 'vai para o recipiente circular',
                            ),
                            SizedBox(height: 10),
                            _MatchRow(
                              shape: ShapeType.square,
                              label: 'vai para o recipiente quadrado',
                            ),
                            SizedBox(height: 10),
                            _MatchRow(
                              shape: ShapeType.triangle,
                              label: 'vai para o recipiente triangular',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _InfoCard(
                        title: 'Regras rápidas',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _RuleBullet(text: 'Cada acerto vale +100 pontos.'),
                            _RuleBullet(
                              text: 'Combo de 3 acertos dá bônus de +50.',
                            ),
                            _RuleBullet(
                              text: 'Combo de 5 acertos dá bônus de +100.',
                            ),
                            _RuleBullet(text: 'Você começa com 3 vidas.'),
                            _RuleBullet(text: 'Erros e perdas reduzem 1 vida.'),
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

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.onExitToMenu,
    required this.onGameOver,
  });

  final VoidCallback onExitToMenu;
  final ValueChanged<GameResult> onGameOver;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const double _headerHeight = 112;
  static const double _binZoneHeight = 182;
  static const double _shapeSize = 68;
  static const Duration _tick = Duration(milliseconds: 16);

  final Random _random = Random();

  Timer? _timer;
  ShapeType _currentShape = ShapeType.circle;
  Offset _shapePosition = const Offset(0, 24);
  Size _boardSize = Size.zero;
  bool _paused = false;
  bool _dragging = false;
  int _score = 0;
  int _lives = 3;
  int _combo = 0;
  int _elapsedSeconds = 0;
  String? _feedbackText;
  Color _feedbackColor = AppColors.success;
  double _feedbackOpacity = 0;
  bool _boardReady = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_tick, _onTick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTick(Timer timer) {
    if (!mounted || _paused || !_boardReady) {
      return;
    }

    setState(() {
      _elapsedSeconds = timer.tick ~/ (1000 ~/ _tick.inMilliseconds);
      if (!_dragging) {
        final nextY =
            _shapePosition.dy + _fallSpeed * (_tick.inMilliseconds / 1000);
        _shapePosition = Offset(_shapePosition.dx, nextY);
        _checkForMiss();
      }
    });
  }

  double get _fallSpeed {
    if (_elapsedSeconds < 20) {
      return 122;
    }
    if (_elapsedSeconds < 45) {
      return 168;
    }
    if (_elapsedSeconds < 75) {
      return 222;
    }
    return 282;
  }

  double get _laneBottom => _boardSize.height - _binZoneHeight - 8;

  void _spawnShape() {
    final availableWidth = max(24.0, _boardSize.width - _shapeSize - 32);
    _currentShape = ShapeType.values[_random.nextInt(ShapeType.values.length)];
    _shapePosition = Offset(16 + _random.nextDouble() * availableWidth, 18);
  }

  void _resetFeedback() {
    _feedbackOpacity = 0;
    _feedbackText = null;
  }

  void _showFeedback(String text, Color color) {
    _feedbackText = text;
    _feedbackColor = color;
    _feedbackOpacity = 1;
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _resetFeedback();
      });
    });
  }

  void _pauseGame() {
    setState(() {
      _paused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _paused = false;
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _combo = 0;
      _elapsedSeconds = 0;
      _paused = false;
      _dragging = false;
      _resetFeedback();
      _spawnShape();
    });
  }

  void _finishGame() {
    _timer?.cancel();
    widget.onGameOver(GameResult(score: _score, combo: _combo));
  }

  void _loseLife(String reason) {
    setState(() {
      _lives -= 1;
      _combo = 0;
      _showFeedback(reason, AppColors.error);
    });

    if (_lives <= 0) {
      _finishGame();
      return;
    }

    setState(() {
      _spawnShape();
    });
  }

  void _registerSuccess() {
    final nextCombo = _combo + 1;
    final bonus = switch (nextCombo) {
      3 => 50,
      5 => 100,
      _ => 0,
    };

    setState(() {
      _score += 100 + bonus;
      _combo = nextCombo;
      _showFeedback(
        bonus > 0 ? 'Combo +$bonus' : 'Acerto +100',
        AppColors.success,
      );
    });

    setState(() {
      _spawnShape();
    });
  }

  void _checkForMiss() {
    if (_shapePosition.dy < _laneBottom) {
      return;
    }

    _loseLife('Forma perdida');
  }

  Rect _binRectFor(ShapeType shape, double width) {
    // Espaço disponível para bins (menos padding de 16px em cada lado)
    final effectiveWidth = width - 32;
    final binWidth = effectiveWidth / 3;
    // Bins começam em X = 16 (padding do Positioned)
    final left =
        16 + shape.index * binWidth + 4; // +4 para o padding do Expanded

    // Y é relativo ao Stack dentro de Expanded, não ao Column completo
    // Por isso precisamos descontar _headerHeight
    final stackHeight = _boardSize.height - _headerHeight;

    return Rect.fromLTWH(
      left,
      stackHeight - _binZoneHeight + 14,
      binWidth - 8, // -8 para o padding de 4px em cada lado do Expanded
      _binZoneHeight - 24,
    );
  }

  bool _dropMatchesBin(Offset position) {
    final center = position + const Offset(_shapeSize / 2, _shapeSize / 2);
    // Debug: print das coordenadas
    print('Shape center: ${center.dx}, ${center.dy}');
    print('Current shape: $_currentShape');
    for (final shape in ShapeType.values) {
      final rect = _binRectFor(shape, _boardSize.width);
      print(
        '${shape.label} rect: left=${rect.left}, right=${rect.right}, top=${rect.top}, bottom=${rect.bottom}',
      );
      if (rect.contains(center)) {
        if (shape == _currentShape) {
          print('✓ Acertou!');
          return true;
        }
        print('✗ Recipiente errado!');
        _loseLife('Recipiente errado');
        return false;
      }
    }
    print('Não está em nenhum recipiente');
    return false;
  }

  void _handlePanStart(DragStartDetails details) {
    if (_paused) {
      return;
    }
    setState(() {
      _dragging = true;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_paused) {
      return;
    }

    setState(() {
      final nextX = (_shapePosition.dx + details.delta.dx).clamp(
        8.0,
        _boardSize.width - _shapeSize - 8.0,
      );
      final nextY = (_shapePosition.dy + details.delta.dy).clamp(
        8.0,
        _boardSize.height - _shapeSize - 8.0,
      );
      _shapePosition = Offset(nextX, nextY);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_paused) {
      return;
    }

    setState(() {
      _dragging = false;
    });

    final matched = _dropMatchesBin(_shapePosition);
    if (matched) {
      _registerSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LabBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_boardReady &&
                constraints.biggest.width > 0 &&
                constraints.biggest.height > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted || _boardReady) {
                  return;
                }
                setState(() {
                  _boardSize = constraints.biggest;
                  _boardReady = true;
                  _spawnShape();
                });
              });
            }

            return Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Score',
                            value: '$_score',
                            accent: AppColors.combo,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            label: 'Vidas',
                            value: '$_lives',
                            accent: _lives == 1
                                ? AppColors.error
                                : AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          onPressed: _paused ? _resumeGame : _pauseGame,
                          icon: Icon(
                            _paused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: _LabPlayfieldBackground(
                            boardSize: _boardSize,
                            binZoneHeight: _binZoneHeight,
                          ),
                        ),
                        Positioned(
                          left: _shapePosition.dx,
                          top: _shapePosition.dy,
                          child: GestureDetector(
                            onPanStart: _handlePanStart,
                            onPanUpdate: _handlePanUpdate,
                            onPanEnd: _handlePanEnd,
                            child: _DraggableShape(
                              shape: _currentShape,
                              size: _shapeSize,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          top: 12,
                          child: AnimatedOpacity(
                            opacity: _feedbackOpacity,
                            duration: const Duration(milliseconds: 180),
                            child: _FeedbackChip(
                              text: _feedbackText ?? '',
                              color: _feedbackColor,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 12,
                          child: _BottomBins(
                            boardWidth: _boardSize.width,
                            boardHeight: _boardSize.height,
                            binZoneHeight: _binZoneHeight,
                          ),
                        ),
                        if (_paused)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.58),
                              child: Center(
                                child: _InfoCard(
                                  title: 'Pausado',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'A operação foi suspensa.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 18),
                                      PrimaryActionButton(
                                        label: 'Continuar',
                                        icon: Icons.play_arrow_rounded,
                                        onPressed: _resumeGame,
                                      ),
                                      const SizedBox(height: 10),
                                      SecondaryActionButton(
                                        label: 'Reiniciar',
                                        icon: Icons.refresh_rounded,
                                        onPressed: _restartGame,
                                      ),
                                      const SizedBox(height: 10),
                                      SecondaryActionButton(
                                        label: 'Sair para o menu',
                                        icon: Icons.home_rounded,
                                        onPressed: widget.onExitToMenu,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
              const _TopBadge(text: 'COLAPSO CONTROLADO'),
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
              _ScoreCard(
                title: 'Pontuação final',
                value: '${result.score}',
                accent: AppColors.success,
              ),
              const SizedBox(height: 14),
              _ScoreCard(
                title: 'Melhor pontuação',
                value: '$bestScore',
                accent: isNewRecord ? AppColors.combo : AppColors.square,
              ),
              const SizedBox(height: 10),
              if (isNewRecord) const _RecordBadge(),
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

class LabBackground extends StatelessWidget {
  const LabBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/fundo.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),

        // Gradient overlay to keep UI readable over the image
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.72),
                  AppColors.backgroundSecondary.withOpacity(0.56),
                  AppColors.background.withOpacity(0.72),
                ],
              ),
            ),
          ),
        ),

        // Orbs and overlay elements
        const Positioned(
          top: -120,
          right: -80,
          child: _GlowOrb(color: AppColors.combo, size: 260),
        ),
        const Positioned(
          bottom: 60,
          left: -100,
          child: _GlowOrb(color: AppColors.circle, size: 220),
        ),
        const Positioned.fill(child: _GridOverlay()),

        // The app content floats above the background
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.32), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _GridPainter()));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LabPulseLogo extends StatelessWidget {
  const _LabPulseLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [AppColors.combo, AppColors.backgroundSecondary],
          radius: 0.92,
        ),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.combo.withOpacity(0.3),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textPrimary.withOpacity(0.28),
                  width: 1.5,
                ),
              ),
            ),
            const Icon(
              Icons.science_rounded,
              color: AppColors.textPrimary,
              size: 48,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBadge extends StatelessWidget {
  const _TopBadge({required this.text});

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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.5), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withOpacity(0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.combo,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          elevation: 0,
        ),
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(color: AppColors.border.withOpacity(0.8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _RuleBullet extends StatelessWidget {
  const _RuleBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.combo,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.shape, required this.label});

  final ShapeType shape;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          _ShapeToken(shape: shape, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _ShapeToken extends StatelessWidget {
  const _ShapeToken({required this.shape, required this.size});

  final ShapeType shape;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ShapeGlyph(shape: shape),
    );
  }
}

class _LabPlayfieldBackground extends StatelessWidget {
  const _LabPlayfieldBackground({
    required this.boardSize,
    required this.binZoneHeight,
  });

  final Size boardSize;
  final double binZoneHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border.withOpacity(0.55)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: _PlayfieldPainter(binZoneHeight: binZoneHeight),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            top: 18,
            child: Container(
              height: 1,
              color: AppColors.combo.withOpacity(0.24),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayfieldPainter extends CustomPainter {
  _PlayfieldPainter({required this.binZoneHeight});

  final double binZoneHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = AppColors.border.withOpacity(0.24)
      ..strokeWidth = 1;
    final zonePaint = Paint()
      ..color = AppColors.backgroundSecondary.withOpacity(0.78);
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.03);

    final zoneTop = size.height - binZoneHeight;
    canvas.drawRect(
      Rect.fromLTWH(0, zoneTop, size.width, binZoneHeight),
      zonePaint,
    );
    canvas.drawLine(
      Offset(0, zoneTop),
      Offset(size.width, zoneTop),
      borderPaint,
    );

    const step = 32.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, zoneTop), gridPaint);
    }
    for (double y = 0; y <= zoneTop; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlayfieldPainter oldDelegate) {
    return oldDelegate.binZoneHeight != binZoneHeight;
  }
}

class _BottomBins extends StatelessWidget {
  const _BottomBins({
    required this.boardWidth,
    required this.boardHeight,
    required this.binZoneHeight,
  });

  final double boardWidth;
  final double boardHeight;
  final double binZoneHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: binZoneHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: ShapeType.values
                .map(
                  (shape) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _BinPanel(shape: shape),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BinPanel extends StatelessWidget {
  const _BinPanel({required this.shape});

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

class ShapeGlyph extends StatelessWidget {
  const ShapeGlyph({super.key, required this.shape, this.size = 64});

  final ShapeType shape;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ShapeGlyphPainter(shape: shape)),
    );
  }
}

class _ShapeGlyphPainter extends CustomPainter {
  _ShapeGlyphPainter({required this.shape});

  final ShapeType shape;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = shape.color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.4);
    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    switch (shape) {
      case ShapeType.circle:
        canvas.drawCircle(rect.center, rect.width / 2, fillPaint);
        canvas.drawCircle(rect.center, rect.width / 2, strokePaint);
        break;
      case ShapeType.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(12)),
          fillPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(12)),
          strokePaint,
        );
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeGlyphPainter oldDelegate) =>
      oldDelegate.shape != shape;
}

class _DraggableShape extends StatelessWidget {
  const _DraggableShape({required this.shape, required this.size});

  final ShapeType shape;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withOpacity(0.45)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: ShapeGlyph(shape: shape),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.36),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: shape.color.withOpacity(0.3)),
          ),
          child: Text(
            shape.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: shape.color,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  const _FeedbackChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _RecordBadge extends StatelessWidget {
  const _RecordBadge();

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

class _FooterHint extends StatelessWidget {
  const _FooterHint();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Dica: mantenha os olhos nas bordas do laboratório. A pressão sobe rápido.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
