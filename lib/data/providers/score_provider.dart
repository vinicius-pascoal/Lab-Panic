import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';

class ScoreProvider {
  static const String _key = GameConstants.bestScoreKey;

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, score);
  }

  static Future<bool> isNewRecord(int score) async {
    final bestScore = await getBestScore();
    return score > bestScore && score > 0;
  }
}
