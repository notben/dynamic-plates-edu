import 'package:flutter/material.dart';

/// Les 10 sites géologiques emblématiques de la tectonique mondiale
/// avec géolocalisation sur la carte, description pédagogique PER et lien vers la simulation dédiée.
class GeologicalSite {
  final String id;
  final String name;
  final String country;
  final Offset mapPosition; // Coordonnées normalisées sur le canevas [0.0 à 1.0]
  final String geologicalSetting;
  final String description;
  final int targetSimulationIndex; // Index dans le Laboratoire Tectonique (ou Phénomènes)
  final IconData icon;

  const GeologicalSite({
    required this.id,
    required this.name,
    required this.country,
    required this.mapPosition,
    required this.geologicalSetting,
    required this.description,
    required this.targetSimulationIndex,
    required this.icon,
  });
}

class GeologicalSitesData {
  static const List<GeologicalSite> sites = [
    // 1. Alpes franco-suisses
    GeologicalSite(
      id: 'alps',
      name: 'Alpes Franco-Suisses',
      country: 'Suisse / France / Italie',
      mapPosition: Offset(0.50, 0.32),
      geologicalSetting: 'Collision Continent-Continent (Orogenèse Alpine)',
      description: 'Nées de la collision entre la plaque eurasienne et la microplaque apulienne (Afrique) après la disparition de l\'océan Téthys. Caractérisées par d\'immenses nappes de charriage plissées et des sommets prestigieux (Mont-Blanc 4807m, Cervin 4478m).',
      targetSimulationIndex: 4, // Collision
      icon: Icons.landscape,
    ),
    // 2. Islande
    GeologicalSite(
      id: 'iceland',
      name: 'Islande (Thingvellir)',
      country: 'Islande',
      mapPosition: Offset(0.44, 0.20),
      geologicalSetting: 'Divergence Océanique + Point Chaud',
      description: 'Seul endroit au monde où la dorsale médio-atlantique émerge à l\'air libre, surélevée par un puissant panache thermique mantellique. La plaine de Thingvellir montre à ciel ouvert les failles normales qui écartent l\'Amérique de l\'Europe à raison de 2 cm/an.',
      targetSimulationIndex: 0, // Divergence
      icon: Icons.unfold_more,
    ),
    // 3. Rift Est-Africain
    GeologicalSite(
      id: 'east_african_rift',
      name: 'Rift Est-Africain & Afar',
      country: 'Éthiopie / Kenya / Tanzanie',
      mapPosition: Offset(0.58, 0.55),
      geologicalSetting: 'Rifting Continental Actif (Divergence)',
      description: 'Fracturation de la plaque africaine en deux blocs (plaque nubienne et somalienne). Fossés d\'effondrement bordés de failles normales avec grands lacs et volcans (Kilimandjaro, Ol Doinyo Lengai).',
      targetSimulationIndex: 0, // Divergence (stade continental)
      icon: Icons.broken_image,
    ),
    // 4. Mer Rouge
    GeologicalSite(
      id: 'red_sea',
      name: 'Mer Rouge & Golfe d\'Aden',
      country: 'Égypte / Arabie Saoudite',
      mapPosition: Offset(0.59, 0.44),
      geologicalSetting: 'Océanisation Linéaire Naissante',
      description: 'Stade intermédiaire d\'ouverture océanique : le fossé continental s\'est tellement aminci que les eaux marines ont envahi la dépression, créant un jeune océan avec formation de croûte basaltique axiale.',
      targetSimulationIndex: 0, // Divergence (stade mer rouge)
      icon: Icons.waves,
    ),
    // 5. Faille de San Andreas
    GeologicalSite(
      id: 'san_andreas',
      name: 'Faille de San Andreas',
      country: 'États-Unis (Californie)',
      mapPosition: Offset(0.20, 0.36),
      geologicalSetting: 'Limite Transformante Décrochante',
      description: 'Zone de coulissage horizontal de plus de 1200 km entre la plaque Pacifique (se déplaçant vers le nord à ~5 cm/an) et la plaque Nord-Américaine. Siège de tensions élastiques majeures relâchées par des séismes dévastateurs (San Francisco 1906).',
      targetSimulationIndex: 1, // Faille transformante
      icon: Icons.swap_vert,
    ),
    // 6. Cordillère des Andes
    GeologicalSite(
      id: 'andes',
      name: 'Cordillère des Andes & Fosse Pérou-Chili',
      country: 'Chili / Pérou / Argentine',
      mapPosition: Offset(0.31, 0.65),
      geologicalSetting: 'Convergence Océan-Continent (Subduction)',
      description: 'La plus longue chaîne de montagnes continentale (7000 km). Résulte de l\'enfoncement de la plaque océanique de Nazca sous l\'Amérique du Sud, avec fosse sous-marine (>8000 m), prisme d\'accrétion et gigantesque arc volcanique (Aconcagua, Guallatiri).',
      targetSimulationIndex: 2, // Subduction Océan-Continent
      icon: Icons.terrain,
    ),
    // 7. Fosse des Mariannes & Japon
    GeologicalSite(
      id: 'mariana',
      name: 'Fosse des Mariannes & Archipel du Japon',
      country: 'Pacifique Ouest / Japon',
      mapPosition: Offset(0.85, 0.45),
      geologicalSetting: 'Convergence Océan-Océan (Subduction Abyssale)',
      description: 'Plongée abrupte d\'une croûte océanique jurassique très dense sous la plaque philippine. Le point le plus profond du globe terrestre (Challenger Deep, -10 994 m) avec édification d\'arcs insulaires volcaniques.',
      targetSimulationIndex: 3, // Subduction Océan-Océan
      icon: Icons.south,
    ),
    // 8. Chaîne de l\'Himalaya
    GeologicalSite(
      id: 'himalaya',
      name: 'Himalaya & Plateau Tibétain',
      country: 'Népal / Inde / Chine',
      mapPosition: Offset(0.72, 0.38),
      geologicalSetting: 'Collision Continent-Continent Paroxysmale',
      description: 'Collision brutale entamée il y a 50 Ma lorsque le sous-continent indien s\'est encastré dans l\'Eurasie. Soulèvement des 14 sommets de plus de 8000 m (Everest 8848 m) avec un épaississement crustal doublé (Moho jusqu\'à 70 km).',
      targetSimulationIndex: 4, // Collision
      icon: Icons.filter_hdr,
    ),
    // 9. Archipel d\'Hawaï
    GeologicalSite(
      id: 'hawaii',
      name: 'Archipel d\'Hawaï (Kilauea & Mauna Kea)',
      country: 'États-Unis (Océan Pacifique)',
      mapPosition: Offset(0.12, 0.44),
      geologicalSetting: 'Point Chaud Intraplaque Profond',
      description: 'Panache thermique mantellique fixe perforant la plaque Pacifique qui dérive à 9 cm/an vers le NO. Les îles vieillissent et s\'érodent au fur et à mesure de leur éloignement de la source de magma.',
      targetSimulationIndex: 5, // Point chaud
      icon: Icons.volcano,
    ),
    // 10. Ceinture de Feu du Pacifique
    GeologicalSite(
      id: 'ring_of_fire',
      name: 'Ceinture de Feu du Pacifique',
      country: 'Pourtour de l\'Océan Pacifique',
      mapPosition: Offset(0.90, 0.35),
      geologicalSetting: 'Ceinture globale de subductions',
      description: 'Alignement continu de plus de 450 volcans actifs et concentrant 80% des grands séismes du monde, bordant tout le pourtour du bassin pacifique depuis la Nouvelle-Zélande jusqu\'au Chili.',
      targetSimulationIndex: 6, // Modèle global
      icon: Icons.whatshot,
    ),
  ];
}
