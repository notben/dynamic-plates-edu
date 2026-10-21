import 'dart:math';
import 'package:flutter/material.dart';

/// Simulation 7 : Modèle Global de la Terre & Convection Mantellique
/// Structure de l'intérieur de la Terre :
/// 1. Graine (noyau interne solide, fer-nickel, ~5150-6371 km)
/// 2. Noyau externe liquide (convection métallique -> champ magnétique, ~2890-5150 km)
/// 3. Manteau inférieur (mésosphère ductile solide, ~660-2890 km)
/// 4. Manteau supérieur & Asthénosphère (~100-660 km)
/// 5. Lithosphère rigide & Croûte (plaques tectoniques, 0-100 km)
/// Moteur géodynamique : Convection thermique avec courants chauds ascendants (dorsales)
/// et plaques froides plongeantes (subduction).
class Sim7GlobalEarthPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim7GlobalEarthPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.50, h * 0.52);
    final maxRadius = min(w * 0.44, h * 0.44);

    // Rayons proportionnels de la structure interne terrestre (R_Terre = 6371 km)
    final rInnerCore = maxRadius * (1220 / 6371); // ~19%
    final rOuterCore = maxRadius * (3480 / 6371); // ~55%
    final rLowerMantle = maxRadius * (5700 / 6371); // ~89%
    final rUpperMantle = maxRadius * (6270 / 6371); // ~98%
    final rCrust = maxRadius; // 100%

    // 1. Fond Espace
    final spacePaint = Paint()..color = const Color(0xFF0A0E17);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), spacePaint);

    // 2. Manteau Supérieur / Asthénosphère (orange-brun)
    final upperMantlePaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFE65100), const Color(0xFF8D4004)],
      ).createShader(Rect.fromCircle(center: center, radius: rUpperMantle));
    canvas.drawCircle(center, rUpperMantle, upperMantlePaint);

    // 3. Manteau Inférieur (rouge-brun sombre)
    final lowerMantlePaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFBF360C), const Color(0xFF5D1D04)],
      ).createShader(Rect.fromCircle(center: center, radius: rLowerMantle));
    canvas.drawCircle(center, rLowerMantle, lowerMantlePaint);

    // 4. Noyau Externe Liquide (jaune-orangé incandescence)
    final outerCorePaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFD54F), const Color(0xFFFF6D00)],
      ).createShader(Rect.fromCircle(center: center, radius: rOuterCore));
    canvas.drawCircle(center, rOuterCore, outerCorePaint);

    // 5. Graine (Noyau Interne Solide, blanc/doré ultra-chaud)
    final innerCorePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, const Color(0xFFFFECB3)],
      ).createShader(Rect.fromCircle(center: center, radius: rInnerCore));
    canvas.drawCircle(center, rInnerCore, innerCorePaint);

    // 6. Lithosphère et Croûte en surface (cercle extérieur mince)
    final crustPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, rCrust, crustPaint);

    // Océans en surface
    final oceanArcPaint = Paint()
      ..color = const Color(0xFF0288D1)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    // Arcs océaniques
    canvas.drawArc(Rect.fromCircle(center: center, radius: rCrust), 0.2, 1.2, false, oceanArcPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: rCrust), 2.2, 1.6, false, oceanArcPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: rCrust), 4.4, 1.4, false, oceanArcPaint);

    // 7. Cellules de convection mantelliques animées (Boucles thermiques)
    _drawConvectionLoops(canvas, center, rOuterCore, rUpperMantle);

    // 8. Sites géodynamiques (Dorsales et Subductions sur la coupe)
    _drawGeodynamicSites(canvas, center, rCrust, rUpperMantle);

    // 9. Légendes
    if (showLegends) {
      _drawLabels(canvas, w, h, center, maxRadius, rInnerCore, rOuterCore, rLowerMantle);
    }
  }

  void _drawConvectionLoops(Canvas canvas, Offset center, double rMin, double rMax) {
    final loopCount = 4;
    final rMid = (rMin + rMax) * 0.52;

    for (int i = 0; i < loopCount; i++) {
      final baseAngle = (i * 2 * pi / loopCount) + (progress * 0.8);
      final isClockwise = i % 2 == 0;

      // Dessin d'une boucle convective
      final cellAngle = baseAngle;
      final cellCenter = Offset(
        center.dx + rMid * cos(cellAngle),
        center.dy + rMid * sin(cellAngle),
      );

      final loopPaint = Paint()
        ..color = isClockwise
            ? const Color(0xFFFFAB00).withOpacity(0.55)
            : const Color(0xFFFF6D00).withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final loopRadius = (rMax - rMin) * 0.38;
      canvas.drawCircle(cellCenter, loopRadius, loopPaint);

      // Flèche dynamique sur la boucle
      final arrowAngle = isClockwise ? (progress * 4 * pi) : -(progress * 4 * pi);
      final ax = cellCenter.dx + loopRadius * cos(arrowAngle);
      final ay = cellCenter.dy + loopRadius * sin(arrowAngle);

      final arrowHeadPaint = Paint()..color = Colors.amberAccent;
      canvas.drawCircle(Offset(ax, ay), 3.0, arrowHeadPaint);
    }
  }

  void _drawGeodynamicSites(Canvas canvas, Offset center, double rCrust, double rUpper) {
    // 1. Dorsale océanique (remontée magmatique)
    final ridgeAngle = 0.8;
    final rx = center.dx + rCrust * cos(ridgeAngle);
    final ry = center.dy + rCrust * sin(ridgeAngle);
    final ridgePaint = Paint()..color = Colors.redAccent;
    canvas.drawCircle(Offset(rx, ry), 5.0, ridgePaint);

    // 2. Zone de subduction (plongeon froid vers l'intérieur)
    final subAngle = 2.4;
    final sx = center.dx + rCrust * cos(subAngle);
    final sy = center.dy + rCrust * sin(subAngle);
    final subPaint = Paint()..color = Colors.cyanAccent;
    canvas.drawCircle(Offset(sx, sy), 5.0, subPaint);

    // Slab plongeant dans le manteau
    final slabPath = Path()
      ..moveTo(sx, sy)
      ..lineTo(center.dx + (rUpper - 25) * cos(subAngle + 0.15), center.dy + (rUpper - 25) * sin(subAngle + 0.15));
    final slabPaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.8)
      ..strokeWidth = 4.0;
    canvas.drawPath(slabPath, slabPaint);
  }

  void _drawLabels(Canvas canvas, double w, double h, Offset center, double maxR, double rIn, double rOut, double rLow) {
    _renderText(canvas, 'Graine solide (~6000°C)', Offset(center.dx - 65, center.dy - 6), Colors.white);
    _renderText(canvas, 'Noyau externe liquide', Offset(center.dx - 65, center.dy - rIn - 25), Colors.black87);
    _renderText(canvas, 'Manteau inférieur (mésosphère)', Offset(center.dx - 85, center.dy - rOut - 20), Colors.white);
    _renderText(canvas, 'Asthénosphère (cellules de convection)', Offset(center.dx - 110, center.dy - maxR + 15), Colors.amberAccent);
    _renderText(canvas, 'Lithosphère & Croûte (0-100 km)', Offset(20, h - 35), Colors.lightGreenAccent);
    _renderText(canvas, 'Dorsale (création lithosphère)', Offset(w - 180, center.dy + 30), Colors.redAccent);
    _renderText(canvas, 'Subduction (recyclage du slab)', const Offset(20, 45), Colors.cyanAccent);
  }

  void _renderText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withOpacity(0.65),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant Sim7GlobalEarthPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}
