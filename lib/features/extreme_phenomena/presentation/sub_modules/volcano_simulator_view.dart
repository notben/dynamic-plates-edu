import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/painters/volcano_eruption_painter.dart';

/// Vue interactive du Simulateur des 4 Types d'Éruptions Volcaniques.
class VolcanoSimulatorView extends StatefulWidget {
  const VolcanoSimulatorView({super.key});

  @override
  State<VolcanoSimulatorView> createState() => _VolcanoSimulatorViewState();
}

class _VolcanoSimulatorViewState extends State<VolcanoSimulatorView> with SingleTickerProviderStateMixin {
  EruptionType _selectedType = EruptionType.hawaiian;
  double _viscosity = 0.15; // 0.0 (basalte très fluide) à 1.0 (rhyolite visqueuse)
  double _gasContent = 0.20; // 0.0 à 1.0
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _applyPresetForType(_selectedType);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _applyPresetForType(EruptionType type) {
    setState(() {
      _selectedType = type;
      switch (type) {
        case EruptionType.hawaiian:
          _viscosity = 0.15; // <52% SiO2
          _gasContent = 0.20;
          break;
        case EruptionType.fissure:
          _viscosity = 0.10;
          _gasContent = 0.35;
          break;
        case EruptionType.strombolian:
          _viscosity = 0.50; // ~57% SiO2
          _gasContent = 0.60;
          break;
        case EruptionType.plinian:
          _viscosity = 0.90; // >68% SiO2
          _gasContent = 0.95;
          break;
      }
    });
  }

  String _getTypeDescription() {
    switch (_selectedType) {
      case EruptionType.hawaiian:
        return 'Effusive : Lave basaltique très fluide (<52% SiO2). Dégazage aisé en fontaines de lave (10-50m). Forme d\'immenses volcans boucliers aux pentes très douces (Kilauea, Mauna Loa).';
      case EruptionType.fissure:
        return 'Fissurale : Émission linéaire de lave fluide le long de fractures crustales continentales ou dorsales. Donne naissance à de vastes plateaux basaltiques (Trapps du Décan, Laki en Islande).';
      case EruptionType.strombolian:
        return 'Mixte : Magma modérément visqueux (~57% SiO2). Explosions rythmiques par bulles de gaz, éjection de bombes volcaniques et scories édifiant un cône régulier (Stromboli).';
      case EruptionType.plinian:
        return 'Cataclysmique : Magma très visqueux (>68% SiO2, dacite/rhyolite) bloqué par un dôme. Explosion par surpression des gaz : colonne et panache en pin parasol (30-45 km), nuées ardentes mortelles (Vésuve 79 ap. J.-C., Montagne Pelée 1902).';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // 1. Sélecteur des 4 types d'éruptions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeButton(EruptionType.hawaiian, 'Hawaïenne', Icons.waves),
                const SizedBox(width: 8),
                _buildTypeButton(EruptionType.fissure, 'Fissurale', Icons.reorder),
                const SizedBox(width: 8),
                _buildTypeButton(EruptionType.strombolian, 'Strombolienne', Icons.flare),
                const SizedBox(width: 8),
                _buildTypeButton(EruptionType.plinian, 'Plinienne', Icons.cloud),
              ],
            ),
          ),
        ),

        // 2. Zone d'animation CustomPainter
        Expanded(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: VolcanoEruptionPainter(
                  type: _selectedType,
                  progress: _animController.value,
                  viscosity: _viscosity,
                  gasContent: _gasContent,
                  isDark: isDark,
                ),
              );
            },
          ),
        ),

        // 3. Panneau de contrôle des paramètres magmatiques (Viscosité & Gaz)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.opacity, size: 20, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Viscosité du magma (Taux de silice SiO₂) : ${(_viscosity * 100).toInt()}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _viscosity,
                min: 0.0,
                max: 1.0,
                onChanged: (val) => setState(() => _viscosity = val),
              ),
              Row(
                children: [
                  const Icon(Icons.bubble_chart, size: 20, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Teneur en gaz dissous (H₂O, CO₂, SO₂) : ${(_gasContent * 100).toInt()}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _gasContent,
                min: 0.0,
                max: 1.0,
                onChanged: (val) => setState(() => _gasContent = val),
              ),
            ],
          ),
        ),

        // 4. Description pédagogique PER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 18, color: Colors.orangeAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getTypeDescription(),
                  style: const TextStyle(fontSize: 12, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(EruptionType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      selected: isSelected,
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onSelected: (_) => _applyPresetForType(type),
    );
  }
}
