# Skill : Moteur de Rendu Vectoriel Géologique (Flutter CustomPainter & Canvas)

Ce document définit les standards techniques et algorithmiques pour le moteur de rendu procédural de **Dynamic Plates Edu**. L'objectif est d'atteindre 60 à 120 FPS constants sans vidéo pré-rendue, via des déformations géologiques vectorielles en temps réel pilotées par un paramètre `progress` $\in [0.0, 1.0]$.

---

## 1. Systèmes de Coordonnées et Espace Normalisé
Toutes les scènes géologiques doivent s'adapter aux écrans smartphones (format portrait/paysage) et tablettes (iPad).
- **Zone de dessin normalisée** : Définir la géométrie sur un repère logique $[0.0, 1.0] \times [0.0, 1.0]$.
- **Mise à l'échelle** :
  ```dart
  final double w = size.width;
  final double h = size.height;
  Offset toScreen(double nx, double ny) => Offset(nx * w, ny * h);
  ```

---

## 2. Déformation des Couches Géologiques (Courbes de Bézier)

### A. Subduction Océanique (Plaque plongeante)
La plaque océanique rigide s'incurve et plonge sous la plaque chevauchante au niveau de la fosse océanique ($X_{fosse}$).
- **Courbe cubique de Bézier (`cubicTo`)** :
  ```dart
  final path = Path();
  final trenchX = w * (0.45 - 0.05 * progress);
  final slabDepth = h * (0.45 + 0.40 * progress);
  final slabTipX = trenchX + w * (0.25 * progress);

  path.moveTo(0, h * 0.35); // Surface océanique
  path.lineTo(trenchX, h * 0.38); // Fosse
  // Inflexion du slab plongeant
  path.cubicTo(
    trenchX + w * 0.08, h * 0.42, 
    slabTipX - w * 0.05, slabDepth * 0.8, 
    slabTipX, slabDepth,
  );
  ```

### B. Collision Continentale et Orogénèse Alpine (Plissement)
Lors de la fermeture océanique, la croûte continentale s'épaissit en formant des plis et des nappes de charriage :
- **Fonction de pli synclinal / anticlinal paramétrée** :
  ```dart
  Path buildFoldedCrust(double startX, double endX, double baselineY, double foldIntensity) {
    final path = Path();
    path.moveTo(startX, baselineY);
    final count = 4;
    final step = (endX - startX) / count;
    for (int i = 0; i < count; i++) {
      final x1 = startX + step * (i + 0.5);
      final x2 = startX + step * (i + 1.0);
      final sign = (i % 2 == 0) ? -1.0 : 0.7;
      final crestY = baselineY + sign * foldIntensity * (1.0 - (i / count));
      path.quadraticBezierTo(x1, crestY, x2, baselineY);
    }
    return path;
  }
  ```

---

## 3. Dégradés Thermiques du Manteau et Shaders

Le gradient thermique de la Terre (de 0°C en surface à >1300°C dans l'asthénosphère) est modélisé par des dégradés verticaux et des lentilles magmatiques :
```dart
final Paint mantlePaint = Paint()
  ..shader = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [
      Color(0xFF8B2500), // Lithosphère mantellique froide
      Color(0xFFCD3700), // Asthénosphère convective
      Color(0xFFFF4500), // Manteau profond
    ],
    stops: const [0.0, 0.45, 1.0],
  ).createShader(Rect.fromLTWH(0, h * 0.3, w, h * 0.7));
```

---

## 4. Vecteurs et Lignes de Champ de Convection

La convection mantellique circulaire sous les plaques est représentée par des cellules convectives vectorielles :
- **Courbes elliptiques fermées avec flèches tangentielles animées** :
  - La position de la tête de flèche est calculée par :
    $$\theta(t) = \theta_0 + 2\pi \cdot (\text{progress} \times 2.0 \pmod 1)$$
    $$x(t) = C_x + R_x \cos(\theta), \quad y(t) = C_y + R_y \sin(\theta)$$
  - L'orientation de la flèche s'aligne sur le vecteur tangent $\vec{T} = (-R_x \sin(\theta), R_y \cos(\theta))$.

---

## 5. Système de Particules Volcaniques Procédural

Pour simuler le panache volcanique et les éjections pyroclastiques sans allocations mémoire répétées :
- **Pool de particules pré-alloué (`Float32List`)** :
  ```dart
  class VolcanicPlume {
    final int particleCount = 60;
    late final Float32List x;
    late final Float32List y;
    late final Float32List life;
    late final Float32List speed;

    void update(double dt) {
      for (int i = 0; i < particleCount; i++) {
        life[i] += dt;
        if (life[i] >= 1.0) {
          x[i] = ventX + (rng() - 0.5) * 8.0;
          y[i] = ventY;
          life[i] = 0.0;
        } else {
          y[i] -= speed[i] * dt * 40.0;
          x[i] += (rng() - 0.5) * 15.0 * life[i]; // Dispersion avec l'altitude
        }
      }
    }

    void render(Canvas canvas, Paint paint) {
      for (int i = 0; i < particleCount; i++) {
        final alpha = (1.0 - life[i]).clamp(0.0, 1.0);
        paint.color = Color.fromRGBO(80, 80, 80, alpha * 0.7);
        final radius = 2.0 + life[i] * 6.0;
        canvas.drawCircle(Offset(x[i], y[i]), radius, paint);
      }
    }
  }
  ```

---

## 6. Ondes Sismiques Concentriques (Ondes P et S)

Lors d'un séisme généré par rupture le long du plan de Bénioff ou d'une faille transformante :
- **Foyer (Hypocentre)** : Point d'origine $(X_h, Y_h)$ en profondeur.
- **Ondes P (Compression)** : Rapides, cercles concentriques resserrés à trait continu.
- **Ondes S (Cisaillement)** : Plus lentes ($V_s \approx 0.6 \, V_p$), cercles tiretés ou déphasés.
- **Atténuation d'amplitude** :
  $$A(r) = A_0 \cdot \exp\left(-\frac{r}{R_{\max}}\right) \cdot \left(1 - \frac{r}{R_{\max}}\right)$$

```dart
void drawSeismicWaves(Canvas canvas, Offset hypocenter, double waveProgress, Size size) {
  final maxRadius = size.width * 0.6;
  final pWaveRadius = maxRadius * waveProgress;
  final sWaveRadius = maxRadius * (waveProgress * 0.62);

  final Paint pWavePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..color = Colors.amberAccent.withOpacity((1.0 - waveProgress).clamp(0.0, 1.0));

  final Paint sWavePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.5
    ..color = Colors.deepOrangeAccent.withOpacity((1.0 - waveProgress * 0.62).clamp(0.0, 1.0));

  canvas.drawCircle(hypocenter, pWaveRadius, pWavePaint);
  if (sWaveRadius > 0) {
    canvas.drawCircle(hypocenter, sWaveRadius, sWavePaint);
  }
}
```

---

## 7. Directives d'Optimisation 60/120 FPS
1. **Éviter `new Paint()` dans `paint()`** : Conserver les instances de `Paint` dans les champs du `CustomPainter` ou dans une classe d'état.
2. **Implémenter `shouldRepaint` rigoureusement** :
   ```dart
   @override
   bool shouldRepaint(covariant GeologicalSimulationPainter oldDelegate) {
     return oldDelegate.progress != progress ||
            oldDelegate.isDarkMode != isDarkMode ||
            oldDelegate.activeLayer != activeLayer;
   }
   ```
3. **Usage de `canvas.saveLayer` limité** : Ne pas abuser de `saveLayer` qui alloue un framebuffer GPU hors-écran ; privilégier `canvas.clipRect` ou `canvas.clipPath`.
