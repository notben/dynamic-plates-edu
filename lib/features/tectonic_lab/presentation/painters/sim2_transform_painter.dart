import 'package:flutter/material.dart';

/// Simulation 2 : Limite Transformante (Faille coulissante / San Andreas)
/// Mécanisme :
/// - Glissement horizontal de 2 blocs lithosphériques en sens opposé.
/// - Accumulation de contrainte élastique (jauge de tension).
/// - Rupture par à-coups (séisme) avec ondes de choc concentriques.
/// - Décalage permanent d'une route et d'une rivière en surface.
class Sim2TransformPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim2TransformPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Cycle sismique répété au cours des 50 Ma :
    // Chaque cycle de 0.25 accumule la déformation puis relâche brutalement
    final cycleLength = 0.25;
    final currentCycleIndex = (progress / cycleLength).floor().clamp(0, 3);
    final cyclePhase = (progress % cycleLength) / cycleLength; // 0.0 -> 1.0

    // Déplacement plastique cumulé des cycles précédents + déformation élastique du cycle actuel
    final isEarthquake = cyclePhase > 0.85;
    final accumulatedShift = currentCycleIndex * 35.0;
    final elasticStrain = isEarthquake ? 35.0 : (cyclePhase / 0.85) * 35.0;
    final totalShift = accumulatedShift + elasticStrain;

    // Faille centrale verticale (vue du dessus / oblique)
    final faultX = w * 0.5;

    // Plaque Pacifique (gauche, se déplace vers le haut)
    final leftShiftY = -totalShift * 0.8;
    // Plaque Nord-Américaine (droite, se déplace vers le bas)
    final rightShiftY = totalShift * 0.8;

    // 1. Fond des deux plaques
    final leftPlateRect = Rect.fromLTWH(0, 0, faultX, h);
    final rightPlateRect = Rect.fromLTWH(faultX, 0, w - faultX, h);

    final leftPlatePaint = Paint()
      ..color = isDark ? const Color(0xFF2E3B4E) : const Color(0xFF81C784);
    final rightPlatePaint = Paint()
      ..color = isDark ? const Color(0xFF1E2836) : const Color(0xFFA5D6A7);

    canvas.drawRect(leftPlateRect, leftPlatePaint);
    canvas.drawRect(rightPlateRect, rightPlatePaint);

    // 2. Grille de terrain pour visualiser la déformation
    _drawTerrainTexture(canvas, w, h, faultX, leftShiftY, rightShiftY);

    // 3. Rivière décalée (traverse d'est en ouest)
    _drawRiver(canvas, w, h, faultX, leftShiftY, rightShiftY, elasticStrain, isEarthquake);

    // 4. Route rectiligne décalée
    _drawRoad(canvas, w, h, faultX, leftShiftY, rightShiftY, elasticStrain, isEarthquake);

    // 5. Tracé de la faille active (au centre)
    final faultLinePaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(faultX, 0), Offset(faultX, h), faultLinePaint);

    // 6. Ondes sismiques lors de la rupture
    if (isEarthquake) {
      final quakeProgress = (cyclePhase - 0.85) / 0.15;
      _drawEarthquakeEpicenter(canvas, faultX, h * 0.5, quakeProgress);
    }

    // 7. Flèches de mouvement relatif
    _drawMotionArrows(canvas, w, h, faultX);

    // 8. Jauge de contrainte élastique (HUD)
    _drawStressGauge(canvas, w, h, isEarthquake ? 1.0 - ((cyclePhase - 0.85) / 0.15) : cyclePhase / 0.85);

    // 9. Légendes
    if (showLegends) {
      _drawLabels(canvas, w, h, faultX, isEarthquake);
    }
  }

  void _drawTerrainTexture(Canvas canvas, double w, double h, double fx, double leftY, double rightY) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.0;

    for (double y = 40; y < h; y += 40) {
      final ly = (y + leftY) % h;
      final ry = (y + rightY) % h;
      canvas.drawLine(Offset(20, ly), Offset(fx - 20, ly), linePaint);
      canvas.drawLine(Offset(fx + 20, ry), Offset(w - 20, ry), linePaint);
    }
  }

  void _drawRiver(Canvas canvas, double w, double h, double fx, double ly, double ry, double strain, bool quake) {
    final riverPaint = Paint()
      ..color = const Color(0xFF0288D1)
      ..strokeWidth = 9.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final baseRiverY = h * 0.40;
    final leftRiverY = baseRiverY + ly;
    final rightRiverY = baseRiverY + ry;

    // Tracé ouest (gauche)
    final leftPath = Path()
      ..moveTo(20, leftRiverY - 15)
      ..cubicTo(fx * 0.3, leftRiverY - 5, fx * 0.7, leftRiverY + (strain * 0.3), fx, leftRiverY);
    canvas.drawPath(leftPath, riverPaint);

    // Tracé est (droite)
    final rightPath = Path()
      ..moveTo(fx, rightRiverY)
      ..cubicTo(fx + (w - fx) * 0.3, rightRiverY - (strain * 0.3), fx + (w - fx) * 0.7, rightRiverY + 10, w - 20, rightRiverY);
    canvas.drawPath(rightPath, riverPaint);

    // Segment le long de la faille (la rivière emprunte la zone broyée)
    final faultSegment = Paint()
      ..color = const Color(0xFF0277BD)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(fx, leftRiverY), Offset(fx, rightRiverY), faultSegment);
  }

  void _drawRoad(Canvas canvas, double w, double h, double fx, double ly, double ry, double strain, bool quake) {
    final roadPaint = Paint()
      ..color = const Color(0xFFFFC107)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final baseRoadY = h * 0.65;
    final leftRoadY = baseRoadY + ly;
    final rightRoadY = baseRoadY + ry;

    // Route côté gauche
    final roadLeft = Path()
      ..moveTo(30, leftRoadY)
      ..lineTo(fx - 15, leftRoadY + (strain * 0.25))
      ..lineTo(fx, leftRoadY);
    canvas.drawPath(roadLeft, roadPaint);

    // Route côté droit
    final roadRight = Path()
      ..moveTo(fx, rightRoadY)
      ..lineTo(fx + 15, rightRoadY - (strain * 0.25))
      ..lineTo(w - 30, rightRoadY);
    canvas.drawPath(roadRight, roadPaint);

    // Ligne centrale blanche discontinue
    final dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(fx - 60, leftRoadY), Offset(fx - 20, leftRoadY), dashPaint);
    canvas.drawLine(Offset(fx + 20, rightRoadY), Offset(fx + 60, rightRoadY), dashPaint);
  }

  void _drawEarthquakeEpicenter(Canvas canvas, double cx, double cy, double quakeProg) {
    for (int i = 1; i <= 4; i++) {
      final radius = (quakeProg * 180) * (i / 4.0);
      final alpha = (1.0 - (radius / 180)).clamp(0.0, 1.0);
      final wavePaint = Paint()
        ..color = Colors.amberAccent.withOpacity(alpha * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 - (i * 0.5);
      canvas.drawCircle(Offset(cx, cy), radius, wavePaint);
    }

    // Étoile de l'épicentre
    final starPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 9, starPaint);
  }

  void _drawMotionArrows(Canvas canvas, double w, double h, double fx) {
    final arrowPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    // Plaque gauche (flèche vers le HAUT)
    final lx = fx - 70;
    canvas.drawLine(Offset(lx, h * 0.85), Offset(lx, h * 0.72), arrowPaint);
    canvas.drawLine(Offset(lx, h * 0.72), Offset(lx - 7, h * 0.72 + 10), arrowPaint);
    canvas.drawLine(Offset(lx, h * 0.72), Offset(lx + 7, h * 0.72 + 10), arrowPaint);

    // Plaque droite (flèche vers le BAS)
    final rx = fx + 70;
    canvas.drawLine(Offset(rx, h * 0.15), Offset(rx, h * 0.28), arrowPaint);
    canvas.drawLine(Offset(rx, h * 0.28), Offset(rx - 7, h * 0.28 - 10), arrowPaint);
    canvas.drawLine(Offset(rx, h * 0.28), Offset(rx + 7, h * 0.28 - 10), arrowPaint);
  }

  void _drawStressGauge(Canvas canvas, double w, double h, double stress) {
    final gaugeRect = Rect.fromLTWH(20, 20, 160, 22);
    final bgPaint = Paint()..color = Colors.black54;
    canvas.drawRRect(RRect.fromRectAndRadius(gaugeRect, const Radius.circular(8)), bgPaint);

    final fillPaint = Paint()
      ..color = Color.lerp(Colors.green, Colors.red, stress) ?? Colors.orange;
    final fillRect = Rect.fromLTWH(22, 22, 156 * stress.clamp(0.0, 1.0), 18);
    canvas.drawRRect(RRect.fromRectAndRadius(fillRect, const Radius.circular(6)), fillPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: 'Tension élastique: ${(stress * 100).toInt()}%',
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, const Offset(30, 24));
  }

  void _drawLabels(Canvas canvas, double w, double h, double fx, bool quake) {
    _renderText(canvas, 'Plaque Pacifique (Nord-Ouest)', const Offset(30, 52), Colors.cyanAccent);
    _renderText(canvas, 'Plaque Nord-Américaine (Sud-Est)', Offset(fx + 20, 52), Colors.lightGreenAccent);
    _renderText(canvas, 'Faille de San Andreas (coulissante)', Offset(fx - 90, h - 35), Colors.redAccent);

    if (quake) {
      _renderText(
        canvas,
        '⚡ RUPTURE DU PLAN DE FAILLE (SÉISME !)',
        Offset(fx - 130, h * 0.5 - 30),
        Colors.amberAccent,
      );
    } else {
      _renderText(
        canvas,
        'Blocage par frottement & déformation élastique',
        Offset(fx - 140, h * 0.5 - 25),
        Colors.white70,
      );
    }
  }

  void _renderText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black54,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant Sim2TransformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}
