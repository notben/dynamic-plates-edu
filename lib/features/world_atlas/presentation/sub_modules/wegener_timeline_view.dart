import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/world_atlas/data/wegener_history_data.dart';
import 'package:dynamic_plates_edu/features/world_atlas/presentation/painters/pangea_drift_painter.dart';

/// Vue interactive de la frise historique d'Alfred Wegener et de l'animation de la Pangée.
class WegenerTimelineView extends StatefulWidget {
  const WegenerTimelineView({super.key});

  @override
  State<WegenerTimelineView> createState() => _WegenerTimelineViewState();
}

class _WegenerTimelineViewState extends State<WegenerTimelineView> with SingleTickerProviderStateMixin {
  double _driftProgress = 0.0; // 0.0 = 250 Ma -> 1.0 = 0 Ma
  bool _showFossils = true;
  bool _isPlaying = false;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(() {
        if (_isPlaying) {
          setState(() => _driftProgress = _animController.value);
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
        _animController.forward(from: _driftProgress);
      } else {
        _animController.stop();
      }
    });
  }

  void _reset() {
    setState(() {
      _isPlaying = false;
      _animController.stop();
      _driftProgress = 0.0;
      _animController.value = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // 1. Animation de la dislocation de la Pangée
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: PangeaDriftPainter(
                  progress: _driftProgress,
                  showFossils: _showFossils,
                  isDark: isDark,
                ),
              ),
              // Bouton flottant pour afficher/masquer les fossiles
              Positioned(
                top: 10,
                right: 10,
                child: FilterChip(
                  selected: _showFossils,
                  avatar: const Icon(Icons.star, size: 14, color: Colors.yellowAccent),
                  label: const Text('Fossiles Mesosaurus', style: TextStyle(fontSize: 11)),
                  onSelected: (val) => setState(() => _showFossils = val),
                ),
              ),
            ],
          ),
        ),

        // 2. Contrôles temporels de la Pangée
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
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
                  value: _driftProgress,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (val) {
                    setState(() {
                      if (_isPlaying) {
                        _isPlaying = false;
                        _animController.stop();
                      }
                      _driftProgress = val;
                      _animController.value = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // 3. Frise chronologique défilante (1912 à nos jours)
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: WegenerHistoryData.milestones.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final m = WegenerHistoryData.milestones[index];
              return Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${m.year}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              m.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Icon(m.icon, color: theme.colorScheme.primary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.scientist,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.description,
                        style: const TextStyle(fontSize: 12.5, height: 1.35),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.verified, size: 16, color: Colors.amber),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Preuve clé : ${m.keyProof}',
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
