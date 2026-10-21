import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_plates_edu/main.dart';

void main() {
  testWidgets('Dynamic Plates Edu mobile layout smoke test', (WidgetTester tester) async {
    // Mode smartphone portrait
    tester.view.physicalSize = const Size(500, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DynamicPlatesEduApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Vérifier l'AppBar et les onglets mobiles
    expect(find.text('Dynamic Plates Edu'), findsOneWidget);
    expect(find.textContaining('Divergence'), findsOneWidget);
    expect(find.text('Légendes'), findsOneWidget);
    expect(find.byIcon(Icons.replay), findsOneWidget);
  });

  testWidgets('Dynamic Plates Edu tablet wide layout smoke test', (WidgetTester tester) async {
    // Mode tablette / écran large
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DynamicPlatesEduApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Vérifier la présence du rail de navigation et de la simulation active
    expect(find.textContaining('Dynamic'), findsWidgets);
    expect(find.textContaining('Divergence'), findsOneWidget);
    expect(find.byIcon(Icons.replay), findsOneWidget);
  });

  testWidgets('Navigation to Module 2 Extreme Phenomena test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DynamicPlatesEduApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Naviguer vers Phénomènes Extrêmes
    await tester.tap(find.byIcon(Icons.volcano_outlined));
    await tester.pump(const Duration(milliseconds: 300));

    // Vérifier les 3 onglets du module
    expect(find.textContaining('Volcanisme'), findsOneWidget);
    expect(find.textContaining('Séismes'), findsOneWidget);
    expect(find.textContaining('Tsunami'), findsOneWidget);
  });

  testWidgets('Navigation to Module 3 World Atlas test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DynamicPlatesEduApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Naviguer vers Atlas Mondial
    await tester.tap(find.byIcon(Icons.map_outlined));
    await tester.pump(const Duration(milliseconds: 300));

    // Vérifier les onglets du module Atlas
    expect(find.textContaining('Carte Tectonique'), findsOneWidget);
    expect(find.textContaining('Frise Wegener'), findsOneWidget);
  });

  testWidgets('Navigation to Module 4 Quiz and interactive question test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DynamicPlatesEduApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Naviguer vers Quiz & Évaluation
    await tester.tap(find.byIcon(Icons.school_outlined));
    await tester.pump(const Duration(milliseconds: 300));

    // Vérifier la présence du bouton de démarrage
    final startButton = find.byKey(const Key('start_quiz_button'));
    expect(startButton, findsOneWidget);

    // Faire défiler jusqu'au bouton et le presser
    await tester.ensureVisible(startButton);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(startButton);
    await tester.pump(const Duration(milliseconds: 300));

    // Vérifier que la question 1 est affichée
    expect(find.textContaining('Question 1'), findsOneWidget);
    final option0 = find.byKey(const Key('quiz_option_0'));
    expect(option0, findsOneWidget);

    // Répondre à la première option
    await tester.ensureVisible(option0);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(option0);
    await tester.pump(const Duration(milliseconds: 300));

    // Vérifier que la boîte d'explication scientifique PER s'affiche
    expect(find.textContaining('Explication scientifique'), findsOneWidget);
    final nextButton = find.byKey(const Key('next_question_button'));
    expect(nextButton, findsOneWidget);

    // Faire défiler et passer à la question 2
    await tester.ensureVisible(nextButton);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(nextButton);
    await tester.pump(const Duration(milliseconds: 300));

    // Vérifier que nous sommes passés à la question 2
    expect(find.textContaining('Question 2'), findsOneWidget);
  });
}

