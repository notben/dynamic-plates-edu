import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/painters/earthquake_waves_painter.dart';

/// Vue interactive du Simulateur de Séismes et Ondes Sismiques.
class EarthquakeSimulatorView extends StatefulWidget {
  const EarthquakeSimulatorView({super.key});

  @override
  State<EarthquakeSimulatorView> createState() => _EarthquakeSimulatorViewState();
}

class _EarthquakeSimulatorViewState extends State<EarthquakeSimulatorView> with SingleTickerProviderStateMixin {
  double _magnitude = 6.8; // 3.0 à 9.0
  double _depthKm = 40.0; // 10 km à 300 km
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getDepthCategory() {
    if (_depthKm < 70) return 'Séisme superficiel (0 - 70 km) : Très destructeur';
    if (_depthKm < 300) return 'Séisme intermédiaire (70 - 300 km)';
    return 'Séisme profond (> 300 km) : Ressenti atténué en surface';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // 1. Zone d'animation CustomPainter des ondes
        Expanded(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: EarthquakeWavesPainter(
                  depthKm: _depthKm,
                  magnitude: _magnitude,
                  waveProgress: _animController.value,
                  isDark: isDark,
                ),
              );
            },
          ),
        ),

        // 2. Panneau de contrôle (Magnitude & Profondeur de foyer)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Magnitude de Moment (Mw) : ${_magnitude.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _magnitude >= 7.0 ? Colors.red.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _magnitude >= 7.5 ? 'Séisme Majeur' : (_magnitude >= 6.0 ? 'Séisme Fort' : 'Modéré'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _magnitude >= 7.0 ? Colors.redAccent : Colors.orangeAccent,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _magnitude,
                min: 3.0,
                max: 9.0,
                divisions: 60,
                onChanged: (val) => setState(() => _magnitude = val),
              ),
              Row(
                children: [
                  const Icon(Icons.vertical_align_bottom, color: Colors.cyan, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Profondeur du foyer (Hypocentre) : ${_depthKm.toInt()} km',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _depthKm,
                min: 10.0,
                max: 300.0,
                divisions: 29,
                onChanged: (val) => setState(() => _depthKm = val),
              ),
            ],
          ),
        ),

        // 3. Fiche explicative PER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.orangeAccent),
                  const SizedBox(width: 6),
                  Text(
                    _getDepthCategory(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Les ondes P (compression rapide) arrivent les premières, suivies des ondes S (cisaillement). Lorsque les ondes atteignent la surface à l\'épicentre, elles génèrent des ondes de surface de forte amplitude responsables de la majorité des dégâts aux infrastructures.',
                style: TextStyle(fontSize: 11.5, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
