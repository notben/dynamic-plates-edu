import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim1_divergent_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim2_transform_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim3_subduction_ocean_continent_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim4_subduction_ocean_ocean_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim5_collision_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim6_hotspot_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/painters/sim7_global_earth_painter.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/widgets/plate_drag_container.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/widgets/geological_legend_overlay.dart';

/// Module 1 : Laboratoire Tectonique (Les 7 Simulations Interactives)
/// Permet à l'élève de manipuler au doigt ou au curseur temporel les 7 grands régimes
/// de la dynamique terrestre au programme du Cycle d'Orientation.
class TectonicLabPage extends StatefulWidget {
  const TectonicLabPage({super.key});

  @override
  State<TectonicLabPage> createState() => _TectonicLabPageState();
}

class _TectonicLabPageState extends State<TectonicLabPage> with SingleTickerProviderStateMixin {
  int _selectedSimIndex = 0;
  double _progress = 0.0;
  bool _isPlaying = false;
  bool _showLegends = false;
  late final AnimationController _animController;

  final List<_SimMeta> _simulations = [
    _SimMeta(
      id: 0,
      title: 'Divergence (Rift ➔ Océan)',
      subtitle: 'Rift Est-Africain, Mer Rouge & Dorsale Atlantique',
      icon: Icons.unfold_more,
      description: 'Bombement thermique initial, amincissement crustal avec failles normales, invasion marine, puis accrétion basaltique symétrique le long de la dorsale.',
      realExample: 'Rift Est-Africain, Mer Rouge, Dorsale médio-atlantique',
    ),
    _SimMeta(
      id: 1,
      title: 'Limite Transformante',
      subtitle: 'Coulissage horizontal & faille de San Andreas',
      icon: Icons.swap_vert,
      description: 'Glissement en sens opposé de deux blocs lithosphériques. Accumulation de contrainte élastique par frottement, puis rupture sismique brutale décalant les repères de surface.',
      realExample: 'Faille de San Andreas (Californie), Faille Nord-Anatolienne',
    ),
    _SimMeta(
      id: 2,
      title: 'Subduction Océan-Continent',
      subtitle: 'Fosse, prisme et Cordillère des Andes',
      icon: Icons.south_east,
      description: 'Plongée d\'une plaque océanique dense sous un continent. Fosse profonde, prisme sédimentaire, fusion du manteau hydraté à 100 km et éruptions volcaniques côtières.',
      realExample: 'Plaque de Nazca sous l\'Amérique du Sud (Cordillère des Andes)',
    ),
    _SimMeta(
      id: 3,
      title: 'Subduction Océan-Océan',
      subtitle: 'Fosse des Mariannes & Arc Insulaire',
      icon: Icons.terrain,
      description: 'La plaque océanique la plus ancienne et dense plonge sous la plus jeune. Naissance d\'une fosse abyssale et édification d\'un chapelet d\'îles volcaniques.',
      realExample: 'Fosse des Mariannes, Archipel du Japon, Petites Antilles',
    ),
    _SimMeta(
      id: 4,
      title: 'Collision Continent-Continent',
      subtitle: 'Orogenèse alpine & himalayenne',
      icon: Icons.landscape,
      description: 'Fermeture d\'un océan avec suture d\'ophiolites. Collision de deux croûtes continentales légères : plissements, empilement de nappes et racine crustale plongeante.',
      realExample: 'Alpes (Europe / Apulie), Himalaya (Inde / Eurasie)',
    ),
    _SimMeta(
      id: 5,
      title: 'Point Chaud Intraplaque',
      subtitle: 'Archipel d\'Hawaï & chaîne Empereur',
      icon: Icons.volcano,
      description: 'Panache mantellique thermique profond strictement fixe perforant une plaque lithosphérique mobile. Volcan actif au droit du panache, suivi d\'îles éteintes devenant des guyots.',
      realExample: 'Archipel d\'Hawaï, Île de la Réunion, Islande',
    ),
    _SimMeta(
      id: 6,
      title: 'Modèle Global de la Terre',
      subtitle: 'Convection mantellique & recyclage',
      icon: Icons.public,
      description: 'Coupe complète de l\'intérieur de la Terre : graine solide, noyau externe liquide, manteau inférieur et asthénosphère. Les cellules de convection pilotent la tectonique.',
      realExample: 'Dynamique globale de la Terre entière (6371 km de rayon)',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..addListener(() {
        if (_isPlaying) {
          setState(() {
            _progress = _animController.value;
          });
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animController.forward(from: 0.0);
        }
      });
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
        _animController.value = _progress;
        _animController.forward();
      } else {
        _animController.stop();
      }
    });
  }

  void _resetSimulation() {
    setState(() {
      _isPlaying = false;
      _animController.stop();
      _progress = 0.0;
      _animController.value = 0.0;
    });
  }

  void _updateProgress(double value) {
    setState(() {
      if (_isPlaying) {
        _isPlaying = false;
        _animController.stop();
      }
      _progress = value;
      _animController.value = value;
    });
  }

  CustomPainter _buildCurrentPainter(bool isDark) {
    switch (_selectedSimIndex) {
      case 0:
        return Sim1DivergentPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
      case 1:
        return Sim2TransformPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
      case 2:
        return Sim3SubductionOceanContinentPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
      case 3:
        return Sim4SubductionOceanOceanPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
      case 4:
        return Sim5CollisionPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
      case 5:
        return Sim6HotspotPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
      case 6:
      default:
        return Sim7GlobalEarthPainter(progress: _progress, showLegends: _showLegends, isDark: isDark);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentSim = _simulations[_selectedSimIndex];
    final millionYears = (_progress * 50.0).toStringAsFixed(1);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Barre de sélection des 7 simulations (Scroll horizontal moderne)
            _buildSimulationSelector(theme),

            // 2. Zone principale de dessin vectoriel interactif "Drag the Plates"
            Expanded(
              child: Stack(
                children: [
                  PlateDragContainer(
                    progress: _progress,
                    onProgressChanged: _updateProgress,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        painter: _buildCurrentPainter(isDark),
                      ),
                    ),
                  ),

                  // Overlay optionnel de la légende
                  if (_showLegends)
                    Positioned(
                      top: 16,
                      right: 16,
                      width: 340,
                      child: GeologicalLegendOverlay(
                        onClose: () => setState(() => _showLegends = false),
                      ),
                    ),
                ],
              ),
            ),

            // 3. Panneau de contrôle géologique & Temporel
            _buildControlBar(theme, millionYears),

            // 4. Fiche pédagogique PER rétractable
            _buildPedagogicalInfoCard(theme, currentSim),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationSelector(ThemeData theme) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _simulations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sim = _simulations[index];
          final isSelected = index == _selectedSimIndex;
          return ChoiceChip(
            selected: isSelected,
            avatar: Icon(sim.icon, size: 18, color: isSelected ? Colors.white : theme.colorScheme.primary),
            label: Text(sim.title),
            labelStyle: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedSimIndex = index;
                  _resetSimulation();
                });
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildControlBar(ThemeData theme, String millionYears) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ligne du curseur temporel (0 à 50 Ma)
          Row(
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                iconSize: 36,
                color: theme.colorScheme.primary,
                tooltip: _isPlaying ? 'Pause' : 'Animer',
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                tooltip: 'Réinitialiser (0 Ma)',
                onPressed: _resetSimulation,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Temps géologique :',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$millionYears Ma',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      ),
                      child: Slider(
                        value: _progress,
                        min: 0.0,
                        max: 1.0,
                        onChanged: _updateProgress,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: Icon(
                  _showLegends ? Icons.visibility_off : Icons.visibility,
                  size: 16,
                ),
                label: const Text('Légendes'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _showLegends ? theme.colorScheme.primary.withOpacity(0.15) : null,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onPressed: () => setState(() => _showLegends = !_showLegends),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPedagogicalInfoCard(ThemeData theme, _SimMeta sim) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sim.subtitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'PER Géographie CO',
                style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            sim.description,
            style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85), height: 1.25),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SimMeta {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String description;
  final String realExample;

  _SimMeta({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
    required this.realExample,
  });
}
