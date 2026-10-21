import 'package:flutter/material.dart';

/// Simulation 4 : Convergence Océan / Océan (Subduction & Arc Insulaire)
/// Exemples réels : Fosse des Mariannes & Arc des Mariannes, Japon, Petites Antilles.
/// Caractéristiques :
/// - Deux plaques océaniques (la plus âgée/dense plonge sous la plus jeune).
/// - Fosse océanique abyssale (>10 000 m).
/// - Magmatisme sous-marin s'accumulant jusqu'à l'émersion d'îles volcaniques en arc.
/// - Bassin arrière-arc (back-arc basin).
class Sim4SubductionOceanOceanPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim4SubductionOceanOceanPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final seaLevelY = h * 0.32;
    final trenchX = w * (0.42 - 0.04 * progress);
    final slabDepth = h * (0.55 + 0.40 * progress);
    final slabX = trenchX + w * (0.24 + 0.10 * progress);

    // 1. Manteau asthénosphérique
    final mantleRect = Rect.fromLTWH(0, seaLevelY + 45, w, h - (seaLevelY + 45));
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

    // 2. Plaque plongeante (océanique ancienne, très dense)
    final slabPath = Path()
      ..moveTo(0, seaLevelY + 30)
      ..lineTo(trenchX, seaLevelY + 55) // Fosse ultra-profonde
      ..cubicTo(
        trenchX + w * 0.08, seaLevelY + 80,
        slabX - w * 0.05, slabDepth * 0.8,
        slabX, slabDepth,
      )
      ..lineTo(slabX + 25, slabDepth + 15)
      ..cubicTo(
        slabX - w * 0.02, slabDepth * 0.85,
        trenchX + w * 0.08, seaLevelY + 115,
        0, seaLevelY + 65,
      )
      ..close();

    final slabPaint = Paint()
      ..color = const Color(0xFF1E282D)
      ..style = PaintingStyle.fill;
    canvas.drawPath(slabPath, slabPaint);

    // 3. Plaque chevauchante (océanique plus jeune)
    final islandX = trenchX + w * 0.18;
    // Élévation de l'île volcanique au fur et à mesure de l'accrétion magmatique
    final islandHeight = 15.0 + 35.0 * progress;

    final overridingPlate = Path()
      ..moveTo(trenchX + 15, seaLevelY + 48)
      ..lineTo(islandX - 35, seaLevelY + 28)
      ..lineTo(islandX - 12, seaLevelY - islandHeight) // Île volcanique 1
      ..lineTo(islandX + 12, seaLevelY - islandHeight)
      ..lineTo(islandX + 35, seaLevelY + 25)
      ..lineTo(islandX + 70, seaLevelY + 20) // Île 2
      ..lineTo(islandX + 85, seaLevelY - (islandHeight * 0.7))
      ..lineTo(islandX + 105, seaLevelY + 24)
      ..lineTo(w, seaLevelY + 30)
      ..lineTo(w, seaLevelY + 70)
      ..lineTo(trenchX + 25, seaLevelY + 85)
      ..close();

    final overPaint = Paint()
      ..color = const Color(0xFF37474F)
      ..style = PaintingStyle.fill;
    canvas.drawPath(overridingPlate, overPaint);

    // 4. Océan recouvrant les deux plaques
    final oceanPath = Path()
      ..moveTo(0, seaLevelY)
      ..lineTo(w, seaLevelY)
      ..lineTo(w, seaLevelY + 30)
      ..lineTo(islandX + 105, seaLevelY + 24)
      ..lineTo(islandX + 98, seaLevelY)
      ..lineTo(islandX + 80, seaLevelY)
      ..lineTo(islandX + 35, seaLevelY + 25)
      ..lineTo(islandX + 22, seaLevelY)
      ..lineTo(islandX - 22, seaLevelY)
      ..lineTo(islandX - 35, seaLevelY + 28)
      ..lineTo(trenchX, seaLevelY + 55)
      ..lineTo(0, seaLevelY + 30)
      ..close();

    final oceanPaint = Paint()
      ..color = const Color.fromRGBO(1, 87, 155, 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawPath(oceanPath, oceanPaint);

    // 5. Zone de fusion mantellique et conduits magmatiques vers les îles
    final meltPoint = Offset(trenchX + w * 0.15, seaLevelY + 130);
    final meltPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFD600), const Color(0xFFFF3D00).withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: meltPoint, radius: 40));
    canvas.drawCircle(meltPoint, 40, meltPaint);

    // Montée du magma vers l'île
    final conduitPaint = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 4.0;
    canvas.drawLine(meltPoint, Offset(islandX, seaLevelY), conduitPaint);
    canvas.drawLine(meltPoint, Offset(islandX + 90, seaLevelY), conduitPaint);

    // Fumerolles sur l'île principale
    final smokePaint = Paint()..color = Colors.white70;
    canvas.drawCircle(Offset(islandX, seaLevelY - islandHeight - 10), 6, smokePaint);
    canvas.drawCircle(Offset(islandX + 4, seaLevelY - islandHeight - 18), 9, smokePaint);

    // 6. Foyers sismiques
    final quakePaint = Paint()..color = Colors.yellowAccent;
    for (int i = 1; i <= 6; i++) {
      final t = i / 7.0;
      final qx = trenchX + (slabX - trenchX) * t;
      final qy = (seaLevelY + 55) + (slabDepth - (seaLevelY + 55)) * t * (0.8 + 0.3 * t);
      canvas.drawCircle(Offset(qx, qy), 3.5, quakePaint);
    }

    // 7. Légendes
    if (showLegends) {
      _drawLabels(canvas, w, h, trenchX, islandX, seaLevelY);
    }
  }

  void _drawLabels(Canvas canvas, double w, double h, double trenchX, double islandX, double seaY) {
    _renderText(canvas, 'Plaque océanique âgée (plongeante)', Offset(20, seaY - 20), Colors.cyanAccent);
    _renderText(canvas, 'Fosse des Mariannes (>10 000 m)', Offset(trenchX - 90, seaY + 65), Colors.lightBlueAccent);
    _renderText(canvas, 'Arc insulaire volcanique (Japon/Antilles)', Offset(islandX - 60, seaY - 55), Colors.amberAccent);
    _renderText(canvas, 'Plaque chevauchante plus jeune', Offset(w - 210, seaY + 40), Colors.white70);
    _renderText(canvas, 'Bassin arrière-arc', Offset(islandX + 80, seaY - 20), Colors.tealAccent);
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
  bool shouldRepaint(covariant Sim4SubductionOceanOceanPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}
