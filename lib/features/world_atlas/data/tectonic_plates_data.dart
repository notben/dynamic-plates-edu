import 'package:flutter/material.dart';

/// Définition des plaques tectoniques mondiales (Majeures et Secondaires).
/// Données géologiques : vitesses de déplacement (cm/an) mesurées par GPS et géométrie normalisée.
class TectonicPlate {
  final String id;
  final String name;
  final Color color;
  final double speedCmPerYear;
  final String motionDirection;
  final String boundaryType;
  final List<Offset> boundaryPoints; // Points normalisés sur la carte du monde [0.0, 1.0]

  const TectonicPlate({
    required this.id,
    required this.name,
    required this.color,
    required this.speedCmPerYear,
    required this.motionDirection,
    required this.boundaryType,
    required this.boundaryPoints,
  });
}

class TectonicPlatesData {
  static const List<TectonicPlate> plates = [
    // 1. Plaque Pacifique (la plus vaste et la plus rapide)
    TectonicPlate(
      id: 'pacific',
      name: 'Plaque Pacifique',
      color: Color(0xFF0288D1),
      speedCmPerYear: 8.5,
      motionDirection: 'Nord-Ouest',
      boundaryType: 'Subduction (Mariannes, Aléoutiennes), Dorsale Pacifique Est, Transformante (San Andreas)',
      boundaryPoints: [
        Offset(0.05, 0.35),
        Offset(0.18, 0.25),
        Offset(0.28, 0.40),
        Offset(0.32, 0.65),
        Offset(0.20, 0.85),
        Offset(0.08, 0.80),
        Offset(0.02, 0.60),
      ],
    ),
    // 2. Plaque Nord-Américaine
    TectonicPlate(
      id: 'north_america',
      name: 'Plaque Nord-Américaine',
      color: Color(0xFF388E3C),
      speedCmPerYear: 2.3,
      motionDirection: 'Ouest / Sud-Ouest',
      boundaryType: 'Divergence médio-atlantique, Faille de San Andreas',
      boundaryPoints: [
        Offset(0.18, 0.15),
        Offset(0.42, 0.15),
        Offset(0.45, 0.45),
        Offset(0.28, 0.45),
        Offset(0.22, 0.30),
      ],
    ),
    // 3. Plaque Sud-Américaine
    TectonicPlate(
      id: 'south_america',
      name: 'Plaque Sud-Américaine',
      color: Color(0xFF8D6E63),
      speedCmPerYear: 1.8,
      motionDirection: 'Ouest',
      boundaryType: 'Subduction des Andes (Nazca), Divergence Atlantique',
      boundaryPoints: [
        Offset(0.32, 0.50),
        Offset(0.48, 0.50),
        Offset(0.45, 0.85),
        Offset(0.33, 0.85),
        Offset(0.30, 0.65),
      ],
    ),
    // 4. Plaque Eurasienne
    TectonicPlate(
      id: 'eurasia',
      name: 'Plaque Eurasienne',
      color: Color(0xFFF57C00),
      speedCmPerYear: 2.1,
      motionDirection: 'Est',
      boundaryType: 'Collision Alpine et Himalayenne, Dorsale Arctique',
      boundaryPoints: [
        Offset(0.45, 0.15),
        Offset(0.92, 0.15),
        Offset(0.88, 0.45),
        Offset(0.55, 0.45),
        Offset(0.45, 0.35),
      ],
    ),
    // 5. Plaque Africaine
    TectonicPlate(
      id: 'africa',
      name: 'Plaque Africaine',
      color: Color(0xFF7B1FA2),
      speedCmPerYear: 2.2,
      motionDirection: 'Nord / Nord-Est',
      boundaryType: 'Dorsales Atlantique et Indienne, Rift Est-Africain, Collision Méditerranée',
      boundaryPoints: [
        Offset(0.46, 0.38),
        Offset(0.68, 0.38),
        Offset(0.66, 0.75),
        Offset(0.50, 0.75),
      ],
    ),
    // 6. Plaque Indo-Australienne
    TectonicPlate(
      id: 'indo_australia',
      name: 'Plaque Indo-Australienne',
      color: Color(0xFFC2185B),
      speedCmPerYear: 6.2,
      motionDirection: 'Nord-Nord-Est',
      boundaryType: 'Collision continentale (Himalaya), Subduction (Sonde / Indonésie)',
      boundaryPoints: [
        Offset(0.65, 0.42),
        Offset(0.85, 0.42),
        Offset(0.92, 0.78),
        Offset(0.68, 0.78),
      ],
    ),
    // 7. Plaque Antarctique
    TectonicPlate(
      id: 'antarctica',
      name: 'Plaque Antarctique',
      color: Color(0xFF546E7A),
      speedCmPerYear: 1.2,
      motionDirection: 'Rotation lente',
      boundaryType: 'Ceinture presque continue de dorsales océaniques divergentes',
      boundaryPoints: [
        Offset(0.10, 0.90),
        Offset(0.90, 0.90),
        Offset(0.95, 0.98),
        Offset(0.05, 0.98),
      ],
    ),
    // 8. Plaque Nazca (Secondaire, subduction sous les Andes)
    TectonicPlate(
      id: 'nazca',
      name: 'Plaque de Nazca',
      color: Color(0xFF0097A7),
      speedCmPerYear: 7.7,
      motionDirection: 'Est (vers l\'Amérique du Sud)',
      boundaryType: 'Subduction rapide (Fosse Pérou-Chili / Cordillère des Andes)',
      boundaryPoints: [
        Offset(0.24, 0.52),
        Offset(0.30, 0.52),
        Offset(0.29, 0.80),
        Offset(0.22, 0.75),
      ],
    ),
    // 9. Plaque Arabique
    TectonicPlate(
      id: 'arabian',
      name: 'Plaque Arabique',
      color: Color(0xFFAFB42B),
      speedCmPerYear: 3.0,
      motionDirection: 'Nord-Est',
      boundaryType: 'Ouverture Mer Rouge (Divergence), Collision Zagros',
      boundaryPoints: [
        Offset(0.60, 0.40),
        Offset(0.66, 0.40),
        Offset(0.64, 0.50),
        Offset(0.58, 0.48),
      ],
    ),
    // 10. Plaque Philippine
    TectonicPlate(
      id: 'philippine',
      name: 'Plaque Philippine',
      color: Color(0xFFE64A19),
      speedCmPerYear: 5.5,
      motionDirection: 'Nord-Ouest',
      boundaryType: 'Fosse des Mariannes (Subduction sous la plaque Philippine)',
      boundaryPoints: [
        Offset(0.82, 0.42),
        Offset(0.89, 0.42),
        Offset(0.88, 0.58),
        Offset(0.81, 0.55),
      ],
    ),
  ];
}
