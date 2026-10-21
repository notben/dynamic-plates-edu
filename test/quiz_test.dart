import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_plates_edu/features/quiz/data/quiz_question_model.dart';
import 'package:dynamic_plates_edu/features/quiz/data/quiz_bank.dart';
import 'package:dynamic_plates_edu/features/quiz/data/quiz_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Banque de questions Quiz PER (Unit Tests)', () {
    test('Contient plus de 30 questions pédagogiques', () {
      expect(QuizBank.allQuestions.length, greaterThanOrEqualTo(30));
    });

    test('Toutes les questions ont un identifiant unique et des options valides', () {
      final seenIds = <String>{};
      for (final q in QuizBank.allQuestions) {
        expect(seenIds.contains(q.id), isFalse, reason: 'ID dupliqué : ${q.id}');
        seenIds.add(q.id);

        expect(q.questionText.trim().isNotEmpty, isTrue);
        expect(q.options.length, greaterThanOrEqualTo(3));
        expect(q.correctOptionIndex, inInclusiveRange(0, q.options.length - 1));
        expect(q.explanation.trim().isNotEmpty, isTrue);
      }
    });

    test('Couvre de manière équilibrée les 4 catégories du programme PER', () {
      final counts = <QuizCategory, int>{};
      for (final cat in QuizCategory.values) {
        counts[cat] = 0;
      }
      for (final q in QuizBank.allQuestions) {
        counts[q.category] = (counts[q.category] ?? 0) + 1;
      }

      for (final cat in QuizCategory.values) {
        expect(counts[cat], greaterThanOrEqualTo(7), reason: 'Catégorie $cat sous-représentée');
      }
    });

    test('getRandomQuestions tire le bon nombre et filtre correctement', () {
      final randomTen = QuizBank.getRandomQuestions(count: 10);
      expect(randomTen.length, equals(10));

      final volcanoBatch = QuizBank.getRandomQuestions(count: 5, category: QuizCategory.volcanoes);
      expect(volcanoBatch.length, equals(5));
      for (final q in volcanoBatch) {
        expect(q.category, equals(QuizCategory.volcanoes));
      }
    });
  });

  group('Service de stockage offline Quiz (Privacy CA92.1)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initialement le score et les sessions sont à 0', () async {
      expect(await QuizStorageService.getBestScore(), equals(0));
      expect(await QuizStorageService.getTotalQuizzes(), equals(0));
    });

    test('Sauvegarde d\'un premier score et incrémentation des sessions', () async {
      await QuizStorageService.saveScore(7);
      expect(await QuizStorageService.getBestScore(), equals(7));
      expect(await QuizStorageService.getTotalQuizzes(), equals(1));

      // Un score inférieur ne modifie pas le meilleur score mais incrémente les sessions
      await QuizStorageService.saveScore(5);
      expect(await QuizStorageService.getBestScore(), equals(7));
      expect(await QuizStorageService.getTotalQuizzes(), equals(2));

      // Un score supérieur met à jour le record
      await QuizStorageService.saveScore(9);
      expect(await QuizStorageService.getBestScore(), equals(9));
      expect(await QuizStorageService.getTotalQuizzes(), equals(3));
    });
  });

  group('Calculs Géophysiques (Modèles Physiques Pédagogiques)', () {
    test('Calcul de célérité de tsunami en eau peu profonde : v = sqrt(g * h)', () {
      const g = 9.81;

      // En haute mer (h = 4000 m) : vitesse de l'ordre d'un avion de ligne (~700 km/h)
      const hDeep = 4000.0;
      final vDeepMs = sqrt(g * hDeep);
      final vDeepKmh = vDeepMs * 3.6;
      expect(vDeepKmh, inInclusiveRange(650.0, 750.0));

      // Près des côtes (h = 10 m) : ralentissement drastique (~35 km/h)
      const hShallow = 10.0;
      final vShallowMs = sqrt(g * hShallow);
      final vShallowKmh = vShallowMs * 3.6;
      expect(vShallowKmh, inInclusiveRange(30.0, 40.0));
    });

    test('Ratio des vitesses d\'ondes sismiques : vP > vS', () {
      // Dans la croûte terrestre : vP ≈ 6 km/s, vS ≈ 3.5 km/s -> ratio sqrt(3) ≈ 1.73
      const vP = 6.0;
      const vS = 3.5;
      expect(vP, greaterThan(vS));
      final ratio = vP / vS;
      expect(ratio, inInclusiveRange(1.6, 1.8));
    });
  });
}
