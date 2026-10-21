import 'dart:math';
import 'package:flutter/material.dart';

enum EruptionType { hawaiian, fissure, strombolian, plinian }

/// CustomPainter haute performance pour le simulateur des 4 régimes d'éruptions volcaniques.
/// Rendu procédural des édifices volcaniques (bouclier, trapp, cône, stratovolcan) et des panaches/laves.
class VolcanoEruptionPainter extends CustomPainter {
  final EruptionType type;
  final double progress; // Animation tick [0.0 - 1.0]
  final double viscosity; // 0.0 (très fluide) à 1.0 (très visqueux)
  final double gasContent; // 0.0 (dégazé) à 1.0 (très riche en gaz)
  final bool isDark;

  VolcanoEruptionPainter({
    required this.type,
    required this.progress,
    required this.viscosity,
    required this.gasContent,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final groundY = h * 0.70;
    final ventX = w * 0.50;

    // 1. Fond ciel et croûte terrestre
    _drawBackground(canvas, w, h, groundY);

    // 2. Chambre magmatique et conduit d'alimentation
    _drawMagmaChamberAndConduit(canvas, ventX, groundY, h);

    // 3. Dessin de l'édifice volcanique selon le régime
    switch (type) {
      case EruptionType.hawaiian:
        _drawHawaiian(canvas, w, groundY, ventX);
        break;
      case EruptionType.fissure:
        _drawFissure(canvas, w, groundY, ventX);
        break;
      case EruptionType.strombolian:
        _drawStrombolian(canvas, w, groundY, ventX);
        break;
      case EruptionType.plinian:
        _drawPlinian(canvas, w, groundY, ventX);
        break;
    }
  }

  void _drawBackground(Canvas canvas, double w, double h, double groundY) {
    // Ciel
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
            : [const Color(0xFF78909C), const Color(0xFFCFD8DC)],
      ).createShader(Rect.fromLTWH(0, 0, w, groundY));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, groundY), skyPaint);

    // Sous-sol rocheux
    final crustPaint = Paint()
      ..color = isDark ? const Color(0xFF33221C) : const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(0, groundY, w, h - groundY), crustPaint);
  }

  void _drawMagmaChamberAndConduit(Canvas canvas, double vx, double groundY, double h) {
    final chamberCenter = Offset(vx, h * 0.88);
    final chamberPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFEA00), const Color(0xFFFF3D00)],
      ).createShader(Rect.fromCircle(center: chamberCenter, radius: 45));
    canvas.drawCircle(chamberCenter, 45, chamberPaint);

    // Cheminée volcanique principale
    final conduitPath = Path()
      ..moveTo(vx - 8, groundY + 10)
      ..lineTo(vx - 8, chamberCenter.dy)
      ..lineTo(vx + 8, chamberCenter.dy)
      ..lineTo(vx + 8, groundY + 10)
      ..close();
    final conduitPaint = Paint()..color = const Color(0xFFFF5722);
    canvas.drawPath(conduitPath, conduitPaint);
  }

  // --- 1. Régime Hawaïen (Volcan bouclier, fontaines et coulées fluides) ---
  void _drawHawaiian(Canvas canvas, double w, double groundY, double vx) {
    final craterY = groundY - 60;

    // Volcan bouclier très étalé (pentes très douces 5-10°)
    final shield = Path()
      ..moveTo(vx - w * 0.45, groundY)
      ..cubicTo(vx - w * 0.25, groundY - 20, vx - 45, craterY + 5, vx - 22, craterY)
      ..lineTo(vx + 22, craterY)
      ..cubicTo(vx + 45, craterY + 5, vx + w * 0.25, groundY - 20, vx + w * 0.45, groundY)
      ..close();
    final shieldPaint = Paint()..color = const Color(0xFF3E2723);
    canvas.drawPath(shield, shieldPaint);

    // Fontaine de lave centrale (bulles de gaz qui propulsent la lave fluide à 20-50m)
    final fountainH = 30.0 + 45.0 * gasContent;
    for (int i = 0; i < 7; i++) {
      final t = (progress * 3.0 + i / 7.0) % 1.0;
      final fx = vx + sin(i * 1.8 + progress * 6) * 12;
      final fy = craterY - sin(t * pi) * fountainH;
      final dropPaint = Paint()..color = const Color(0xFFFFC107);
      canvas.drawCircle(Offset(fx, fy), 3.5, dropPaint);
    }

    // Coulées de lave fluide le long des deux flancs
    final lavaFlowPaint = Paint()
      ..color = const Color(0xFFFF3D00)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Coulée gauche
    final leftLava = Path()
      ..moveTo(vx - 18, craterY)
      ..cubicTo(vx - 100, craterY + 25, vx - w * 0.2, groundY - 15, vx - w * 0.35, groundY);
    canvas.drawPath(leftLava, lavaFlowPaint);

    // Coulée droite
    final rightLava = Path()
      ..moveTo(vx + 18, craterY)
      ..cubicTo(vx + 80, craterY + 20, vx + w * 0.25, groundY - 10, vx + w * 0.40, groundY);
    canvas.drawPath(rightLava, lavaFlowPaint);
  }

  // --- 2. Régime Fissural (Rideau de lave le long d'une fracture & Trapps) ---
  void _drawFissure(Canvas canvas, double w, double groundY, double vx) {
    // Grand plateau basaltique horizontal (Trapps)
    final plateau = Rect.fromLTWH(0, groundY - 25, w, 25);
    final plateauPaint = Paint()..color = const Color(0xFF263238);
    canvas.drawRect(plateau, plateauPaint);

    // Fissure linéaire ouverte
    final fissurePaint = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 6.0;
    canvas.drawLine(Offset(vx - 140, groundY - 25), Offset(vx + 140, groundY - 25), fissurePaint);

    // Rideau de fontaines de lave le long de la fissure
    final fountainH = 25.0 + 35.0 * gasContent;
    for (double x = vx - 120; x <= vx + 120; x += 30) {
      final offsetPhase = ((x - vx) / 40.0).abs();
      final t = (progress * 4.0 + offsetPhase) % 1.0;
      final fy = (groundY - 25) - sin(t * pi) * fountainH;

      final jetPaint = Paint()
        ..color = Color.lerp(const Color(0xFFFFD54F), const Color(0xFFFF3D00), t) ?? Colors.orange;
      canvas.drawCircle(Offset(x, fy), 4.0, jetPaint);

      // Jet vertical
      final lineJet = Paint()
        ..color = const Color(0xFFFF7043).withOpacity(0.7)
        ..strokeWidth = 3.0;
      canvas.drawLine(Offset(x, groundY - 25), Offset(x, fy), lineJet);
    }
  }

  // --- 3. Régime Strombolien (Cônes de scories, explosions rythmiques, bombes) ---
  void _drawStrombolian(Canvas canvas, double w, double groundY, double vx) {
    final craterY = groundY - 110;

    // Cône volcanique pentu (30-35°)
    final cone = Path()
      ..moveTo(vx - w * 0.32, groundY)
      ..lineTo(vx - 28, craterY)
      ..lineTo(vx + 28, craterY)
      ..lineTo(vx + w * 0.32, groundY)
      ..close();
    final conePaint = Paint()..color = const Color(0xFF424242);
    canvas.drawPath(cone, conePaint);

    // Cratère sommital égueulé
    final craterDip = Path()
      ..moveTo(vx - 28, craterY)
      ..lineTo(vx, craterY + 16)
      ..lineTo(vx + 28, craterY)
      ..close();
    canvas.drawPath(craterDip, Paint()..color = const Color(0xFF212121));

    // Explosions rythmiques et projections balistiques de bombes volcaniques
    final bombCount = 12;
    for (int i = 0; i < bombCount; i++) {
      final angle = -pi / 2 + ((i - (bombCount / 2)) * 0.16);
      final t = (progress * 2.5 + (i * 0.12)) % 1.0;
      final speed = 110.0 + (gasContent * 70.0);

      // Trajectoire parabolique sous gravité
      final bx = vx + cos(angle) * speed * t;
      final by = (craterY + 10) + sin(angle) * speed * t + (0.5 * 180.0 * t * t);

      if (by < groundY) {
        final bombPaint = Paint()..color = const Color(0xFFFF6D00);
        canvas.drawCircle(Offset(bx, by), 3.5, bombPaint);

        // Traînée incandescente
        final trailPaint = Paint()
          ..color = Colors.amber.withOpacity((1.0 - t).clamp(0.0, 1.0))
          ..strokeWidth = 1.5;
        canvas.drawLine(Offset(bx, by), Offset(bx - cos(angle) * 8, by - sin(angle) * 8), trailPaint);
      }
    }

    // Bouffée de gaz et cendres sombres
    final puffPaint = Paint()..color = Colors.grey.withOpacity(0.6);
    canvas.drawCircle(Offset(vx, craterY - 25), 18, puffPaint);
    canvas.drawCircle(Offset(vx - 10, craterY - 45), 24, puffPaint);
    canvas.drawCircle(Offset(vx + 12, craterY - 60), 30, puffPaint);
  }

  // --- 4. Régime Plinien (Cataclysmique, panache en pin parasol, nuées ardentes) ---
  void _drawPlinian(Canvas canvas, double w, double groundY, double vx) {
    final craterY = groundY - 140;

    // Grand stratovolcan massif
    final strato = Path()
      ..moveTo(vx - w * 0.38, groundY)
      ..cubicTo(vx - w * 0.22, groundY - 40, vx - 45, craterY + 20, vx - 30, craterY)
      ..lineTo(vx + 30, craterY)
      ..cubicTo(vx + 45, craterY + 20, vx + w * 0.22, groundY - 40, vx + w * 0.38, groundY)
      ..close();
    final stratoPaint = Paint()..color = const Color(0xFF37474F);
    canvas.drawPath(strato, stratoPaint);

    // Dôme de lave visqueuse / aiguille extrusive dans le cratère
    final dome = Path()
      ..moveTo(vx - 16, craterY)
      ..lineTo(vx - 8, craterY - 18)
      ..lineTo(vx + 8, craterY - 18)
      ..lineTo(vx + 16, craterY)
      ..close();
    canvas.drawPath(dome, Paint()..color = const Color(0xFF616161));

    // 1. Colonne plinienne convective s'élevant vers la haute atmosphère
    final colH = 180.0 + 60.0 * gasContent;
    final columnPath = Path()
      ..moveTo(vx - 18, craterY)
      ..lineTo(vx - 35, craterY - colH * 0.7)
      ..lineTo(vx + 35, craterY - colH * 0.7)
      ..lineTo(vx + 18, craterY)
      ..close();
    final colPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [const Color(0xFFD84315), const Color(0xFF616161), const Color(0xFF212121)],
      ).createShader(Rect.fromLTWH(vx - 35, craterY - colH, 70, colH));
    canvas.drawPath(columnPath, colPaint);

    // 2. Panache stratosphérique étalé en pin parasol (ombrelle plinienne)
    final umbrellaY = craterY - colH;
    final umbrellaW = 220.0 + 80.0 * gasContent;
    final umbrellaPaint = Paint()..color = const Color(0xFF303030).withOpacity(0.9);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(vx, umbrellaY), width: umbrellaW, height: 75),
      umbrellaPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(vx - 40, umbrellaY - 15), width: umbrellaW * 0.6, height: 60),
      Paint()..color = const Color(0xFF424242).withOpacity(0.85),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(vx + 45, umbrellaY - 12), width: umbrellaW * 0.65, height: 65),
      Paint()..color = const Color(0xFF212121).withOpacity(0.9),
    );

    // Éclairs d'électricité statique dans le panache
    _drawVolcanicLightning(canvas, vx, umbrellaY, colH);

    // 3. Nuée ardente dévalant les flancs (coulées pyroclastiques mortelles)
    _drawPyroclasticFlow(canvas, vx, craterY, groundY, w);
  }

  void _drawVolcanicLightning(Canvas canvas, double vx, double umbrellaY, double colH) {
    final boltPaint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = 2.0;

    final bolt = Path()
      ..moveTo(vx - 20, umbrellaY + 15)
      ..lineTo(vx - 35, umbrellaY + 45)
      ..lineTo(vx - 22, umbrellaY + 52)
      ..lineTo(vx - 40, umbrellaY + 80);
    canvas.drawPath(bolt, boltPaint);

    final bolt2 = Path()
      ..moveTo(vx + 25, umbrellaY + 20)
      ..lineTo(vx + 40, umbrellaY + 50)
      ..lineTo(vx + 30, umbrellaY + 58)
      ..lineTo(vx + 50, umbrellaY + 85);
    canvas.drawPath(bolt2, boltPaint);
  }

  void _drawPyroclasticFlow(Canvas canvas, double vx, double craterY, double groundY, double w) {
    final flowPaint = Paint()..color = const Color(0xFF4E342E).withOpacity(0.75);

    // Nuée sur le flanc gauche
    final leftFlow = Path()
      ..moveTo(vx - 25, craterY + 30)
      ..cubicTo(vx - 70, craterY + 70, vx - w * 0.20, groundY - 20, vx - w * 0.32, groundY)
      ..lineTo(vx - w * 0.32 - 40, groundY)
      ..cubicTo(vx - w * 0.20, groundY - 45, vx - 50, craterY + 40, vx - 25, craterY + 30)
      ..close();
    canvas.drawPath(leftFlow, flowPaint);

    // Tourbillons de gaz chaud
    final dustPaint = Paint()..color = const Color(0xFF6D4C41).withOpacity(0.65);
    canvas.drawCircle(Offset(vx - w * 0.22, groundY - 25), 18, dustPaint);
    canvas.drawCircle(Offset(vx - w * 0.28, groundY - 12), 24, dustPaint);
  }

  @override
  bool shouldRepaint(covariant VolcanoEruptionPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.progress != progress ||
        oldDelegate.viscosity != viscosity ||
        oldDelegate.gasContent != gasContent ||
        oldDelegate.isDark != isDark;
  }
}
