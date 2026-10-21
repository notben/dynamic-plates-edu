import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/world_atlas/data/geological_sites_data.dart';
import 'package:dynamic_plates_edu/features/world_atlas/presentation/painters/world_map_vector_painter.dart';

/// Vue interactive de la carte tectonique mondiale 100% hors-ligne.
class InteractiveMapView extends StatefulWidget {
  final void Function(int simulationIndex)? onNavigateToSimulation;

  const InteractiveMapView({super.key, this.onNavigateToSimulation});

  @override
  State<InteractiveMapView> createState() => _InteractiveMapViewState();
}

class _InteractiveMapViewState extends State<InteractiveMapView> {
  String? _selectedSiteId;
  bool _showPlates = true;
  bool _showVectors = true;

  void _onTapMap(TapUpDetails details, Size mapSize) {
    final tapX = details.localPosition.dx / mapSize.width;
    final tapY = details.localPosition.dy / mapSize.height;

    // Trouver le site le plus proche dans un rayon de tolérance
    GeologicalSite? closestSite;
    double minDistance = 0.08; // rayon ~8% de l'écran

    for (final site in GeologicalSitesData.sites) {
      final dx = site.mapPosition.dx - tapX;
      final dy = site.mapPosition.dy - tapY;
      final dist = (dx * dx + dy * dy);
      if (dist < minDistance * minDistance) {
        minDistance = dist;
        closestSite = site;
      }
    }

    if (closestSite != null) {
      setState(() => _selectedSiteId = closestSite!.id);
      _showSiteDetailModal(closestSite);
    }
  }

  void _showSiteDetailModal(GeologicalSite site) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(site.icon, color: Colors.orangeAccent, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          site.country,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  site.geologicalSetting,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                site.description,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Ouvrir la simulation correspondante'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    if (widget.onNavigateToSimulation != null) {
                      widget.onNavigateToSimulation!(site.targetSimulationIndex);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Barre de filtres (Plaques & Vecteurs GPS)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: theme.colorScheme.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  selected: _showPlates,
                  label: const Text('Frontières de plaques'),
                  avatar: const Icon(Icons.grid_3x3, size: 16),
                  onSelected: (val) => setState(() => _showPlates = val),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  selected: _showVectors,
                  label: const Text('Vecteurs de vitesse GPS'),
                  avatar: const Icon(Icons.arrow_forward, size: 16),
                  onSelected: (val) => setState(() => _showVectors = val),
                ),
                const SizedBox(width: 16),
                Text(
                  '10 sites remarquables',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Carte vectorielle interactive
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final mapSize = Size(constraints.maxWidth, constraints.maxHeight);

              return GestureDetector(
                onTapUp: (details) => _onTapMap(details, mapSize),
                child: CustomPaint(
                  size: mapSize,
                  painter: WorldMapVectorPainter(
                    selectedSiteId: _selectedSiteId,
                    showPlates: _showPlates,
                    showVectors: _showVectors,
                    isDark: isDark,
                  ),
                ),
              );
            },
          ),
        ),

        // Aide pour l'élève
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
          child: const Row(
            children: [
              Icon(Icons.touch_app, size: 16, color: Colors.orangeAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Touchez un point rouge pour explorer un site géologique emblématique.',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
