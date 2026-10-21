import 'package:flutter/material.dart';

/// Simulation 3 : Convergence Océan / Continent (Subduction & Cordillère des Andes)
/// Éléments géodynamiques :
/// - Plaque océanique plongeante (lithosphère océanique dense)
/// - Fosse océanique profonde
/// - Prisme d'accrétion sédimentaire
/// - Fusion partielle du manteau hydraté à ~100 km
/// - Remontée magmatique et arc volcanique continental (stratovolcan)
/// - Plan de Wadati-Benioff (séismes échelonnés en profondeur)
class Sim3SubductionOceanContinentPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim3SubductionOceanContinentPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Repères géométriques
    final seaLevelY = h * 0.32;
    final trenchX = w * (0.38 - 0.05 * progress);
    final slabTipDepth = h * (0.50 + 0.45 * progress);
    final slabTipX = trenchX + w * (0.28 + 0.15 * progress);

    // 1. Manteau asthénosphérique chaud de fond
    final mantleRect = Rect.fromLTWH(0, seaLevelY + 30, w, h - (seaLevelY + 30));
    final mantlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF7E2A0C), const Color(0xFFC83803), const Color(0xFFFF5722)]
            : [const Color(0xFF8D4004), const Color(0xFFE65100), const Color(0xFFFF7043)],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(mantleRect);
    canvas.drawRect(mantleRect, mantlePaint);

    // 2. Plaque Océanique Plongeante (Lithosphère océanique)
    final oceanicPath = Path()
      ..moveTo(0, seaLevelY + 35)
      ..lineTo(trenchX, seaLevelY + 45) // Inflexion fosse
      ..cubicTo(
        trenchX + w * 0.08, seaLevelY + 65,
        slabTipX - w * 0.06, slabTipDepth * 0.75,
        slabTipX, slabTipDepth,
      )
      ..lineTo(slabTipX + 22, slabTipDepth + 15)
      ..cubicTo(
        slabTipX - w * 0.03, slabTipDepth * 0.85,
        trenchX + w * 0.07, seaLevelY + 105,
        0, seaLevelY + 75,
      )
      ..close();

    final oceanicPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.fill;
    canvas.drawPath(oceanicPath, oceanicPaint);

    // Croûte basaltique superficielle (bleutée très foncée)
    final oceanicCrustLine = Path()
      ..moveTo(0, seaLevelY + 35)
      ..lineTo(trenchX, seaLevelY + 45)
      ..cubicTo(
        trenchX + w * 0.08, seaLevelY + 65,
        slabTipX - w * 0.06, slabTipDepth * 0.75,
        slabTipX, slabTipDepth,
      );
    final crustPaint = Paint()
      ..color = const Color(0xFF455A64)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(oceanicCrustLine, crustPaint);

    // 3. Océan et colonne d'eau
    final oceanPath = Path()
      ..moveTo(0, seaLevelY)
      ..lineTo(trenchX, seaLevelY)
      ..lineTo(trenchX, seaLevelY + 45)
      ..lineTo(0, seaLevelY + 35)
      ..close();
    final oceanPaint = Paint()
      ..color = const Color.fromRGBO(2, 136, 209, 0.65)
      ..style = PaintingStyle.fill;
    canvas.drawPath(oceanPath, oceanPaint);

    // 4. Prisme d'accrétion sédimentaire
    final prismPath = Path()
      ..moveTo(trenchX, seaLevelY + 45)
      ..lineTo(trenchX + w * 0.06, seaLevelY + 15)
      ..lineTo(trenchX + w * 0.09, seaLevelY + 38)
      ..close();
    final prismPaint = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..style = PaintingStyle.fill;
    canvas.drawPath(prismPath, prismPaint);

    // Écailles tectoniques dans le prisme
    final prismLinePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(trenchX + 12, seaLevelY + 40), Offset(trenchX + 28, seaLevelY + 22), prismLinePaint);

    // 5. Plaque Continentale & Cordillère des Andes
    final volcanoX = trenchX + w * 0.22;
    final volcanoElevation = 50.0 + 35.0 * progress;
    final continentalCrust = Path()
      ..moveTo(trenchX + w * 0.06, seaLevelY + 15)
      ..lineTo(volcanoX - 60, seaLevelY + 8)
      ..lineTo(volcanoX - 18, seaLevelY - volcanoElevation) // Sommet volcan gauche
      ..lineTo(volcanoX + 18, seaLevelY - volcanoElevation) // Cratère
      ..lineTo(volcanoX + 65, seaLevelY - volcanoElevation * 0.6) // Chaîne de montagnes
      ..lineTo(w, seaLevelY)
      ..lineTo(w, seaLevelY + 95)
      ..lineTo(volcanoX + 60, seaLevelY + 115)
      ..lineTo(trenchX + w * 0.12, seaLevelY + 80)
      ..close();

    final contPaint = Paint()
      ..color = isDark ? const Color(0xFF6D4C41) : const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawPath(continentalCrust, contPaint);

    // Sommets enneigés de la Cordillère
    final snowPath = Path()
      ..moveTo(volcanoX - 25, seaLevelY - volcanoElevation + 12)
      ..lineTo(volcanoX - 18, seaLevelY - volcanoElevation)
      ..lineTo(volcanoX + 18, seaLevelY - volcanoElevation)
      ..lineTo(volcanoX + 30, seaLevelY - volcanoElevation + 15)
      ..close();
    final snowPaint = Paint()..color = Colors.white;
    canvas.drawPath(snowPath, snowPaint);

    // 6. Zone de fusion partielle (Coin mantellique vers 100 km de profondeur)
    final meltCenter = Offset(trenchX + w * 0.18, seaLevelY + 155);
    final meltPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFD600), const Color(0xFFFF3D00).withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: meltCenter, radius: 45));
    canvas.drawCircle(meltCenter, 45, meltPaint);

    // Diapirs magmatiques ascendants
    final magmaPath = Path()
      ..moveTo(meltCenter.dx, meltCenter.dy)
      ..cubicTo(meltCenter.dx - 10, meltCenter.dy - 60, volcanoX - 15, seaLevelY + 30, volcanoX - 10, seaLevelY)
      ..lineTo(volcanoX + 10, seaLevelY)
      ..cubicTo(volcanoX + 15, seaLevelY + 30, meltCenter.dx + 10, meltCenter.dy - 60, meltCenter.dx, meltCenter.dy);
    final magmaPaint = Paint()
      ..color = const Color(0xFFFF3D00)
      ..style = PaintingStyle.fill;
    canvas.drawPath(magmaPath, magmaPaint);

    // Éruption volcanique active (fumée et lave)
    _drawVolcanoEruption(canvas, volcanoX, seaLevelY - volcanoElevation);

    // 7. Plan de Benioff-Wadati (séismes)
    _drawBenioffZone(canvas, trenchX, seaLevelY + 45, slabTipX, slabTipDepth);

    // 8. Flèche de subduction de la plaque océanique
    _drawSubductionArrow(canvas, w * 0.15, seaLevelY + 20);

    // 9. Légendes pédagogiques
    if (showLegends) {
      _drawLabels(canvas, w, h, trenchX, volcanoX, seaLevelY);
    }
  }

  void _drawVolcanoEruption(Canvas canvas, double vx, double topY) {
    // Panache de cendres
    final ashPaint = Paint()
      ..color = Colors.grey.withOpacity(0.75)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(vx, topY - 22), 14, ashPaint);
    canvas.drawCircle(Offset(vx + 8, topY - 38), 18, ashPaint);
    canvas.drawCircle(Offset(vx - 6, topY - 48), 24, ashPaint);

    // Coulée de lave
    final lavaPaint = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(vx - 10, topY), Offset(vx - 22, topY + 25), lavaPaint);
  }

  void _drawBenioffZone(Canvas canvas, double startX, double startY, double endX, double endY) {
    final quakePaint = Paint()..color = Colors.yellowAccent;
    final count = 7;
    for (int i = 1; i <= count; i++) {
      final t = i / (count + 1);
      final qx = startX + (endX - startX) * t;
      final qy = startY + (endY - startY) * t * (0.8 + 0.3 * t);
      canvas.drawCircle(Offset(qx, qy), 4.0, quakePaint);
    }
  }

  void _drawSubductionArrow(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x, y), Offset(x + 40, y), paint);
    canvas.drawLine(Offset(x + 40, y), Offset(x + 32, y - 6), paint);
    canvas.drawLine(Offset(x + 40, y), Offset(x + 32, y + 6), paint);
  }

  void _drawLabels(Canvas canvas, double w, double h, double trenchX, double volcanoX, double seaY) {
    _renderText(canvas, 'Plaque plongeante (Nazca)', Offset(20, seaY - 20), Colors.cyanAccent);
    _renderText(canvas, 'Fosse océanique (>7000 m)', Offset(trenchX - 70, seaY + 58), Colors.lightBlueAccent);
    _renderText(canvas, 'Prisme d\'accrétion', Offset(trenchX + 20, seaY + 8), Colors.limeAccent);
    _renderText(canvas, 'Arc volcanique (Cordillère)', Offset(volcanoX - 45, seaY - 95), Colors.amberAccent);
    _renderText(canvas, 'Fusion partielle (~100 km)', Offset(trenchX + w * 0.12, seaY + 165), Colors.orangeAccent);
    _renderText(canvas, 'Foyers sismiques (Plan de Bénioff)', Offset(trenchX + 15, seaY + 120), Colors.yellowAccent);
  }

  void _renderText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withOpacity(0.55),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant Sim3SubductionOceanContinentPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}
