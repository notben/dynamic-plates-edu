import 'package:dynamic_plates_edu/core/localization/app_strings.dart';

enum QuizCategory { tectonics, volcanoes, earthquakes, history }

/// Modèle d'une question de quiz pédagogique pour le Cycle d'Orientation.
class QuizQuestion {
  final String id;
  final QuizCategory category;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  String get categoryKey {
    switch (category) {
      case QuizCategory.tectonics:
        return 'quiz_cat_tectonics';
      case QuizCategory.volcanoes:
        return 'quiz_cat_volcanoes';
      case QuizCategory.earthquakes:
        return 'quiz_cat_earthquakes';
      case QuizCategory.history:
        return 'quiz_cat_history';
    }
  }

  String get categoryLabel => AppStrings.get(categoryKey);
}

