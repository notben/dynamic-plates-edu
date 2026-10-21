import 'package:flutter/material.dart';

/// CustomPainter procédural animant la dislocation de la Pangée d'Alfred Wegener :
/// - 250 Ma (Pangée réunie au Permien avec zones de fossiles Mesosaurus / Glossopteris)
/// - 200 Ma (Ouverture de la Téthys entre Laurasie et Gondwana)
/// - 140 Ma (Ouverture de l'océan Atlantique)
/// - 65 Ma (Remontée rapide de l'Inde)
/// - 0 Ma (Disposition géographique actuelle)
class PangeaDriftPainter extends CustomPainter {
  final double progress; // 0.0 = 250 Ma (Pangée) -> 1.0 = 0 Ma (Actuel)
  final bool showFossils;
  final bool isDark;

  PangeaDriftPainter({
    required this.progress,
    required this.showFossils,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Fond océan Panthalassa
    final oceanPaint = Paint()
      ..color = isDark ? const Color(0xFF0F1E2E) : const Color(0xFFE0F2F1);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), oceanPaint);

    final cx = w * 0.50;
    final cy = h * 0.50;

    // Déplacements d'éloignement des continents à partir de leur position initiale groupée (Pangée)
    // 1. Amérique du Sud (se sépare de l'Afrique vers l'ouest)
    final saDx = -w * 0.22 * progress;
    final saDy = h * 0.12 * progress;
    _drawContinentBlock(
      canvas,
      Offset(cx - 35 + saDx, cy + 25 + saDy),
      55,
      75,
      const Color(0xFF8D6E63),
      'Amérique du Sud',
    );

    // 2. Afrique (au centre de la Pangée, bouge très peu)
    final afDx = w * 0.02 * progress;
    final afDy = h * 0.04 * progress;
    _drawContinentBlock(
      canvas,
      Offset(cx + 25 + afDx, cy + 15 + afDy),
      65,
      85,
      const Color(0xFF7B1FA2),
      'Afrique',
    );

    // 3. Amérique du Nord (se détache de l'Europe vers l'ouest-nord-ouest)
    final naDx = -w * 0.28 * progress;
    final naDy = -h * 0.15 * progress;
    _drawContinentBlock(
      canvas,
      Offset(cx - 45 + naDx, cy - 55 + naDy),
      75,
      60,
      const Color(0xFF388E3C),
      'Amérique du Nord',
    );

    // 4. Eurasie (se déplace légèrement vers le nord-est)
    final euDx = w * 0.18 * progress;
    final euDy = -h * 0.12 * progress;
    _drawContinentBlock(
      canvas,
      Offset(cx + 40 + euDx, cy - 65 + euDy),
      95,
      70,
      const Color(0xFFF57C00),
      'Eurasie',
    );

    // 5. Inde (se détache de Madagascar/Antarctique et fonce à grande vitesse vers le nord !)
    final inDx = w * 0.15 * progress;
    final inDy = -h * 0.35 * progress; // Remontée spectaculaire vers l'Eurasie
    _drawContinentBlock(
      canvas,
      Offset(cx + 60 + inDx, cy + 75 + inDy),
      28,
      32,
      Colors.pinkAccent,
      'Inde',
    );

    // 6. Antarctique & Australie (descendent au sud puis l'Australie remonte)
    final auDx = w * 0.28 * progress;
    final auDy = h * 0.18 * progress;
    _drawContinentBlock(
      canvas,
      Offset(cx + 40 + auDx, cy + 85 + auDy),
      50,
      40,
      Colors.teal,
      'Australie',
    );

    // Tracé des fossiles de Wegener (Mesosaurus et Glossopteris reliant Afrique et Amérique du Sud)
    if (showFossils && progress < 0.45) {
      _drawWegenerFossils(canvas, cx + saDx, cy + saDy, cx + afDx, cy + afDy);
    }

    // Échelle d'âge géologique
    final currentAgeMa = (250 * (1.0 - progress)).toInt();
    _renderHUD(canvas, w, h, currentAgeMa);
  }

  void _drawContinentBlock(Canvas canvas, Offset pos, double w, double h, Color color, String name) {
    final rect = Rect.fromCenter(center: pos, width: w, height: h);
    final paint = Paint()
      ..color = color.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(14)), paint);

    final border = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(14)), border);

    final tp = TextPainter(
      text: TextSpan(
        text: name,
        style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width * 0.5, pos.dy - tp.height * 0.5));
  }

  void _drawWegenerFossils(Canvas canvas, double saX, double saY, double afX, double afY) {
    // Bande de fossiles du reptile Mesosaurus traversant l'Afrique du Sud et le Brésil
    final fossilPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.8)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final p1 = Offset(saX + 5, saY + 20);
    final p2 = Offset(afX - 5, afY + 20);
    canvas.drawLine(p1, p2, fossilPaint);

    final tp = TextPainter(
      text: const TextSpan(
        text: '★ Preuve : Fossiles identiques de Mesosaurus (Permien)',
        style: TextStyle(color: Colors.yellowAccent, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(p1.dx - 40, p1.dy + 8));
  }

  void _renderHUD(Canvas canvas, double w, double h, int ageMa) {
    String eraName;
    if (ageMa > 240) {
      eraName = 'Fin du Permien : Pangée unifiée';
    } else if (ageMa > 180) {
      eraName = 'Trias : Rupture Laurasie / Gondwana';
    } else if (ageMa > 120) {
      eraName = 'Jurassique : Ouverture Atlantique';
    } else if (ageMa > 50) {
      eraName = 'Crétacé : Dérive rapide de l\'Inde';
    } else {
      eraName = 'Époque actuelle (0 Ma)';
    }

    final tp = TextPainter(
      text: TextSpan(
        text: 'Il y a $ageMa Ma — $eraName',
        style: const TextStyle(
          color: Colors.amberAccent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black54,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(16, h - 30));
  }

  @override
  bool shouldRepaint(covariant PangeaDriftPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showFossils != showFossils ||
        oldDelegate.isDark != isDark;
  }
}
