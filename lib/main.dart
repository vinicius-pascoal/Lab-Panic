import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/enums.dart';
import 'config/theme.dart';
import 'data/models/game_result.dart';
import 'data/providers/score_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/game_screen.dart';
import 'screens/game_over_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab Panic',
      theme: AppTheme.buildTheme(),
      home: const LabPanicApp(),
    );
  }
}

class LabPanicApp extends StatefulWidget {
  const LabPanicApp({super.key});

  @override
  State<LabPanicApp> createState() => _LabPanicAppState();
}

class _LabPanicAppState extends State<LabPanicApp> {
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
    final score = await ScoreProvider.getBestScore();
    if (!mounted) return;
    setState(() {
      _bestScore = score;
    });
  }

  Future<void> _handleGameOver(GameResult result) async {
    if (result.score > _bestScore) {
      await ScoreProvider.saveBestScore(result.score);
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
