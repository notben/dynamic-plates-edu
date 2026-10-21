import 'package:flutter/material.dart';

/// Conteneur interactif "Drag the Plates".
/// Permet à l'élève de manipuler directement la simulation par glissement horizontal
/// au doigt ou à la souris sur l'écran, tout en synchronisant l'animation et le slider temporel.
class PlateDragContainer extends StatelessWidget {
  final Widget child;
  final double progress;
  final ValueChanged<double> onProgressChanged;

  const PlateDragContainer({
    super.key,
    required this.child,
    required this.progress,
    required this.onProgressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            // Sensibilité adaptée à la largeur de l'écran
            final deltaProgress = details.primaryDelta != null
                ? details.primaryDelta! / (totalWidth * 0.75)
                : 0.0;
            final newProgress = (progress + deltaProgress).clamp(0.0, 1.0);
            onProgressChanged(newProgress);
          },
          child: Stack(
            children: [
              child,
              // Indication discrète du geste de glissement
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swipe, size: 16, color: Colors.orangeAccent),
                        SizedBox(width: 8),
                        Text(
                          'Glissez pour déplacer les plaques',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
