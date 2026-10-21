import 'package:flutter/material.dart';

/// Module 4 : Quiz Pédagogique & Évaluation PER
/// Placeholder prêt pour le Jalon 4.
class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Pédagogique & Évaluation PER'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 64, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'Module 4 : Quiz & Auto-évaluation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Banque de questions pour le Cycle d\'Orientation avec feedback immédiat.',
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
