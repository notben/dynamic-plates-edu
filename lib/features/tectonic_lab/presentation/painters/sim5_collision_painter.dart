import 'package:flutter/material.dart';

/// Simulation 5 : Convergence Continent / Continent (Collision & Orogenèse)
/// Exemples géologiques : Formation des Alpes (collision Europe - Afrique/Apulie) et de l'Himalaya (Inde - Eurasie).
/// Phénomènes modélisés :
/// - Fermeture du bassin océanique (Téthys) avec suture ophiolitique
/// - Épaississement crustal (crustal thickening)
/// - Surrection de hauts sommets (orogenèse)
/// - Enfoncement d'une profonde racine crustale (Moho plongeant à 50-60 km)
/// - Nappes de charriage et failles inverses de chevauchement
class Sim5CollisionPainter extends CustomPainter {
  final double progress;
  final bool showLegends;
  final bool isDark;

  Sim5CollisionPainter({
    required this.progress,
    required this.showLegends,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final baseGroundY = h * 0.40;
    final collisionCenter = w * 0.50;

    // Amplitude de surrection de la chaîne (vers le haut)
    final mountainHeight = 15.0 + 85.0 * progress;
    // Amplitude d'enfoncement de la racine crustale (vers le bas)
    final rootDepth = 20.0 + 90.0 * progress;

    // 1. Asthénosphère sous-jacente
    final mantleRect = Rect.fromLTWH(0, baseGroundY + 40, w, h - (baseGroundY + 40));
    final mantlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF7E2A0C), const Color(0xFFC83803), const Color(0xFFFF5722)]
            : [const Color(0xFF8D4004), const Color(0xFFE65100), const Color(0xFFFF7043)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(mantleRect);
    canvas.drawRect(mantleRect, mantlePaint);

    // 2. Croûte continentale déformée et épaissie (Roche granitique/métamorphique)
    // Relief de surface plissé
    final surfacePath = Path()..moveTo(0, baseGroundY);

    // Bloc gauche (ex. plaque européenne)
    final leftSlopeX = collisionCenter - 180 + 50 * (1 - progress);
    surfacePath.lineTo(leftSlopeX, baseGroundY);

    // Sommets de la chaîne plissée (pics rocheux)
    surfacePath.lineTo(collisionCenter - 110, baseGroundY - mountainHeight * 0.45);
    surfacePath.lineTo(collisionCenter - 70, baseGroundY - mountainHeight * 0.85); // Pic 1
    surfacePath.lineTo(collisionCenter - 40, baseGroundY - mountainHeight * 0.65);
    surfacePath.lineTo(collisionCenter, baseGroundY - mountainHeight); // Sommet principal (ex. Mont-Blanc)
    surfacePath.lineTo(collisionCenter + 45, baseGroundY - mountainHeight * 0.75);
    surfacePath.lineTo(collisionCenter + 90, baseGroundY - mountainHeight * 0.55); // Pic 2

    final rightSlopeX = collisionCenter + 180 - 50 * (1 - progress);
    surfacePath.lineTo(rightSlopeX, baseGroundY);
    surfacePath.lineTo(w, baseGroundY);

    // Base de la croûte (Moho) avec racine crustale profonde au centre
    surfacePath.lineTo(w, baseGroundY + 65);
    surfacePath.lineTo(rightSlopeX, baseGroundY + 65);
    surfacePath.cubicTo(
      collisionCenter + 100, baseGroundY + 65 + rootDepth * 0.5,
      collisionCenter + 50, baseGroundY + 65 + rootDepth,
      collisionCenter, baseGroundY + 65 + rootDepth,
    );
    surfacePath.cubicTo(
      collisionCenter - 50, baseGroundY + 65 + rootDepth,
      collisionCenter - 100, baseGroundY + 65 + rootDepth * 0.5,
      leftSlopeX, baseGroundY + 65,
    );
    surfacePath.lineTo(0, baseGroundY + 65);
    surfacePath.close();

    final crustPaint = Paint()
      ..color = isDark ? const Color(0xFF5D4037) : const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawPath(surfacePath, crustPaint);

    // 3. Nappes de charriage et failles de chevauchement (lignes de plis)
    _drawThrustNappes(canvas, collisionCenter, baseGroundY, mountainHeight, progress);

    // 4. Suture ophiolitique (vestige de l'ancien plancher océanique pincé)
    _drawOphioliteSuture(canvas, collisionCenter, baseGroundY, mountainHeight, rootDepth);

    // 5. Sommets enneigés éternels
    _drawGlaciers(canvas, collisionCenter, baseGroundY, mountainHeight);

    // 6. Flèches de compression continentale
    _drawCompressionArrows(canvas, w, baseGroundY);

    // 7. Légendes
    if (showLegends) {
      _drawLabels(canvas, w, h, collisionCenter, baseGroundY, mountainHeight, rootDepth);
    }
  }

  void _drawThrustNappes(Canvas canvas, double cx, double groundY, double mHeight, double prog) {
    final nappePaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Failles inverses de chevauchement empilées vers le nord/nord-ouest
    final p1 = Path()
      ..moveTo(cx + 80, groundY + 40)
      ..cubicTo(cx + 20, groundY + 10, cx - 20, groundY - mHeight * 0.4, cx - 80, groundY - mHeight * 0.3);
    canvas.drawPath(p1, nappePaint);

    final p2 = Path()
      ..moveTo(cx + 40, groundY + 50)
      ..cubicTo(cx - 10, groundY + 20, cx - 40, groundY - mHeight * 0.6, cx - 110, groundY - mHeight * 0.5);
    canvas.drawPath(p2, nappePaint);

    final p3 = Path()
      ..moveTo(cx - 70, groundY + 45)
      ..cubicTo(cx - 30, groundY + 15, cx + 10, groundY - mHeight * 0.5, cx + 60, groundY - mHeight * 0.4);
    canvas.drawPath(p3, nappePaint);
  }

  void _drawOphioliteSuture(Canvas canvas, double cx, double groundY, double mHeight, double rDepth) {
    // Bande étroite verte/sombre d'ophiolites (péridotites et basaltes métamorphisés)
    final ophiolitePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final suture = Path()
      ..moveTo(cx - 15, groundY - mHeight * 0.8)
      ..cubicTo(cx - 5, groundY - 10, cx + 15, groundY + 30, cx + 5, groundY + 65 + rDepth * 0.7);
    canvas.drawPath(suture, ophiolitePaint);
  }

  void _drawGlaciers(Canvas canvas, double cx, double groundY, double mHeight) {
    if (mHeight < 40) return;
    final snowPaint = Paint()..color = Colors.white;

    // Pic principal
    final snowPeak = Path()
      ..moveTo(cx - 20, groundY - mHeight + 18)
      ..lineTo(cx, groundY - mHeight)
      ..lineTo(cx + 20, groundY - mHeight + 18)
      ..lineTo(cx + 8, groundY - mHeight + 22)
      ..lineTo(cx - 8, groundY - mHeight + 20)
      ..close();
    canvas.drawPath(snowPeak, snowPaint);

    // Pic gauche
    final snowLeft = Path()
      ..moveTo(cx - 85, groundY - mHeight * 0.85 + 14)
      ..lineTo(cx - 70, groundY - mHeight * 0.85)
      ..lineTo(cx - 55, groundY - mHeight * 0.85 + 14)
      ..close();
    canvas.drawPath(snowLeft, snowPaint);
  }

  void _drawCompressionArrows(Canvas canvas, double w, double groundY) {
    final arrowPaint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    // Flèche gauche vers la droite ->
    canvas.drawLine(Offset(40, groundY - 15), Offset(100, groundY - 15), arrowPaint);
    canvas.drawLine(Offset(100, groundY - 15), Offset(90, groundY - 22), arrowPaint);
    canvas.drawLine(Offset(100, groundY - 15), Offset(90, groundY - 8), arrowPaint);

    // Flèche droite vers la gauche <-
    canvas.drawLine(Offset(w - 40, groundY - 15), Offset(w - 100, groundY - 15), arrowPaint);
    canvas.drawLine(Offset(w - 100, groundY - 15), Offset(w - 90, groundY - 22), arrowPaint);
    canvas.drawLine(Offset(w - 100, groundY - 15), Offset(w - 90, groundY - 8), arrowPaint);
  }

  void _drawLabels(Canvas canvas, double w, double h, double cx, double groundY, double mHeight, double rDepth) {
    _renderText(canvas, 'Croûte continentale (Eurasie)', Offset(30, groundY + 25), Colors.white);
    _renderText(canvas, 'Croûte continentale (Afrique/Apulie)', Offset(w - 240, groundY + 25), Colors.white);
    _renderText(canvas, 'Chaîne de collision (Alpes / Mont-Blanc)', Offset(cx - 120, groundY - mHeight - 25), Colors.amberAccent);
    _renderText(canvas, 'Nappes de charriage & plis', Offset(cx + 80, groundY - mHeight * 0.45), Colors.lightGreenAccent);
    _renderText(canvas, 'Suture ophiolitique (ancienne Téthys)', Offset(cx - 130, groundY + 15), const Color(0xFF81C784));
    _renderText(canvas, 'Racine crustale profonde (Moho ~60 km)', Offset(cx - 120, groundY + 75 + rDepth), Colors.orangeAccent);
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
  bool shouldRepaint(covariant Sim5CollisionPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLegends != showLegends ||
        oldDelegate.isDark != isDark;
  }
}
