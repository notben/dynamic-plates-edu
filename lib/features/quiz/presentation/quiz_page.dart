import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/core/localization/app_strings.dart';
import 'package:dynamic_plates_edu/features/quiz/data/quiz_question_model.dart';
import 'package:dynamic_plates_edu/features/quiz/data/quiz_bank.dart';
import 'package:dynamic_plates_edu/features/quiz/data/quiz_storage_service.dart';

enum QuizScreenState { welcome, playing, results }

/// Module 4 : Quiz Pédagogique & Évaluation PER
/// Conforme au Plan d'études romand (12-16 ans), 100% hors-ligne.
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizScreenState _screenState = QuizScreenState.welcome;

  QuizCategory? _selectedCategory; // null = Toutes les catégories (Mixte)
  List<QuizQuestion> _sessionQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;

  int _bestScore = 0;
  int _totalSessions = 0;
  bool _isLoadingStats = true;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final best = await QuizStorageService.getBestScore();
    final total = await QuizStorageService.getTotalQuizzes();
    if (mounted) {
      setState(() {
        _bestScore = best;
        _totalSessions = total;
        _isLoadingStats = false;
      });
    }
  }

  void _startQuiz() {
    final questions = QuizBank.getRandomQuestions(
      count: 10,
      category: _selectedCategory,
    );

    setState(() {
      _sessionQuestions = questions;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
      _hasAnswered = false;
      _isNewHighScore = false;
      _screenState = QuizScreenState.playing;
    });
  }

  void _selectOption(int optionIndex) {
    if (_hasAnswered) return;

    final currentQ = _sessionQuestions[_currentQuestionIndex];
    final isCorrect = optionIndex == currentQ.correctOptionIndex;

    setState(() {
      _selectedOptionIndex = optionIndex;
      _hasAnswered = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentQuestionIndex + 1 < _sessionQuestions.length) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
      });
    } else {
      // Quiz terminé
      final isNewRecord = _score > _bestScore;
      await QuizStorageService.saveScore(_score);
      await _loadStats();
      if (mounted) {
        setState(() {
          _isNewHighScore = isNewRecord;
          _screenState = QuizScreenState.results;
        });
      }
    }
  }

  void _returnToWelcome() {
    setState(() {
      _screenState = QuizScreenState.welcome;
      _selectedOptionIndex = null;
      _hasAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (_screenState) {
            QuizScreenState.welcome => _buildWelcomeView(),
            QuizScreenState.playing => _buildPlayingView(),
            QuizScreenState.results => _buildResultsView(),
          },
        ),
      ),
    );
  }

  // --- VUE D'ACCUEIL ---
  Widget _buildWelcomeView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      key: const ValueKey('quiz_welcome_view'),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.deepPurple.shade900, Colors.indigo.shade900]
                        : [Colors.deepPurple.shade100, Colors.indigo.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.purpleAccent.withOpacity(0.3) : Colors.deepPurple.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, size: 48, color: Colors.purpleAccent),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      AppStrings.get('quiz_header_title'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.get('quiz_header_subtitle'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.emoji_events,
                      iconColor: Colors.amber,
                      title: AppStrings.get('quiz_best_score'),
                      value: _isLoadingStats ? '-' : '$_bestScore / 10',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.checklist_rtl,
                      iconColor: Colors.tealAccent,
                      title: AppStrings.get('quiz_total_sessions'),
                      value: _isLoadingStats ? '-' : '$_totalSessions',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sélection de catégorie
              Text(
                AppStrings.get('quiz_choose_category'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryChip(null, AppStrings.get('quiz_cat_all'), Icons.shuffle),
                  _buildCategoryChip(
                    QuizCategory.tectonics,
                    AppStrings.get('quiz_cat_tectonics'),
                    Icons.layers,
                  ),
                  _buildCategoryChip(
                    QuizCategory.volcanoes,
                    AppStrings.get('quiz_cat_volcanoes'),
                    Icons.volcano,
                  ),
                  _buildCategoryChip(
                    QuizCategory.earthquakes,
                    AppStrings.get('quiz_cat_earthquakes'),
                    Icons.waves,
                  ),
                  _buildCategoryChip(
                    QuizCategory.history,
                    AppStrings.get('quiz_cat_history'),
                    Icons.history_edu,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Bouton Démarrer
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  key: const Key('start_quiz_button'),
                  onPressed: _startQuiz,
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: Text(
                    AppStrings.get('quiz_start_button'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(QuizCategory? category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.purpleAccent),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedCategory = category);
        }
      },
      selectedColor: Colors.deepPurpleAccent,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : null,
      ),
    );
  }

  // --- VUE EN COURS DE QUIZ ---
  Widget _buildPlayingView() {
    if (_sessionQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    final question = _sessionQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _sessionQuestions.length;

    return SingleChildScrollView(
      key: const ValueKey('quiz_playing_view'),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header avec progression et bouton retour
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Quitter',
                    onPressed: _returnToWelcome,
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.get('quiz_question_progress', [
                        _currentQuestionIndex + 1,
                        _sessionQuestions.length,
                      ]),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppStrings.get('quiz_current_score', ['$_score/${_sessionQuestions.length}']),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Barre de progression
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                ),
              ),

              const SizedBox(height: 18),

              // Badge Catégorie
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(question.category).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getCategoryColor(question.category).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    question.categoryLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(question.category),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Carte de la Question
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    question.questionText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.35,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Liste des Options (A, B, C, D)
              ...List.generate(question.options.length, (idx) {
                return _buildOptionTile(
                  index: idx,
                  text: question.options[idx],
                  correctIndex: question.correctOptionIndex,
                );
              }),

              // Boîte d'explication pédagogique immédiate (PER)
              if (_hasAnswered) ...[
                const SizedBox(height: 16),
                _buildExplanationBox(question.explanation),
                const SizedBox(height: 20),

                // Bouton Question suivante / Terminer
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    key: const Key('next_question_button'),
                    onPressed: _nextQuestion,
                    icon: Icon(
                      _currentQuestionIndex + 1 == _sessionQuestions.length
                          ? Icons.check_circle_outline
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentQuestionIndex + 1 == _sessionQuestions.length
                          ? AppStrings.get('quiz_finish_button')
                          : AppStrings.get('quiz_next_question'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required int index,
    required String text,
    required int correctIndex,
  }) {
    final letters = ['A', 'B', 'C', 'D'];
    final letter = letters[index % letters.length];

    Color? backgroundColor;
    Color borderColor = Theme.of(context).dividerColor.withOpacity(0.3);
    Widget trailingIcon = const SizedBox.shrink();

    if (_hasAnswered) {
      if (index == correctIndex) {
        backgroundColor = Colors.green.withOpacity(0.18);
        borderColor = Colors.greenAccent;
        trailingIcon = const Icon(Icons.check_circle, color: Colors.greenAccent, size: 22);
      } else if (index == _selectedOptionIndex) {
        backgroundColor = Colors.red.withOpacity(0.18);
        borderColor = Colors.redAccent;
        trailingIcon = const Icon(Icons.cancel, color: Colors.redAccent, size: 22);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          key: Key('quiz_option_$index'),
          borderRadius: BorderRadius.circular(14),
          onTap: _hasAnswered ? null : () => _selectOption(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14, height: 1.25),
                  ),
                ),
                trailingIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationBox(String explanation) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey.shade900.withOpacity(0.8) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.lightBlueAccent.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: Colors.lightBlueAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('quiz_scientific_explanation'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // --- VUE DE RÉSULTATS ---
  Widget _buildResultsView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = _sessionQuestions.length;
    final percentage = total > 0 ? ((_score / total) * 100).round() : 0;

    String feedbackText;
    IconData resultIcon;
    Color resultColor;

    if (percentage >= 80) {
      feedbackText = AppStrings.get('quiz_grade_expert');
      resultIcon = Icons.military_tech;
      resultColor = Colors.amber;
    } else if (percentage >= 50) {
      feedbackText = AppStrings.get('quiz_grade_good');
      resultIcon = Icons.thumb_up_alt;
      resultColor = Colors.lightGreenAccent;
    } else {
      feedbackText = AppStrings.get('quiz_grade_retry');
      resultIcon = Icons.refresh;
      resultColor = Colors.orangeAccent;
    }

    return SingleChildScrollView(
      key: const ValueKey('quiz_results_view'),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge & Titre
              Container(
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.deepPurple.shade900, Colors.black]
                        : [Colors.deepPurple.shade100, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(resultIcon, size: 64, color: resultColor),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.get('quiz_results_title'),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Score Grand Format
                    Text(
                      '$_score / $total',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: resultColor,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),

                    if (_isNewHighScore) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Nouveau Meilleur Score !',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Message Pédagogique
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        feedbackText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Boutons d'Action
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  key: const Key('restart_quiz_button'),
                  onPressed: _startQuiz,
                  icon: const Icon(Icons.replay),
                  label: Text(
                    AppStrings.get('quiz_restart_button'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  key: const Key('home_quiz_button'),
                  onPressed: _returnToWelcome,
                  icon: const Icon(Icons.home_outlined),
                  label: Text(
                    AppStrings.get('quiz_home_button'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(QuizCategory category) {
    switch (category) {
      case QuizCategory.tectonics:
        return Colors.blueAccent;
      case QuizCategory.volcanoes:
        return Colors.orangeAccent;
      case QuizCategory.earthquakes:
        return Colors.tealAccent;
      case QuizCategory.history:
        return Colors.amberAccent;
    }
  }
}
