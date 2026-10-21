import 'dart:math';
import 'package:flutter/material.dart';

/// CustomPainter pour la double vue synchronisée du tsunami :
/// - Haut : Vue du ciel (en plan) montrant la côte, la rupture de faille et les fronts d'ondes circulaires.
/// - Bas : Coupe verticale montrant le rebond élastique de la plaque chevauchante,
///   la propagation au large et le déferlement sur le littoral (effet de haut-fond).
class TsunamiDualViewPainter extends CustomPainter {
  final double progress; // 0.0 (tension) -> 0.2 (rebond) -> 0.6 (propagation) -> 1.0 (submersion)
  final bool isDark;

  TsunamiDualViewPainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final halfH = h * 0.48;

    // Séparateur entre vue du ciel et coupe
    final dividerPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, halfH), Offset(w, halfH), dividerPaint);

    // 1. Vue du ciel (en haut)
    _drawTopDownView(canvas, w, halfH);

    // 2. Coupe verticale (en bas)
    _drawCrossSectionView(canvas, w, halfH, h);
  }

  // --- VUE DU CIEL (PLAN) ---
  void _drawTopDownView(Canvas canvas, double w, double h) {
    // Fond océan profond
    final oceanPaint = Paint()..color = const Color(0xFF01579B);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), oceanPaint);

    // Littoral et continent à droite
    final coastX = w * 0.78;
    final landPath = Path()
      ..moveTo(coastX, 0)
      ..cubicTo(coastX - 15, h * 0.3, coastX + 25, h * 0.7, coastX, h)
      ..lineTo(w, h)
      ..lineTo(w, 0)
      ..close();
    final landPaint = Paint()..color = const Color(0xFF388E3C);
    canvas.drawPath(landPath, landPaint);

    // Plage sableuse
    final beachPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final beachLine = Path()
      ..moveTo(coastX, 0)
      ..cubicTo(coastX - 15, h * 0.3, coastX + 25, h * 0.7, coastX, h);
    canvas.drawPath(beachLine, beachPaint);

    // Faille de subduction sous-marine (ligne rouge à gauche)
    final ruptureX = w * 0.25;
    final faultPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3.5;
    canvas.drawLine(Offset(ruptureX, 15), Offset(ruptureX, h - 15), faultPaint);

    // Fronts d'ondes concentriques se propageant depuis la rupture vers la côte
    if (progress > 0.15) {
      final waveProg = (progress - 0.15) / 0.85;
      final maxRadius = (coastX - ruptureX) * 1.1;

      for (int i = 0; i < 4; i++) {
        final r = (waveProg * maxRadius) - (i * 35.0);
        if (r > 0 && r < maxRadius) {
          final alpha = (1.0 - (r / maxRadius)).clamp(0.1, 0.9);
          final wavePaint = Paint()
            ..color = Colors.cyanAccent.withOpacity(alpha)
            ..strokeWidth = 3.0
            ..style = PaintingStyle.stroke;

          final waveArc = Rect.fromCircle(center: Offset(ruptureX, h * 0.5), radius: r);
          canvas.drawArc(waveArc, -pi / 2.5, 2 * pi / 2.5, false, wavePaint);
        }
      }
    }

    // Bateau au large (subissant une onde imperceptible au large)
    _drawBoat(canvas, w * 0.50, h * 0.35);

    // Label Vue du Ciel
    _renderText(canvas, 'VUE DU CIEL (PLAN) : Propagation des fronts d\'ondes', const Offset(12, 12), Colors.white);
  }

  void _drawBoat(Canvas canvas, double bx, double by) {
    final boatPaint = Paint()..color = Colors.white;
    final boat = Path()
      ..moveTo(bx - 10, by)
      ..lineTo(bx + 10, by)
      ..lineTo(bx + 6, by + 4)
      ..lineTo(bx - 6, by + 4)
      ..close();
    canvas.drawPath(boat, boatPaint);

    // Voile
    final sail = Path()
      ..moveTo(bx, by)
      ..lineTo(bx, by - 12)
      ..lineTo(bx + 7, by - 3)
      ..close();
    canvas.drawPath(sail, Paint()..color = Colors.redAccent);
  }

  // --- VUE EN COUPE VERTICALE ---
  void _drawCrossSectionView(Canvas canvas, double w, double topY, double bottomY) {
    final viewH = bottomY - topY;
    final baseSeaLevel = topY + viewH * 0.32;
    final trenchX = w * 0.28;
    final coastX = w * 0.78;

    // Fond du sous-sol géologique
    final crustPaint = Paint()..color = const Color(0xFF4E342E);
    canvas.drawRect(Rect.fromLTWH(0, topY, w, viewH), crustPaint);

    // 1. Plancher océanique avec plateau continental montant vers la côte
    final seafloor = Path()
      ..moveTo(0, topY + viewH * 0.75)
      ..lineTo(trenchX, topY + viewH * 0.85) // Fosse abyssale
      ..cubicTo(
        trenchX + 40, topY + viewH * 0.75,
        coastX - 100, topY + viewH * 0.65,
        coastX - 35, baseSeaLevel + 12, // Plateau continental peu profond
      )
      ..lineTo(coastX, baseSeaLevel) // Plage
      ..lineTo(w, baseSeaLevel - 15) // Terre émergée
      ..lineTo(w, bottomY)
      ..lineTo(0, bottomY)
      ..close();

    final rockPaint = Paint()
      ..color = isDark ? const Color(0xFF2E241F) : const Color(0xFF5D4037);
    canvas.drawPath(seafloor, rockPaint);

    // 2. Déformation de la plaque chevauchante (Rebond élastique au niveau de la fosse)
    double reboundY = 0.0;
    if (progress < 0.2) {
      // Phase 1 : flexion vers le bas par friction (tension)
      reboundY = progress * 25;
    } else {
      // Phase 2 : rebond élastique brutal vers le haut
      final t = (progress - 0.2) / 0.15;
      reboundY = -35.0 * (1.0 - t.clamp(0.0, 1.0));
    }

    // 3. Surface de l'eau avec onde de tsunami
    final waterPath = Path();
    waterPath.moveTo(0, baseSeaLevel);

    for (double x = 0; x <= coastX + 40; x += 6) {
      double waveElevation = 0.0;

      if (progress < 0.2) {
        // Creux au-dessus de la zone fléchie
        final dist = (x - trenchX).abs();
        if (dist < 60) {
          waveElevation = reboundY * (1.0 - dist / 60);
        }
      } else {
        // Onde en propagation vers la droite
        final waveFrontX = trenchX + (coastX + 20 - trenchX) * ((progress - 0.2) / 0.8).clamp(0.0, 1.0);
        final dist = (x - waveFrontX).abs();

        if (dist < 70) {
          // Effet de haut-fond (Shoaling) : en eau profonde amplitude faible,
          // sur le plateau continental la vague ralentit et son amplitude explose vers le haut !
          final depthFactor = (x / coastX).clamp(0.2, 1.5);
          final shoalingMultiplier = pow(depthFactor, 3.0);
          final waveH = 14.0 * shoalingMultiplier;

          waveElevation = -waveH * cos((x - waveFrontX) / 70 * (pi / 2));
        }
      }

      waterPath.lineTo(x, baseSeaLevel + waveElevation);
    }

    // Déferlement et submersion de la terre ferme si progress > 0.85
    if (progress > 0.85) {
      final floodProg = (progress - 0.85) / 0.15;
      waterPath.lineTo(coastX + (w - coastX) * floodProg, baseSeaLevel - 8);
      waterPath.lineTo(coastX + (w - coastX) * floodProg, bottomY);
    } else {
      waterPath.lineTo(coastX, baseSeaLevel + 12);
      waterPath.lineTo(coastX, bottomY);
    }

    waterPath.lineTo(0, bottomY);
    waterPath.close();

    final waterPaint = Paint()
      ..color = const Color.fromRGBO(2, 136, 209, 0.65);
    canvas.drawPath(waterPath, waterPaint);

    // Écume blanche sur la crête de la vague déferlante
    if (progress > 0.6) {
      final waveFrontX = trenchX + (coastX + 20 - trenchX) * ((progress - 0.2) / 0.8).clamp(0.0, 1.0);
      final foamPaint = Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..strokeWidth = 3.5;
      canvas.drawLine(
        Offset(waveFrontX - 15, baseSeaLevel - 28),
        Offset(waveFrontX + 15, baseSeaLevel - 25),
        foamPaint,
      );
    }

    // Label Coupe verticale
    _renderText(canvas, 'COUPE VERTICALE : Rebond élastique, propagation rapide et surrection côtière', Offset(12, topY + 12), Colors.white);
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
  bool shouldRepaint(covariant TsunamiDualViewPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
