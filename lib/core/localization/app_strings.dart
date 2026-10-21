enum AppLanguage { fr, de, it, en }

/// Gestion centralisée des chaînes multilingues (FR / DE / IT / EN).
/// Conforme à la terminologie officielle du Plan d'études romand (PER) pour le Cycle d'Orientation.
class AppStrings {
  static AppLanguage currentLanguage = AppLanguage.fr;

  static String get(String key) {
    final map = _localizedValues[key];
    if (map == null) return key;
    return map[currentLanguage] ?? map[AppLanguage.fr] ?? key;
  }

  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    // Navigation
    'app_title': {
      AppLanguage.fr: 'Dynamic Plates Edu',
      AppLanguage.de: 'Dynamic Plates Edu',
      AppLanguage.it: 'Dynamic Plates Edu',
      AppLanguage.en: 'Dynamic Plates Edu',
    },
    'nav_tectonic_lab': {
      AppLanguage.fr: 'Labo Tectonique',
      AppLanguage.de: 'Tektonik-Labor',
      AppLanguage.it: 'Lab Tettonica',
      AppLanguage.en: 'Tectonic Lab',
    },
    'nav_extreme_phenomena': {
      AppLanguage.fr: 'Phénomènes Extrêmes',
      AppLanguage.de: 'Extreme Phänomene',
      AppLanguage.it: 'Fenomeni Estremi',
      AppLanguage.en: 'Extreme Events',
    },
    'nav_world_atlas': {
      AppLanguage.fr: 'Atlas Mondial',
      AppLanguage.de: 'Weltatlas',
      AppLanguage.it: 'Atlante Mondiale',
      AppLanguage.en: 'World Atlas',
    },
    'nav_quiz': {
      AppLanguage.fr: 'Quiz & Histoire',
      AppLanguage.de: 'Quiz & Geschichte',
      AppLanguage.it: 'Quiz & Storia',
      AppLanguage.en: 'Quiz & History',
    },

    // Contrôles globaux
    'drag_hint': {
      AppLanguage.fr: 'Glissez horizontalement pour déplacer les plaques',
      AppLanguage.de: 'Horizontal wischen, um die Platten zu bewegen',
      AppLanguage.it: 'Scorri orizzontalmente per muovere le placche',
      AppLanguage.en: 'Drag horizontally to move the tectonic plates',
    },
    'time_scale': {
      AppLanguage.fr: 'Temps géologique :',
      AppLanguage.de: 'Geologische Zeit:',
      AppLanguage.it: 'Tempo geologico:',
      AppLanguage.en: 'Geological Time:',
    },
    'ma_unit': {
      AppLanguage.fr: 'Ma (millions d\'années)',
      AppLanguage.de: 'Mya (Millionen Jahre)',
      AppLanguage.it: 'Ma (milioni di anni)',
      AppLanguage.en: 'Ma (million years)',
    },
    'toggle_legend': {
      AppLanguage.fr: 'Légendes',
      AppLanguage.de: 'Legende',
      AppLanguage.it: 'Legenda',
      AppLanguage.en: 'Legends',
    },
    'reset': {
      AppLanguage.fr: 'Réinitialiser',
      AppLanguage.de: 'Zurücksetzen',
      AppLanguage.it: 'Reimposta',
      AppLanguage.en: 'Reset',
    },
    'play': {
      AppLanguage.fr: 'Animer',
      AppLanguage.de: 'Abspielen',
      AppLanguage.it: 'Riproduci',
      AppLanguage.en: 'Play',
    },
    'pause': {
      AppLanguage.fr: 'Pause',
      AppLanguage.de: 'Pause',
      AppLanguage.it: 'Pausa',
      AppLanguage.en: 'Pause',
    },

    // Simulations Tectonique
    'sim_divergent_title': {
      AppLanguage.fr: '1. Limite Divergente : Du Rift à l\'Océan',
      AppLanguage.de: '1. Divergierende Grenze: Vom Graben zum Ozean',
      AppLanguage.it: '1. Margine Divergente: Dal Rift all\'Oceano',
      AppLanguage.en: '1. Divergent Boundary: Rift to Ocean',
    },
    'sim_transform_title': {
      AppLanguage.fr: '2. Limite Transformante : Faille Coulissante',
      AppLanguage.de: '2. Transformstörung: Blattverschiebung',
      AppLanguage.it: '2. Margine Trasforme: Faglia Trascorrente',
      AppLanguage.en: '2. Transform Boundary: Strike-Slip Fault',
    },
    'sim_sub_oc_cont_title': {
      AppLanguage.fr: '3. Convergence Océan-Continent : Subduction',
      AppLanguage.de: '3. Ozean-Kontinent-Kollision: Subduktion',
      AppLanguage.it: '3. Convergenza Oceano-Continente: Subduzione',
      AppLanguage.en: '3. Ocean-Continent Convergence: Subduction',
    },
    'sim_sub_oc_oc_title': {
      AppLanguage.fr: '4. Convergence Océan-Océan : Arc Insulaire',
      AppLanguage.de: '4. Ozean-Ozean-Kollision: Inselbogen',
      AppLanguage.it: '4. Convergenza Oceano-Oceano: Arco Insulare',
      AppLanguage.en: '4. Ocean-Ocean Convergence: Island Arc',
    },
    'sim_collision_title': {
      AppLanguage.fr: '5. Convergence Continent-Continent : Collision',
      AppLanguage.de: '5. Kontinent-Kontinent-Kollision: Gebirgsbildung',
      AppLanguage.it: '5. Convergenza Continente-Continente: Collisione',
      AppLanguage.en: '5. Continent-Continent Convergence: Collision',
    },
    'sim_hotspot_title': {
      AppLanguage.fr: '6. Point Chaud Intraplaque (Hawaï)',
      AppLanguage.de: '6. Intraplatten-Hotspot (Hawaii)',
      AppLanguage.it: '6. Punto Caldo Intraplacca (Hawaii)',
      AppLanguage.en: '6. Intraplate Hot Spot (Hawaii)',
    },
    'sim_global_earth_title': {
      AppLanguage.fr: '7. Modèle Global : Convection Mantellique',
      AppLanguage.de: '7. Globales Erdmodell: Mantelkonvektion',
      AppLanguage.it: '7. Modello Globale: Convezione del Mantello',
      AppLanguage.en: '7. Global Earth Model: Mantle Convection',
    },

    // Termes géologiques PER
    'lithosphere': {
      AppLanguage.fr: 'Lithosphère (rigide, 0-100 km)',
      AppLanguage.de: 'Lithosphäre (starr, 0-100 km)',
      AppLanguage.it: 'Litosfera (rigida, 0-100 km)',
      AppLanguage.en: 'Lithosphere (rigid, 0-100 km)',
    },
    'asthenosphere': {
      AppLanguage.fr: 'Asthénosphère (ductile, visqueuse)',
      AppLanguage.de: 'Asthenosphäre (duktil, plastisch)',
      AppLanguage.it: 'Astenosfera (duttile, viscosa)',
      AppLanguage.en: 'Asthenosphere (ductile, viscous)',
    },
    'crust_continental': {
      AppLanguage.fr: 'Croûte continentale (granitique, ~35 km)',
      AppLanguage.de: 'Kontinentale Kruste (granitisch, ~35 km)',
      AppLanguage.it: 'Crosta continentale (granitica, ~35 km)',
      AppLanguage.en: 'Continental crust (granitic, ~35 km)',
    },
    'crust_oceanic': {
      AppLanguage.fr: 'Croûte océanique (basaltique dense, ~7 km)',
      AppLanguage.de: 'Ozeanische Kruste (dichter Basalt, ~7 km)',
      AppLanguage.it: 'Crosta oceanica (basalto denso, ~7 km)',
      AppLanguage.en: 'Oceanic crust (dense basalt, ~7 km)',
    },
    'moho': {
      AppLanguage.fr: 'Discontinuité de Mohorovičić (Moho)',
      AppLanguage.de: 'Mohorovičić-Diskontinuität (Moho)',
      AppLanguage.it: 'Discontinuità di Mohorovičić (Moho)',
      AppLanguage.en: 'Mohorovičić Discontinuity (Moho)',
    },
    'trench': {
      AppLanguage.fr: 'Fosse océanique profonde',
      AppLanguage.de: 'Tiefseegraben',
      AppLanguage.it: 'Fossa oceanica profonda',
      AppLanguage.en: 'Deep oceanic trench',
    },
    'prism': {
      AppLanguage.fr: 'Prisme d\'accrétion sédimentaire',
      AppLanguage.de: 'Akkretionskeil',
      AppLanguage.it: 'Prisma di accrescimento',
      AppLanguage.en: 'Accretionary prism',
    },
    'magma_chamber': {
      AppLanguage.fr: 'Chambre magmatique & fusion partielle',
      AppLanguage.de: 'Magmakammer & Partialschmelze',
      AppLanguage.it: 'Camera magmatica & fusione parziale',
      AppLanguage.en: 'Magma chamber & partial melting',
    },
  };
}
