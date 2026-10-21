import 'package:flutter/material.dart';

/// Jalons historiques de la découverte de la Tectonique des Plaques (PER Cycle d'Orientation).
class HistoryMilestone {
  final int year;
  final String title;
  final String scientist;
  final String description;
  final String keyProof;
  final IconData icon;

  const HistoryMilestone({
    required this.year,
    required this.title,
    required this.scientist,
    required this.description,
    required this.keyProof,
    required this.icon,
  });
}

class WegenerHistoryData {
  static const List<HistoryMilestone> milestones = [
    HistoryMilestone(
      year: 1912,
      title: 'L\'Hypothèse de la Dérive des Continents',
      scientist: 'Alfred Wegener (Météorologue & Géophysicien allemand)',
      description: 'Wegener émet l\'hypothèse révolutionnaire que tous les continents actuels étaient autrefois réunis en un supercontinent unique : la Pangée, baignée par un immense océan (Panthalassa).',
      keyProof: 'Emboîtement frappant des littoraux atlantiques (Amérique du Sud et Afrique de l\'Ouest).',
      icon: Icons.public,
    ),
    HistoryMilestone(
      year: 1915,
      title: 'Les 4 Preuves Scientifiques Fondamentales',
      scientist: 'Alfred Wegener (Publication de son ouvrage majeur)',
      description: '1. Morphologique (côtes complémentaires).\n2. Paléontologique : fossiles identiques du reptile Mesosaurus et de la fougère Glossopteris trouvés sur des continents aujourd\'hui séparés par des milliers de km d\'océan.\n3. Géologique : continuité des boucliers rocheux anciens.\n4. Paléoclimatique : traces glaciaires permo-carbonifères synchrones en Afrique, Inde et Amérique du Sud.',
      keyProof: 'Mesosaurus & Glossopteris ne pouvaient ni nager à travers l\'océan Atlantique ni voler.',
      icon: Icons.biotech,
    ),
    HistoryMilestone(
      year: 1928,
      title: 'Le Rejet Massif des Géophysiciens Fixistes',
      scientist: 'Harold Jeffreys & la communauté géologique internationale',
      description: 'Les géologues de l\'époque rejettent violemment sa théorie. Faute de connaître la convection du manteau, Wegener invoquait une force centrifuge et des marées lunaires insuffisantes pour fendre les continents. Wegener meurt en héros de la science lors d\'une expédition au Groenland en 1930.',
      keyProof: 'Problème du moteur mécanique : comment des continents granitiques pourraient-ils labourer le plancher océanique basaltique rigide ?',
      icon: Icons.cancel_outlined,
    ),
    HistoryMilestone(
      year: 1952,
      title: 'Cartographie des Fonds Abyssaux & Dorsale Océanique',
      scientist: 'Marie Tharp & Bruce Heezen (Géologues cartographes)',
      description: 'Grâce au sonar, Marie Tharp découvre que le fond des océans n\'est pas plat mais traversé par une gigantesque chaîne de montagnes sous-marines de 65 000 km entaillée par une vallée axiale (rift).',
      keyProof: 'Présence d\'un fossé d\'effondrement au milieu de l\'Atlantique avec forte activité thermique et sismique.',
      icon: Icons.map,
    ),
    HistoryMilestone(
      year: 1960,
      title: 'L\'Expansion des Fonds Océaniques (Le Tapis Roulant)',
      scientist: 'Harry Hess (Géologue & amiral de l\'US Navy)',
      description: 'Hess propose que le manteau terrestre est animé de cellules de convection thermique : le magma remonte aux dorsales, refroidit pour créer de la croûte océanique neuve qui s\'écarte symétriquement comme un double tapis roulant, avant de replonger dans les fosses océaniques.',
      keyProof: 'Les sédiments marins sont très minces près de la dorsale et s\'épaississent en s\'éloignant vers les côtes.',
      icon: Icons.sync,
    ),
    HistoryMilestone(
      year: 1963,
      title: 'Le Magnétomètre Géologique : Inversions Magnétiques',
      scientist: 'Fred Vine & Drummond Matthews',
      description: 'La Terre inverse régulièrement sa polarité magnétique. En se refroidissant au niveau de la dorsale, les basaltes enregistrent l\'orientation du champ magnétique terrestre comme une bande magnétique, créant des anomalies zébrées symétriques parfaites.',
      keyProof: 'Preuve irréfutable de la création continue et symétrique de croûte océanique neuve.',
      icon: Icons.line_style,
    ),
    HistoryMilestone(
      year: 1968,
      title: 'Naissance de la Théorie de la Tectonique des Plaques',
      scientist: 'Xavier Le Pichon, Dan McKenzie, Jason Morgan',
      description: 'Synthèse mathématique et géologique globale : la surface de la Terre n\'est pas mobile par continents isolés, mais formée d\'une douzaine de plaques lithosphériques rigides (croûte + manteau supérieur cassant) se déplaçant sur l\'asthénosphère ductile.',
      keyProof: 'Localisation précise de tous les séismes mondiaux concentrés exclusivement sur les limites de plaques.',
      icon: Icons.grid_view,
    ),
    HistoryMilestone(
      year: 1990,
      title: 'Confirmation Spatiale par Satellites GPS en Temps Réel',
      scientist: 'Géodésie spatiale moderne & Géophysique contemporaine',
      description: 'Le réseau mondial de balises GPS permanentes mesure les déplacements millimétriques des continents chaque jour, confirmant au chiffre près les vitesses et directions calculées par les modèles géologiques (ex: 2 cm/an pour l\'Europe et l\'Amérique, 8-9 cm/an pour la plaque Pacifique).',
      keyProof: 'Mesure directe par satellite en temps réel accessible aux élèves du CO !',
      icon: Icons.satellite_alt,
    ),
  ];
}
