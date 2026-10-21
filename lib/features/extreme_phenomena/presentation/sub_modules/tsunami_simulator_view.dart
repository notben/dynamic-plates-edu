import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/painters/tsunami_dual_view_painter.dart';

/// Vue interactive du Simulateur de Tsunami à double vue synchronisée.
class TsunamiSimulatorView extends StatefulWidget {
  const TsunamiSimulatorView({super.key});

  @override
  State<TsunamiSimulatorView> createState() => _TsunamiSimulatorViewState();
}

class _TsunamiSimulatorViewState extends State<TsunamiSimulatorView> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  bool _isPlaying = true;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        if (_isPlaying) {
          setState(() => _progress = _animController.value);
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animController.forward(from: _progress);
      } else {
        _animController.stop();
      }
    });
  }

  void _reset() {
    setState(() {
      _isPlaying = false;
      _animController.stop();
      _progress = 0.0;
      _animController.value = 0.0;
    });
  }

  String _getPhaseDescription() {
    if (_progress < 0.20) {
      return '1. Tension de subduction : La plaque chevauchante fléchit sous la friction du slab descendant, accumulant une énergie élastique phénoménale.';
    } else if (_progress < 0.45) {
      return '2. Mégaséisme & Rebond élastique : Rupture brutale ! Le plancher océanique remonte de plusieurs mètres, déplaçant instantanément toute la colonne d\'eau.';
    } else if (_progress < 0.80) {
      return '3. Propagation océanique : Au large, l\'onde voyage à ~800 km/h (vitesse d\'un avion de ligne) avec une grande longueur d\'onde (~100-200 km) et une hauteur <1m.';
    } else {
      return '4. Effet de haut-fond & Déferlement : À l\'approche des côtes, les fonds marins freinent la base de l\'onde. L\'énergie se concentre : la vague ralentit et s\'élève en mur d\'eau destructeur (10-30 m).';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // 1. Zone d'animation CustomPainter en double vue synchronisée
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: TsunamiDualViewPainter(
              progress: _progress,
              isDark: isDark,
            ),
          ),
        ),

        // 2. Panneau de contrôle temporel
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                iconSize: 32,
                color: theme.colorScheme.primary,
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: _reset,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _progress,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (val) {
                    setState(() {
                      if (_isPlaying) {
                        _isPlaying = false;
                        _animController.stop();
                      }
                      _progress = val;
                      _animController.value = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // 3. Explication de la phase active
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.waves, size: 18, color: Colors.cyan),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getPhaseDescription(),
                  style: const TextStyle(fontSize: 12, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
