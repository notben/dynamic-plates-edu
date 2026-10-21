import 'package:flutter/material.dart';

/// Simulation 6 : Point Chaud Intraplaque (Archipel d'Hawaï & chaîne Empereur)
/// Principes géodynamiques :
/// - Panache mantellique thermique profond strictement FIXE.
/// - Plaque lithosphérique océanique en mouvement horizontal vers la gauche/nord-ouest.
/// - Volcan actif au-dessus du point chaud (Hawaï - Kilauea/Mauna Loa).
/// - Chapelet d'îles éteintes s'éloignant, s'affaissant par refroidissement et s'érodant en guyots.
class Sim6HotspotPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim6HotspotPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final seaLevelY = h * 0.35;
    final seafloorBaseY = seaLevelY + 50;

    // Position FIXE du panache mantellique (au tiers droit)
    final hotSpotX = w * 0.72;

    // Déplacement de la plaque océanique vers la gauche en fonction de progress
    // Vitesse géologique : la plaque a glissé de ~180 px sur 50 Ma
    final plateDisplacement = progress * 160.0;

    // 1. Manteau chaud de fond
    final mantleRect = Rect.fromLTWH(0, seafloorBaseY + 40, w, h - (seafloorBaseY + 40));
    final mantlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF6A1B02), const Color(0xFFB72C00), const Color(0xFFFF5722)]
            : [const Color(0xFF7B2605), const Color(0xFFD84315), const Color(0xFFFF7043)],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(mantleRect);
    canvas.drawRect(mantleRect, mantlePaint);

    // 2. Panache Mantellique FIXE (conduit thermique incandescent profond)
    _drawDeepMantlePlume(canvas, hotSpotX, seafloorBaseY + 40, h);

    // 3. Lithosphère océanique mobile avec relief des îles
    // Définition des îles par rapport à la plaque (coordonnées locales à la plaque)
    // Île 0 : En cours de formation sur le point chaud (Kilauea / Mauna Loa)
    // Îles précédentes : Maui, Oahu, Kauai, Atoll de Midway, Guyot immergé
    final islands = [
      _IslandData(initialOffset: 0, ageMa: 0.5, name: 'Hawaï (Actif)', type: _IslandType.activeShield),
      _IslandData(initialOffset: -70, ageMa: 1.8, name: 'Maui (Dormant)', type: _IslandType.dormant),
      _IslandData(initialOffset: -140, ageMa: 3.5, name: 'Oahu (Éteint)', type: _IslandType.extinct),
      _IslandData(initialOffset: -210, ageMa: 5.1, name: 'Kauai (Érodé)', type: _IslandType.eroded),
      _IslandData(initialOffset: -290, ageMa: 28.0, name: 'Midway (Atoll)', type: _IslandType.atoll),
      _IslandData(initialOffset: -380, ageMa: 45.0, name: 'Guyot (Submergé)', type: _IslandType.guyot),
    ];

    for (final island in islands) {
      final islandCurrentX = (hotSpotX + island.initialOffset - plateDisplacement);
      if (islandCurrentX < -80 || islandCurrentX > w + 80) continue;

      // Dessin de chaque volcan bouclier / île selon son stade d'évolution
      _drawIsland(canvas, islandCurrentX, seaLevelY, seafloorBaseY, island);
    }

    // Tracé du plateau lithosphérique sous les îles
    final lithoPlate = Path()
      ..moveTo(0, seafloorBaseY)
      ..lineTo(w, seafloorBaseY)
      ..lineTo(w, seafloorBaseY + 45)
      ..lineTo(0, seafloorBaseY + 45)
      ..close();
    final lithoPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.fill;
    canvas.drawPath(lithoPlate, lithoPaint);

    // 4. Colonne d'eau océanique
    final oceanRect = Rect.fromLTWH(0, seaLevelY, w, seafloorBaseY - seaLevelY);
    final oceanPaint = Paint()
      ..color = const Color.fromRGBO(2, 119, 189, 0.55);
    canvas.drawRect(oceanRect, oceanPaint);

    // Surface de l'eau
    final seaSurfacePaint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.8)
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, seaLevelY), Offset(w, seaLevelY), seaSurfacePaint);

    // 5. Flèche de mouvement de la plaque Pacifique (vers la gauche / NO)
    _drawPlateMotionArrow(canvas, w * 0.40, seaLevelY - 20);

    // 6. Légendes pédagogiques
    if (showLegends) {
      _drawLabels(canvas, w, h, hotSpotX, seaLevelY);
    }
  }

  void _drawDeepMantlePlume(Canvas canvas, double hx, double topY, double bottomY) {
    // Conduit vertical de magma chaud
    final plumePath = Path()
      ..moveTo(hx - 25, bottomY)
      ..cubicTo(hx - 15, (topY + bottomY) * 0.5, hx - 30, topY + 40, hx - 18, topY)
      ..lineTo(hx + 18, topY)
      ..cubicTo(hx + 30, topY + 40, hx + 15, (topY + bottomY) * 0.5, hx + 25, bottomY)
      ..close();

    final plumePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: const [Color(0xFFFFEA00), Color(0xFFFF3D00), Color(0xFFFF5722)],
      ).createShader(Rect.fromLTWH(hx - 30, topY, 60, bottomY - topY));
    canvas.drawPath(plumePath, plumePaint);

    // Tête du panache (chambre magmatique sous-crustale)
    final headPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFEA00), const Color(0xFFFF3D00).withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: Offset(hx, topY), radius: 35));
    canvas.drawCircle(Offset(hx, topY), 35, headPaint);
  }

  void _drawIsland(Canvas canvas, double ix, double seaY, double floorY, _IslandData data) {
    switch (data.type) {
      case _IslandType.activeShield:
        // Volcan bouclier massif culminant au-dessus de l'eau
        final shield = Path()
          ..moveTo(ix - 55, floorY)
          ..cubicTo(ix - 35, seaY + 15, ix - 15, seaY - 32, ix, seaY - 32)
          ..cubicTo(ix + 15, seaY - 32, ix + 35, seaY + 15, ix + 55, floorY)
          ..close();
        final shieldPaint = Paint()..color = const Color(0xFF3E2723);
        canvas.drawPath(shield, shieldPaint);

        // Coulée de lave incandescente dans la mer
        final lava = Paint()
          ..color = const Color(0xFFFF3D00)
          ..strokeWidth = 3.5;
        canvas.drawLine(Offset(ix, seaY - 32), Offset(ix + 16, seaY), lava);

        // Panache de vapeur blanche
        final steam = Paint()..color = Colors.white70;
        canvas.drawCircle(Offset(ix + 16, seaY - 8), 5, steam);
        canvas.drawCircle(Offset(ix + 20, seaY - 18), 8, steam);
        break;

      case _IslandType.dormant:
      case _IslandType.extinct:
        // Volcan éteint, sommet commence à s'éroder
        final hRel = data.type == _IslandType.dormant ? 25.0 : 16.0;
        final volcano = Path()
          ..moveTo(ix - 45, floorY)
          ..lineTo(ix - 10, seaY - hRel)
          ..lineTo(ix + 10, seaY - hRel)
          ..lineTo(ix + 45, floorY)
          ..close();
        final vPaint = Paint()..color = const Color(0xFF4E342E);
        canvas.drawPath(volcano, vPaint);
        break;

      case _IslandType.eroded:
      case _IslandType.atoll:
        // Atoll corallien affleurant à fleur d'eau
        final atoll = Path()
          ..moveTo(ix - 35, floorY)
          ..lineTo(ix - 12, seaY - 3)
          ..lineTo(ix + 12, seaY - 3)
          ..lineTo(ix + 35, floorY)
          ..close();
        final aPaint = Paint()..color = const Color(0xFF2E7D32);
        canvas.drawPath(atoll, aPaint);
        break;

      case _IslandType.guyot:
        // Guyot : sommet totalement plat sous le niveau de la mer (subsidence thermique)
        final guyot = Path()
          ..moveTo(ix - 35, floorY)
          ..lineTo(ix - 18, seaY + 18)
          ..lineTo(ix + 18, seaY + 18) // Sommet plat érodé sous l'eau
          ..lineTo(ix + 35, floorY)
          ..close();
        final gPaint = Paint()..color = const Color(0xFF37474F);
        canvas.drawPath(guyot, gPaint);
        break;
    }
  }

  void _drawPlateMotionArrow(Canvas canvas, double x, double y) {
    final arrowPaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x, y), Offset(x - 50, y), arrowPaint);
    canvas.drawLine(Offset(x - 50, y), Offset(x - 42, y - 6), arrowPaint);
    canvas.drawLine(Offset(x - 50, y), Offset(x - 42, y + 6), arrowPaint);
  }

  void _drawLabels(Canvas canvas, double w, double h, double hotSpotX, double seaY) {
    _renderText(canvas, 'Panache mantellique (STRICTEMENT FIXE)', Offset(hotSpotX - 110, h - 35), Colors.amberAccent);
    _renderText(canvas, 'Plaque Pacifique (en mouvement vers le NO ➔ 9 cm/an)', Offset(w * 0.15, seaY - 45), Colors.cyanAccent);
    _renderText(canvas, 'Volcan actif (Kilauea)', Offset(hotSpotX - 45, seaY - 60), Colors.orangeAccent);
    _renderText(canvas, 'Îles éteintes & érodées', Offset(hotSpotX - 230, seaY - 25), Colors.lightGreenAccent);
    _renderText(canvas, 'Guyot sous-marin (subsidence)', Offset(30, seaY + 25), Colors.white70);
  }

  void _renderText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withOpacity(0.6),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant Sim6HotspotPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}

enum _IslandType { activeShield, dormant, extinct, eroded, atoll, guyot }

class _IslandData {
  final double initialOffset;
  final double ageMa;
  final String name;
  final _IslandType type;

  _IslandData({
    required this.initialOffset,
    required this.ageMa,
    required this.name,
    required this.type,
  });
}
