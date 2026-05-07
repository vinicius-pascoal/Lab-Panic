import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../config/enums.dart';
import '../data/models/game_result.dart';
import '../widgets/common/lab_background.dart';
import '../widgets/common/primary_action_button.dart';
import '../widgets/common/secondary_action_button.dart';
import '../widgets/common/info_card.dart';
import '../widgets/game/draggable_shape.dart';
import '../widgets/game/bottom_bins.dart';
import '../widgets/game/playfield_background.dart';
import '../widgets/game/feedback_chip.dart';
import '../widgets/game/stat_card.dart';

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
  final Random _random = Random();

  Timer? _timer;
  ShapeType _currentShape = ShapeType.circle;
  Offset _shapePosition = const Offset(0, 24);
  Size _boardSize = Size.zero;
  bool _paused = false;
  bool _dragging = false;
  int _score = 0;
  int _lives = GameConstants.initialLives;
  int _combo = 0;
  int _elapsedSeconds = 0;
  String? _feedbackText;
  Color _feedbackColor = AppColors.success;
  double _feedbackOpacity = 0;
  bool _boardReady = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(GameConstants.gameTick, _onTick);
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
      _elapsedSeconds =
          timer.tick ~/ (1000 ~/ GameConstants.gameTick.inMilliseconds);
      if (!_dragging) {
        final nextY =
            _shapePosition.dy +
            _fallSpeed * (GameConstants.gameTick.inMilliseconds / 1000);
        _shapePosition = Offset(_shapePosition.dx, nextY);
        _checkForMiss();
      }
    });
  }

  double get _fallSpeed {
    if (_elapsedSeconds < GameConstants.speedStage1End) {
      return GameConstants.speedStage1;
    }
    if (_elapsedSeconds < GameConstants.speedStage2End) {
      return GameConstants.speedStage2;
    }
    if (_elapsedSeconds < GameConstants.speedStage3End) {
      return GameConstants.speedStage3;
    }
    return GameConstants.speedStage4;
  }

  double get _laneBottom => _boardSize.height - GameConstants.binZoneHeight - 8;

  void _spawnShape() {
    final availableWidth = max(
      24.0,
      _boardSize.width - GameConstants.shapeSize - 32,
    );
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
    Future<void>.delayed(GameConstants.feedbackDuration, () {
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
      _lives = GameConstants.initialLives;
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
      3 => GameConstants.combo3Bonus,
      5 => GameConstants.combo5Bonus,
      _ => 0,
    };

    setState(() {
      _score += GameConstants.acertScore + bonus;
      _combo = nextCombo;
      _showFeedback(
        bonus > 0 ? 'Combo +$bonus' : 'Acerto +${GameConstants.acertScore}',
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
    final effectiveWidth = width - 32;
    final binWidth = effectiveWidth / 3;
    final left = 16 + shape.index * binWidth + 4;

    final stackHeight = _boardSize.height - GameConstants.headerHeight;

    return Rect.fromLTWH(
      left,
      stackHeight - GameConstants.binZoneHeight + 14,
      binWidth - 8,
      GameConstants.binZoneHeight - 24,
    );
  }

  bool _dropMatchesBin(Offset position) {
    final center =
        position +
        Offset(GameConstants.shapeSize / 2, GameConstants.shapeSize / 2);
    for (final shape in ShapeType.values) {
      final rect = _binRectFor(shape, _boardSize.width);
      if (rect.contains(center)) {
        if (shape == _currentShape) {
          return true;
        }
        _loseLife('Recipiente errado');
        return false;
      }
    }
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
        _boardSize.width - GameConstants.shapeSize - 8.0,
      );
      final nextY = (_shapePosition.dy + details.delta.dy).clamp(
        8.0,
        _boardSize.height - GameConstants.shapeSize - 8.0,
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
                  height: GameConstants.headerHeight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Score',
                            value: '$_score',
                            accent: AppColors.combo,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
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
                          child: PlayfieldBackground(
                            boardSize: _boardSize,
                            binZoneHeight: GameConstants.binZoneHeight,
                          ),
                        ),
                        Positioned(
                          left: _shapePosition.dx,
                          top: _shapePosition.dy,
                          child: GestureDetector(
                            onPanStart: _handlePanStart,
                            onPanUpdate: _handlePanUpdate,
                            onPanEnd: _handlePanEnd,
                            child: DraggableShape(
                              shape: _currentShape,
                              size: GameConstants.shapeSize,
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
                            child: FeedbackChip(
                              text: _feedbackText ?? '',
                              color: _feedbackColor,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 12,
                          child: BottomBins(
                            boardWidth: _boardSize.width,
                            boardHeight: _boardSize.height,
                            binZoneHeight: GameConstants.binZoneHeight,
                          ),
                        ),
                        if (_paused)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.58),
                              child: Center(
                                child: InfoCard(
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
