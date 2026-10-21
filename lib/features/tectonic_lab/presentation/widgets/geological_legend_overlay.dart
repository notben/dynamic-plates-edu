import 'package:flutter/material.dart';

/// Légende interactive géologique conforme au Plan d'études romand (PER).
/// Affiche la définition des couches et structures géologiques majeures :
/// Lithosphère, Asthénosphère, Moho, Fosse océanique, Prisme d'accrétion, Chambre magmatique.
class GeologicalLegendOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const GeologicalLegendOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      _LegendItem(
        title: 'Lithosphère (rigide, 0 - 100 km)',
        description: 'Couche superficielle cassante formée par la croûte et la partie supérieure du manteau. Découpée en plaques tectoniques mobiles.',
        color: const Color(0xFF6D4C41),
        icon: Icons.layers,
      ),
      _LegendItem(
        title: 'Asthénosphère (ductile, visqueuse)',
        description: 'Partie déformable et chaude du manteau supérieur (100 à 660 km). Siège des courants de convection thermique qui entraînent les plaques.',
        color: const Color(0xFFFF5722),
        icon: Icons.whatshot,
      ),
      _LegendItem(
        title: 'Discontinuité de Mohorovičić (Moho)',
        description: 'Limite sismique séparant la croûte terrestre du manteau supérieur. Profondeur de ~7 km sous les océans, ~35 km sous les plaines et jusqu\'à 60 km sous les Alpes.',
        color: const Color(0xFFFFC107),
        icon: Icons.horizontal_rule,
      ),
      _LegendItem(
        title: 'Fosse océanique',
        description: 'Dépression sous-marine étroite et abyssale (jusqu\'à 11 000 m aux Mariannes) marquant l\'enfoncement d\'une plaque dans une zone de subduction.',
        color: const Color(0xFF01579B),
        icon: Icons.south,
      ),
      _LegendItem(
        title: 'Prisme d\'accrétion',
        description: 'Empilement d\'écailles sédimentaires marines rabotées par la plaque chevauchante lors de la subduction.',
        color: const Color(0xFFD7CCC8),
        icon: Icons.filter_hdr,
      ),
      _LegendItem(
        title: 'Chambre magmatique & Fusion partielle',
        description: 'La déshydratation du slab plongeant provoque la fusion partielle du manteau vers 100 km de profondeur, alimentant le volcanisme en surface.',
        color: const Color(0xFFFF3D00),
        icon: Icons.local_fire_department,
      ),
    ];

    return Card(
      elevation: 6,
      color: theme.colorScheme.surface.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Légendes Géologiques (PER)',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose,
                  tooltip: 'Fermer',
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 6),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: item.color, width: 1.5),
                    ),
                    child: Icon(item.icon, size: 16, color: item.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _LegendItem {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  _LegendItem({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });
}
