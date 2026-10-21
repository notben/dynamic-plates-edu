import 'dart:math';
import 'package:flutter/material.dart';

/// CustomPainter pour le simulateur de propagation d'ondes sismiques (P, S et Surface).
/// Affiche la coupe géologique, le foyer (hypocentre), l'épicentre et les secousses en surface.
class EarthquakeWavesPainter extends CustomPainter {
  final double depthKm; // 10 km à 300 km
  final double magnitude; // 3.0 à 9.0
  final double waveProgress; // 0.0 à 1.0 (onde s'élargissant)
  final bool isDark;

  EarthquakeWavesPainter({
    required this.depthKm,
    required this.magnitude,
    required this.waveProgress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final surfaceY = h * 0.28;
    final maxDepthPixels = h * 0.65;

    // Position de l'hypocentre (foyer)
    final hypocenterX = w * 0.45;
    // Mise à l'échelle de la profondeur (10 km -> surfaceY + 20, 300 km -> surfaceY + maxDepthPixels)
    final depthNormalized = (depthKm - 10) / (300 - 10);
    final hypocenterY = surfaceY + 25 + (maxDepthPixels - 25) * depthNormalized;
    final hypocenter = Offset(hypocenterX, hypocenterY);

    // Épicentre (projection directe à la verticale en surface)
    final epicenter = Offset(hypocenterX, surfaceY);

    // 1. Fond du sous-sol géologique
    _drawGeologicalLayers(canvas, w, h, surfaceY);

    // 2. Ondes sismiques concentriques depuis l'hypocentre
    _drawSeismicWavefronts(canvas, hypocenter, surfaceY, w, h);

    // 3. Foyer (Hypocentre)
    _drawHypocenter(canvas, hypocenter);

    // 4. Épicentre à la surface
    _drawEpicenter(canvas, epicenter);

    // 5. Bâtiments en surface et secousses proportionnelles à la magnitude
    _drawSurfaceBuildings(canvas, w, surfaceY, epicenter);

    // 6. Trace sismographique simulée en incrustation
    _drawSeismographHUD(canvas, w, h);
  }

  void _drawGeologicalLayers(Canvas canvas, double w, double h, double surfaceY) {
    // Ciel
    final skyPaint = Paint()
      ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFCFD8DC);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, surfaceY), skyPaint);

    // Croûte terrestre (0 à 35 km)
    final crustY = surfaceY + 45;
    final crustPaint = Paint()
      ..color = isDark ? const Color(0xFF4E342E) : const Color(0xFF795548);
    canvas.drawRect(Rect.fromLTWH(0, surfaceY, w, crustY - surfaceY), crustPaint);

    // Manteau supérieur
    final mantlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF5D1D04), const Color(0xFF8B2500)]
            : [const Color(0xFF8D4004), const Color(0xFFD84315)],
      ).createShader(Rect.fromLTWH(0, crustY, w, h - crustY));
    canvas.drawRect(Rect.fromLTWH(0, crustY, w, h - crustY), mantlePaint);

    // Ligne du Moho
    final mohoPaint = Paint()
      ..color = Colors.amber.withOpacity(0.5)
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, crustY), Offset(w, crustY), mohoPaint);
  }

  void _drawSeismicWavefronts(Canvas canvas, Offset hypo, double surfY, double w, double h) {
    final maxDist = w * 0.85;

    // Amplitude relative basée sur l'échelle de Richter/Moment (échelle log)
    final energyFactor = ((magnitude - 3.0) / 6.0).clamp(0.1, 1.0);

    // 1. Ondes P (Compression - les plus rapides Vp ~ 6-8 km/s)
    final pRadius = maxDist * waveProgress;
    for (int i = 0; i < 4; i++) {
      final r = pRadius - (i * 24);
      if (r > 0) {
        final alpha = (1.0 - (r / maxDist)).clamp(0.0, 1.0) * energyFactor;
        final pPaint = Paint()
          ..color = Colors.yellowAccent.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
        canvas.drawCircle(hypo, r, pPaint);
      }
    }

    // 2. Ondes S (Cisaillement - plus lentes Vs ~ 3.5-4.5 km/s)
    final sRadius = maxDist * (waveProgress * 0.62);
    for (int i = 0; i < 3; i++) {
      final r = sRadius - (i * 28);
      if (r > 0) {
        final alpha = (1.0 - (r / maxDist)).clamp(0.0, 1.0) * energyFactor;
        final sPaint = Paint()
          ..color = Colors.deepOrangeAccent.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5;
        canvas.drawCircle(hypo, r, sPaint);
      }
    }

    // 3. Ondes de Surface (Rayleigh & Love : naissent à l'épicentre et longent la surface)
    final distToSurface = (hypo.dy - surfY).abs();
    if (pRadius >= distToSurface) {
      final surfRadius = (pRadius - distToSurface) * 0.8;
      final surfAlpha = (1.0 - (surfRadius / maxDist)).clamp(0.0, 1.0) * energyFactor;

      final surfPaint = Paint()
        ..color = Colors.redAccent.withOpacity(surfAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5;

      // Onde de surface vers la gauche
      if (hypo.dx - surfRadius > 0) {
        canvas.drawCircle(Offset(hypo.dx - surfRadius, surfY), 8 + energyFactor * 8, surfPaint);
      }
      // Onde de surface vers la droite
      if (hypo.dx + surfRadius < w) {
        canvas.drawCircle(Offset(hypo.dx + surfRadius, surfY), 8 + energyFactor * 8, surfPaint);
      }
    }
  }

  void _drawHypocenter(Canvas canvas, Offset hypo) {
    // Étoile incandescente au foyer
    final starPaint = Paint()..color = Colors.redAccent;
    canvas.drawCircle(hypo, 8.0, starPaint);
    canvas.drawCircle(hypo, 14.0, Paint()..color = Colors.amber.withOpacity(0.4));
  }

  void _drawEpicenter(Canvas canvas, Offset epi) {
    // Cible en surface
    final epiPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(epi, 10, epiPaint);
    canvas.drawLine(Offset(epi.dx - 14, epi.dy), Offset(epi.dx + 14, epi.dy), epiPaint);
    canvas.drawLine(Offset(epi.dx, epi.dy - 14), Offset(epi.dx, epi.dy + 14), epiPaint);
  }

  void _drawSurfaceBuildings(Canvas canvas, double w, double surfY, Offset epi) {
    final buildings = [
      _Building(x: epi.dx - 120, height: 35, width: 22, name: 'Maison'),
      _Building(x: epi.dx - 45, height: 55, width: 28, name: 'École'),
      _Building(x: epi.dx + 40, height: 75, width: 32, name: 'Immeuble'),
      _Building(x: epi.dx + 130, height: 45, width: 25, name: 'Tour'),
    ];

    // Secousse vibratoire active selon la magnitude et le passage des ondes
    final isShaking = waveProgress > 0.15 && waveProgress < 0.85;
    final shakeIntensity = isShaking ? ((magnitude - 3.0) / 6.0) * 8.0 : 0.0;

    for (int i = 0; i < buildings.length; i++) {
      final b = buildings[i];
      final currentShake = sin(waveProgress * 40 + i * 2.0) * shakeIntensity;

      final bRect = Rect.fromLTWH(
        b.x + currentShake,
        surfY - b.height,
        b.width,
        b.height,
      );

      final isDamaged = magnitude >= 7.5 && isShaking;
      final bPaint = Paint()
        ..color = isDamaged ? const Color(0xFFE53935) : const Color(0xFF78909C);
      canvas.drawRect(bRect, bPaint);

      // Fenêtres
      final winPaint = Paint()..color = Colors.yellowAccent;
      for (double wy = surfY - b.height + 8; wy < surfY - 8; wy += 14) {
        canvas.drawRect(Rect.fromLTWH(b.x + currentShake + 4, wy, 5, 6), winPaint);
        canvas.drawRect(Rect.fromLTWH(b.x + currentShake + b.width - 9, wy, 5, 6), winPaint);
      }

      // Fissures en cas de très fort séisme (Mag >= 8.0)
      if (magnitude >= 8.0) {
        final crackPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2.0;
        canvas.drawLine(
          Offset(b.x + currentShake + 5, surfY - b.height * 0.7),
          Offset(b.x + currentShake + 16, surfY - b.height * 0.2),
          crackPaint,
        );
      }
    }
  }

  void _drawSeismographHUD(Canvas canvas, double w, double h) {
    final hudRect = Rect.fromLTWH(16, h - 70, w - 32, 55);
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.65);
    canvas.drawRRect(RRect.fromRectAndRadius(hudRect, const Radius.circular(8)), bgPaint);

    // Tracé de l'onde sismographique
    final tracePath = Path();
    final startX = 26.0;
    final endX = w - 26.0;
    final midY = h - 42;

    tracePath.moveTo(startX, midY);
    for (double x = startX; x < endX; x += 4) {
      final t = (x - startX) / (endX - startX);
      double yVal = 0.0;
      if (t > 0.2 && t < 0.4) {
        // Ondes P (faible amplitude haute fréquence)
        yVal = sin(t * 80) * 4.0 * (magnitude / 9.0);
      } else if (t >= 0.4 && t < 0.65) {
        // Ondes S (amplitude moyenne)
        yVal = sin(t * 50) * 10.0 * (magnitude / 9.0);
      } else if (t >= 0.65 && t < 0.95) {
        // Ondes de Surface (très grande amplitude)
        yVal = sin(t * 30) * 22.0 * (magnitude / 9.0);
      }
      tracePath.lineTo(x, midY + yVal);
    }

    final tracePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawPath(tracePath, tracePaint);

    final tp = TextPainter(
      text: const TextSpan(
        text: 'Sismogramme (Onde P ➔ Onde S ➔ Ondes de Surface destructrices)',
        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(26, h - 68));
  }

  @override
  bool shouldRepaint(covariant EarthquakeWavesPainter oldDelegate) {
    return oldDelegate.depthKm != depthKm ||
        oldDelegate.magnitude != magnitude ||
        oldDelegate.waveProgress != waveProgress ||
        oldDelegate.isDark != isDark;
  }
}

class _Building {
  final double x;
  final double height;
  final double width;
  final String name;

  _Building({required this.x, required this.height, required this.width, required this.name});
}
