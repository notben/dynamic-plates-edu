import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/world_atlas/data/tectonic_plates_data.dart';
import 'package:dynamic_plates_edu/features/world_atlas/data/geological_sites_data.dart';

/// CustomPainter vectoriel 100% procédural de la carte mondiale des plaques tectoniques.
/// Affiche les continents, les frontières de plaques, les vecteurs de vitesse GPS et les 10 épingles géologiques.
class WorldMapVectorPainter extends CustomPainter {
  final String? selectedSiteId;
  final bool showPlates;
  final bool showVectors;
  final bool isDark;

  WorldMapVectorPainter({
    required this.selectedSiteId,
    required this.showPlates,
    required this.showVectors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Océans de fond
    final oceanPaint = Paint()
      ..color = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFE1F5FE);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), oceanPaint);

    // Grille de coordonnées (méridiens et parallèles discrets)
    _drawGraticule(canvas, w, h);

    // 2. Continents vectoriels procéduraux
    _drawContinents(canvas, w, h);

    // 3. Limites de plaques tectoniques
    if (showPlates) {
      _drawPlateBoundaries(canvas, w, h);
    }

    // 4. Vecteurs de vitesse (flèches GPS en cm/an)
    if (showVectors) {
      _drawVelocityVectors(canvas, w, h);
    }

    // 5. Les 10 Épingles des sites géologiques remarquables
    _drawSitePins(canvas, w, h);
  }

  void _drawGraticule(Canvas canvas, double w, double h) {
    final linePaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)
      ..strokeWidth = 1.0;

    // Équateur
    canvas.drawLine(Offset(0, h * 0.50), Offset(w, h * 0.50), linePaint);
    // Tropiques
    canvas.drawLine(Offset(0, h * 0.35), Offset(w, h * 0.35), linePaint);
    canvas.drawLine(Offset(0, h * 0.65), Offset(w, h * 0.65), linePaint);
    // Méridien de Greenwich
    canvas.drawLine(Offset(w * 0.48, 0), Offset(w * 0.48, h), linePaint);
  }

  void _drawContinents(Canvas canvas, double w, double h) {
    final landPaint = Paint()
      ..color = isDark ? const Color(0xFF1B2A38) : const Color(0xFFC8E6C9)
      ..style = PaintingStyle.fill;

    // Amérique du Nord
    final northAmerica = Path()
      ..moveTo(w * 0.08, h * 0.20)
      ..cubicTo(w * 0.15, h * 0.10, w * 0.35, h * 0.10, w * 0.38, h * 0.25)
      ..cubicTo(w * 0.32, h * 0.35, w * 0.26, h * 0.45, w * 0.22, h * 0.48) // Mexique / Amérique centrale
      ..cubicTo(w * 0.15, h * 0.45, w * 0.10, h * 0.38, w * 0.08, h * 0.20)
      ..close();
    canvas.drawPath(northAmerica, landPaint);

    // Amérique du Sud
    final southAmerica = Path()
      ..moveTo(w * 0.24, h * 0.48)
      ..cubicTo(w * 0.35, h * 0.48, w * 0.38, h * 0.62, w * 0.34, h * 0.72)
      ..cubicTo(w * 0.32, h * 0.82, w * 0.28, h * 0.90, w * 0.26, h * 0.92) // Patagonie
      ..cubicTo(w * 0.24, h * 0.75, w * 0.22, h * 0.60, w * 0.24, h * 0.48)
      ..close();
    canvas.drawPath(southAmerica, landPaint);

    // Groenland
    final greenland = Path()
      ..moveTo(w * 0.36, h * 0.10)
      ..lineTo(w * 0.44, h * 0.10)
      ..lineTo(w * 0.42, h * 0.22)
      ..lineTo(w * 0.37, h * 0.20)
      ..close();
    canvas.drawPath(greenland, landPaint);

    // Europe
    final europe = Path()
      ..moveTo(w * 0.44, h * 0.25)
      ..cubicTo(w * 0.48, h * 0.18, w * 0.58, h * 0.20, w * 0.58, h * 0.32)
      ..cubicTo(w * 0.52, h * 0.36, w * 0.46, h * 0.35, w * 0.44, h * 0.25)
      ..close();
    canvas.drawPath(europe, landPaint);

    // Asie
    final asia = Path()
      ..moveTo(w * 0.58, h * 0.20)
      ..cubicTo(w * 0.75, h * 0.15, w * 0.90, h * 0.18, w * 0.92, h * 0.35)
      ..cubicTo(w * 0.85, h * 0.48, w * 0.72, h * 0.52, w * 0.64, h * 0.42)
      ..cubicTo(w * 0.58, h * 0.32, w * 0.56, h * 0.25, w * 0.58, h * 0.20)
      ..close();
    canvas.drawPath(asia, landPaint);

    // Afrique
    final africa = Path()
      ..moveTo(w * 0.45, h * 0.36)
      ..cubicTo(w * 0.60, h * 0.34, w * 0.66, h * 0.45, w * 0.62, h * 0.60) // Corne & Est
      ..cubicTo(w * 0.58, h * 0.75, w * 0.54, h * 0.82, w * 0.52, h * 0.82) // Cap
      ..cubicTo(w * 0.44, h * 0.65, w * 0.42, h * 0.48, w * 0.45, h * 0.36)
      ..close();
    canvas.drawPath(africa, landPaint);

    // Australie
    final australia = Path()
      ..moveTo(w * 0.80, h * 0.65)
      ..lineTo(w * 0.92, h * 0.65)
      ..lineTo(w * 0.90, h * 0.82)
      ..lineTo(w * 0.78, h * 0.80)
      ..close();
    canvas.drawPath(australia, landPaint);

    // Antarctique (ruban austral)
    final antarctica = Path()
      ..moveTo(0, h * 0.96)
      ..lineTo(w, h * 0.96)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(antarctica, Paint()..color = isDark ? const Color(0xFF2C3E50) : const Color(0xFFE0E0E0));
  }

  void _drawPlateBoundaries(Canvas canvas, double w, double h) {
    for (final plate in TectonicPlatesData.plates) {
      if (plate.boundaryPoints.length < 2) continue;

      final path = Path();
      final p0 = plate.boundaryPoints.first;
      path.moveTo(p0.dx * w, p0.dy * h);

      for (int i = 1; i < plate.boundaryPoints.length; i++) {
        final pt = plate.boundaryPoints[i];
        path.lineTo(pt.dx * w, pt.dy * h);
      }
      path.close();

      // Frontière colorée en pointillés
      final borderPaint = Paint()
        ..color = plate.color.withOpacity(0.85)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);

      // Nom de la plaque
      final center = _calculateCentroid(plate.boundaryPoints, w, h);
      _renderText(
        canvas,
        plate.name,
        Offset(center.dx - 30, center.dy),
        plate.color,
        fontSize: 10,
      );
    }
  }

  Offset _calculateCentroid(List<Offset> points, double w, double h) {
    double sx = 0.0;
    double sy = 0.0;
    for (final p in points) {
      sx += p.dx * w;
      sy += p.dy * h;
    }
    return Offset(sx / points.length, sy / points.length);
  }

  void _drawVelocityVectors(Canvas canvas, double w, double h) {
    final arrowPaint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    // Vecteurs sélectionnés emblématiques
    _drawVector(canvas, w * 0.18, h * 0.55, -24, -14, '8.5 cm/an', arrowPaint); // Pacifique
    _drawVector(canvas, w * 0.28, h * 0.65, 20, 0, '7.7 cm/an', arrowPaint); // Nazca -> Andes
    _drawVector(canvas, w * 0.34, h * 0.68, -12, 0, '1.8 cm/an', arrowPaint); // Amérique du Sud
    _drawVector(canvas, w * 0.52, h * 0.55, 6, -10, '2.2 cm/an', arrowPaint); // Afrique
    _drawVector(canvas, w * 0.74, h * 0.44, 4, -20, '6.2 cm/an', arrowPaint); // Inde -> Asie
    _drawVector(canvas, w * 0.85, h * 0.72, 8, -16, '6.5 cm/an', arrowPaint); // Australie
  }

  void _drawVector(Canvas canvas, double x, double y, double dx, double dy, String label, Paint paint) {
    canvas.drawLine(Offset(x, y), Offset(x + dx, y + dy), paint);

    // Tête de flèche
    final angle = atan2(dy, dx);
    canvas.drawLine(
      Offset(x + dx, y + dy),
      Offset(x + dx - 6 * cos(angle - pi / 6), y + dy - 6 * sin(angle - pi / 6)),
      paint,
    );
    canvas.drawLine(
      Offset(x + dx, y + dy),
      Offset(x + dx - 6 * cos(angle + pi / 6), y + dy - 6 * sin(angle + pi / 6)),
      paint,
    );

    // Label vitesse
    _renderText(canvas, label, Offset(x + dx + 4, y + dy - 6), Colors.amberAccent, fontSize: 9);
  }

  void _drawSitePins(Canvas canvas, double w, double h) {
    for (final site in GeologicalSitesData.sites) {
      final px = site.mapPosition.dx * w;
      final py = site.mapPosition.dy * h;
      final isSelected = site.id == selectedSiteId;

      if (isSelected) {
        // Halo pulsant autour du site sélectionné
        final haloPaint = Paint()
          ..color = Colors.orangeAccent.withOpacity(0.4)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(px, py), 16, haloPaint);
      }

      // Épingle
      final pinPaint = Paint()
        ..color = isSelected ? Colors.orangeAccent : const Color(0xFFE53935)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(px, py), isSelected ? 8.0 : 6.0, pinPaint);

      final centerDot = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(px, py), isSelected ? 3.5 : 2.2, centerDot);
    }
  }

  void _renderText(Canvas canvas, String text, Offset offset, Color color, {double fontSize = 11}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withOpacity(0.55),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant WorldMapVectorPainter oldDelegate) {
    return oldDelegate.selectedSiteId != selectedSiteId ||
        oldDelegate.showPlates != showPlates ||
        oldDelegate.showVectors != showVectors ||
        oldDelegate.isDark != isDark;
  }
}
