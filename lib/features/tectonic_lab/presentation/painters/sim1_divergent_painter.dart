import 'package:flutter/material.dart';

/// Simulation 1 : Limite Divergente (Du Rift à l'Océan)
/// Étapes géologiques :
/// - 0.00 à 0.25 : Bombement thermique et amincissement crustal
/// - 0.25 à 0.50 : Fossé d'effondrement continental (Rift Est-Africain) avec failles normales
/// - 0.50 à 0.75 : Invasion marine étroite (stade Mer Rouge)
/// - 0.75 à 1.00 : Dorsale océanique mature avec accrétion basaltique symétrique (Océan Atlantique)
class Sim1DivergentPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim1DivergentPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Découpage vertical
    final mantleTopY = h * 0.42;

    // 1. Fond Asthénosphère avec dégradé thermique
    final mantleRect = Rect.fromLTWH(0, mantleTopY, w, h - mantleTopY);
    final mantlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF8B2500), const Color(0xFFD84315), const Color(0xFFFF5722)]
            : [const Color(0xFFA04000), const Color(0xFFE65100), const Color(0xFFFF7043)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(mantleRect);
    canvas.drawRect(mantleRect, mantlePaint);

    // Convection mantellique divergente (flèches ascendantes puis latérales)
    _drawMantleConvection(canvas, w, h, mantleTopY);

    // 2. Calcul du rift et de l'ouverture
    final centerX = w * 0.5;
    final riftHalfWidth = w * (0.02 + 0.22 * progress);
    final riftDepth = h * (0.08 + 0.14 * progress);

    // Croûte continentale gauche
    final leftCrust = Path()
      ..moveTo(0, h * 0.30)
      ..lineTo(centerX - riftHalfWidth - 30, h * 0.30 - (progress < 0.3 ? 12 * (1 - progress / 0.3) : 0))
      ..lineTo(centerX - riftHalfWidth, h * 0.30 + riftDepth * 0.6)
      ..lineTo(centerX - (riftHalfWidth * 0.2), mantleTopY + riftDepth * 0.4)
      ..lineTo(0, mantleTopY)
      ..close();

    // Croûte continentale droite
    final rightCrust = Path()
      ..moveTo(w, h * 0.30)
      ..lineTo(centerX + riftHalfWidth + 30, h * 0.30 - (progress < 0.3 ? 12 * (1 - progress / 0.3) : 0))
      ..lineTo(centerX + riftHalfWidth, h * 0.30 + riftDepth * 0.6)
      ..lineTo(centerX + (riftHalfWidth * 0.2), mantleTopY + riftDepth * 0.4)
      ..lineTo(w, mantleTopY)
      ..close();

    final crustPaint = Paint()
      ..color = isDark ? const Color(0xFF6D4C41) : const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftCrust, crustPaint);
    canvas.drawPath(rightCrust, crustPaint);

    // Failles normales (gradins d'effondrement)
    _drawNormalFaults(canvas, centerX, riftHalfWidth, h * 0.30, riftDepth);

    // 3. Stade océanique (Accrétion de croûte océanique basaltique si progress > 0.4)
    if (progress > 0.4) {
      final oceanicProgress = (progress - 0.4) / 0.6;
      final oceanFloorWidth = riftHalfWidth * 1.5 * oceanicProgress;

      final oceanicCrustPath = Path()
        ..moveTo(centerX - oceanFloorWidth, mantleTopY)
        ..lineTo(centerX, mantleTopY - 18) // Crête de la dorsale
        ..lineTo(centerX + oceanFloorWidth, mantleTopY)
        ..lineTo(centerX + oceanFloorWidth, mantleTopY + 22)
        ..lineTo(centerX - oceanFloorWidth, mantleTopY + 22)
        ..close();

      final oceanicPaint = Paint()
        ..color = const Color(0xFF263238)
        ..style = PaintingStyle.fill;
      canvas.drawPath(oceanicCrustPath, oceanicPaint);

      // Rubans magnétiques / dykes basaltiques
      final dykePaint = Paint()
        ..color = const Color(0xFF37474F)
        ..strokeWidth = 3;
      for (double d = 10; d < oceanFloorWidth; d += 18) {
        canvas.drawLine(Offset(centerX - d, mantleTopY), Offset(centerX - d, mantleTopY + 22), dykePaint);
        canvas.drawLine(Offset(centerX + d, mantleTopY), Offset(centerX + d, mantleTopY + 22), dykePaint);
      }

      // Vallée axiale et magma ascendant
      final ridgeMagma = Path()
        ..moveTo(centerX - 8, mantleTopY + 45)
        ..lineTo(centerX + 8, mantleTopY + 45)
        ..lineTo(centerX + 3, mantleTopY - 14)
        ..lineTo(centerX - 3, mantleTopY - 14)
        ..close();
      final magmaPaint = Paint()
        ..color = const Color(0xFFFF3D00)
        ..style = PaintingStyle.fill;
      canvas.drawPath(ridgeMagma, magmaPaint);
    }

    // 4. Eau de mer (si progress > 0.3 : inondation du fossé)
    if (progress > 0.3) {
      final waterProgress = (progress - 0.3) / 0.7;
      final seaLevelY = h * 0.28;
      final waterPath = Path()
        ..moveTo(centerX - riftHalfWidth - 10, seaLevelY)
        ..lineTo(centerX + riftHalfWidth + 10, seaLevelY)
        ..lineTo(centerX + riftHalfWidth * 0.7, h * 0.30 + riftDepth * 0.5)
        ..lineTo(centerX - riftHalfWidth * 0.7, h * 0.30 + riftDepth * 0.5)
        ..close();

      final waterPaint = Paint()
        ..color = Color.fromRGBO(2, 136, 209, 0.45 + 0.35 * waterProgress)
        ..style = PaintingStyle.fill;
      canvas.drawPath(waterPath, waterPaint);

      // Vaguelettes de surface
      final wavePaint = Paint()
        ..color = Colors.lightBlueAccent.withOpacity(0.6)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(centerX - riftHalfWidth - 10, seaLevelY),
        Offset(centerX + riftHalfWidth + 10, seaLevelY),
        wavePaint,
      );
    }

    // 5. Flèches de divergence
    _drawDivergenceArrows(canvas, centerX, h * 0.22, riftHalfWidth);

    // 6. Légendes pédagogiques
    if (showLegends) {
      _drawLabels(canvas, w, h, centerX, riftHalfWidth);
    }
  }

  void _drawNormalFaults(Canvas canvas, double cx, double halfW, double topY, double depth) {
    final faultPaint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1.5;

    // Failles normales à gauche
    canvas.drawLine(Offset(cx - halfW * 0.8, topY), Offset(cx - halfW * 0.5, topY + depth * 0.7), faultPaint);
    canvas.drawLine(Offset(cx - halfW * 0.5, topY), Offset(cx - halfW * 0.2, topY + depth * 0.9), faultPaint);

    // Failles normales à droite (symétriques)
    canvas.drawLine(Offset(cx + halfW * 0.8, topY), Offset(cx + halfW * 0.5, topY + depth * 0.7), faultPaint);
    canvas.drawLine(Offset(cx + halfW * 0.5, topY), Offset(cx + halfW * 0.2, topY + depth * 0.9), faultPaint);
  }

  void _drawMantleConvection(Canvas canvas, double w, double h, double topY) {
    final arrowPaint = Paint()
      ..color = const Color(0xFFFFD54F).withOpacity(0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final cx = w * 0.5;
    final cy = topY + (h - topY) * 0.5;

    // Cellule gauche (sens anti-horaire)
    final pathLeft = Path()
      ..moveTo(cx - 15, h * 0.9)
      ..cubicTo(cx - 15, cy, cx - 80, topY + 30, cx - 140, topY + 30)
      ..cubicTo(cx - 200, topY + 30, cx - 220, cy, cx - 180, h * 0.85);
    canvas.drawPath(pathLeft, arrowPaint);

    // Cellule droite (sens horaire)
    final pathRight = Path()
      ..moveTo(cx + 15, h * 0.9)
      ..cubicTo(cx + 15, cy, cx + 80, topY + 30, cx + 140, topY + 30)
      ..cubicTo(cx + 200, topY + 30, cx + 220, cy, cx + 180, h * 0.85);
    canvas.drawPath(pathRight, arrowPaint);
  }

  void _drawDivergenceArrows(Canvas canvas, double cx, double y, double halfW) {
    final paint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final arrowLen = 35.0;
    // Flèche gauche
    final leftX = cx - halfW - 20;
    canvas.drawLine(Offset(leftX, y), Offset(leftX - arrowLen, y), paint);
    canvas.drawLine(Offset(leftX - arrowLen, y), Offset(leftX - arrowLen + 8, y - 6), paint);
    canvas.drawLine(Offset(leftX - arrowLen, y), Offset(leftX - arrowLen + 8, y + 6), paint);

    // Flèche droite
    final rightX = cx + halfW + 20;
    canvas.drawLine(Offset(rightX, y), Offset(rightX + arrowLen, y), paint);
    canvas.drawLine(Offset(rightX + arrowLen, y), Offset(rightX + arrowLen - 8, y - 6), paint);
    canvas.drawLine(Offset(rightX + arrowLen, y), Offset(rightX + arrowLen - 8, y + 6), paint);
  }

  void _drawLabels(Canvas canvas, double w, double h, double cx, double halfW) {
    _renderText(canvas, 'Croûte continentale', Offset(30, h * 0.32), isDark ? Colors.white : Colors.black87);
    _renderText(canvas, 'Croûte continentale', Offset(w - 170, h * 0.32), isDark ? Colors.white : Colors.black87);
    _renderText(canvas, 'Asthénosphère convective (ductile)', Offset(w * 0.5 - 110, h * 0.82), Colors.white);

    if (progress < 0.4) {
      _renderText(canvas, 'Rift continental (effondrement)', Offset(cx - 95, h * 0.12), Colors.amber);
    } else if (progress < 0.75) {
      _renderText(canvas, 'Mer linéaire (stade Mer Rouge)', Offset(cx - 95, h * 0.12), Colors.lightBlueAccent);
    } else {
      _renderText(canvas, 'Dorsale médio-océanique & rift axial', Offset(cx - 115, h * 0.12), Colors.orangeAccent);
      _renderText(canvas, 'Croûte océanique basaltique', Offset(cx - 85, h * 0.46), Colors.white70);
    }
  }

  void _renderText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          backgroundColor: Colors.black.withOpacity(0.4),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant Sim1DivergentPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}
