import 'package:shared_preferences/shared_preferences.dart';

/// Service de persistance locale hors-ligne des scores de quiz.
/// Conforme à la déclaration Apple PrivacyInfo.xcprivacy (raison CA92.1 : UserDefaults à usage local exclusif).
class QuizStorageService {
  static const _keyBestScore = 'quiz_best_score';
  static const _keyTotalQuizzes = 'quiz_total_sessions';

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyBestScore) ?? 0;
  }

  static Future<int> getTotalQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalQuizzes) ?? 0;
  }

  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBest = prefs.getInt(_keyBestScore) ?? 0;
    if (score > currentBest) {
      await prefs.setInt(_keyBestScore, score);
    }
    final total = prefs.getInt(_keyTotalQuizzes) ?? 0;
    await prefs.setInt(_keyTotalQuizzes, total + 1);
  }
}
