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
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

    // Vérifier la présence du rail de navigation et de la simulation active
    expect(find.textContaining('Dynamic'), findsWidgets);
    expect(find.textContaining('Divergence'), findsOneWidget);
    expect(find.byIcon(Icons.replay), findsOneWidget);
  });
}
