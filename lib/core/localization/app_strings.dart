enum AppLanguage { fr, de, it, en }

/// Gestion centralisée des chaînes multilingues (FR / DE / IT / EN).
/// Conforme à la terminologie officielle du Plan d'études romand (PER) pour le Cycle d'Orientation
/// et aux programmes suisse alémanique (Lehrplan 21) et tessinois (Piano di studio).
class AppStrings {
  static AppLanguage currentLanguage = AppLanguage.fr;

  static String get(String key, [List<dynamic>? args]) {
    final map = _localizedValues[key];
    var text = (map == null) ? key : (map[currentLanguage] ?? map[AppLanguage.fr] ?? key);
    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        text = text.replaceAll('{$i}', args[i].toString());
      }
    }
    return text;
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
      AppLanguage.fr: 'Quiz & Évaluation',
      AppLanguage.de: 'Quiz & Test',
      AppLanguage.it: 'Quiz & Valutazione',
      AppLanguage.en: 'Quiz & Test',
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

    // Phénomènes Extrêmes Tabs
    'tab_volcano': {
      AppLanguage.fr: 'Volcanisme (4 types)',
      AppLanguage.de: 'Vulkanismus (4 Typen)',
      AppLanguage.it: 'Vulcanismo (4 tipi)',
      AppLanguage.en: 'Volcanism (4 types)',
    },
    'tab_earthquake': {
      AppLanguage.fr: 'Séismes (Ondes P/S)',
      AppLanguage.de: 'Erdbeben (P/S-Wellen)',
      AppLanguage.it: 'Terremoti (Onde P/S)',
      AppLanguage.en: 'Earthquakes (P/S Waves)',
    },
    'tab_tsunami': {
      AppLanguage.fr: 'Tsunami (Double vue)',
      AppLanguage.de: 'Tsunami (Doppelansicht)',
      AppLanguage.it: 'Tsunami (Doppia vista)',
      AppLanguage.en: 'Tsunami (Dual view)',
    },

    // Atlas Tabs
    'tab_tectonic_map': {
      AppLanguage.fr: 'Carte Tectonique & Sites',
      AppLanguage.de: 'Tektonische Karte & Stätten',
      AppLanguage.it: 'Carta Tettonica & Siti',
      AppLanguage.en: 'Tectonic Map & Sites',
    },
    'tab_wegener': {
      AppLanguage.fr: 'Frise Wegener (Pangée)',
      AppLanguage.de: 'Wegener-Zeitleiste (Pangaea)',
      AppLanguage.it: 'Cronologia Wegener (Pangea)',
      AppLanguage.en: 'Wegener Timeline (Pangaea)',
    },

    // Module Quiz & Évaluation
    'quiz_header_title': {
      AppLanguage.fr: 'Quiz & Auto-évaluation (PER)',
      AppLanguage.de: 'Quiz & Selbsteinschätzung',
      AppLanguage.it: 'Quiz & Autovalutazione',
      AppLanguage.en: 'Quiz & Self-Assessment',
    },
    'quiz_header_subtitle': {
      AppLanguage.fr: 'Valide tes connaissances géologiques pour le Cycle d\'Orientation (12-16 ans).',
      AppLanguage.de: 'Überprüfe dein Wissen über die Plattentektonik für die Sekundarstufe.',
      AppLanguage.it: 'Verifica le tue conoscenze di geologia per la scuola media.',
      AppLanguage.en: 'Test your geological knowledge for secondary school.',
    },
    'quiz_best_score': {
      AppLanguage.fr: 'Meilleur score',
      AppLanguage.de: 'Beste Punktzahl',
      AppLanguage.it: 'Miglior punteggio',
      AppLanguage.en: 'Best Score',
    },
    'quiz_total_sessions': {
      AppLanguage.fr: 'Sessions réalisées',
      AppLanguage.de: 'Abgeschlossene Tests',
      AppLanguage.it: 'Sessioni completate',
      AppLanguage.en: 'Completed Sessions',
    },
    'quiz_choose_category': {
      AppLanguage.fr: 'Choisis un domaine d\'entraînement :',
      AppLanguage.de: 'Wähle einen Themenbereich:',
      AppLanguage.it: 'Scegli un ambito di allenamento:',
      AppLanguage.en: 'Choose a training domain:',
    },
    'quiz_cat_all': {
      AppLanguage.fr: 'Toutes les catégories (Mixte)',
      AppLanguage.de: 'Alle Kategorien (Gemischt)',
      AppLanguage.it: 'Tutte le categorie (Misto)',
      AppLanguage.en: 'All Categories (Mixed)',
    },
    'quiz_cat_tectonics': {
      AppLanguage.fr: 'Tectonique des Plaques',
      AppLanguage.de: 'Plattentektonik',
      AppLanguage.it: 'Tettonica delle Placche',
      AppLanguage.en: 'Plate Tectonics',
    },
    'quiz_cat_volcanoes': {
      AppLanguage.fr: 'Volcanisme',
      AppLanguage.de: 'Vulkanismus',
      AppLanguage.it: 'Vulcanismo',
      AppLanguage.en: 'Volcanism',
    },
    'quiz_cat_earthquakes': {
      AppLanguage.fr: 'Séismes & Tsunamis',
      AppLanguage.de: 'Erdbeben & Tsunamis',
      AppLanguage.it: 'Terremoti e Tsunami',
      AppLanguage.en: 'Earthquakes & Tsunamis',
    },
    'quiz_cat_history': {
      AppLanguage.fr: 'Histoire des Sciences',
      AppLanguage.de: 'Wissenschaftsgeschichte',
      AppLanguage.it: 'Storia della Scienza',
      AppLanguage.en: 'History of Science',
    },
    'quiz_start_button': {
      AppLanguage.fr: 'Démarrer le Quiz (10 questions)',
      AppLanguage.de: 'Quiz starten (10 Fragen)',
      AppLanguage.it: 'Inizia il Quiz (10 domande)',
      AppLanguage.en: 'Start Quiz (10 questions)',
    },
    'quiz_question_progress': {
      AppLanguage.fr: 'Question {0} sur {1}',
      AppLanguage.de: 'Frage {0} von {1}',
      AppLanguage.it: 'Domanda {0} di {1}',
      AppLanguage.en: 'Question {0} of {1}',
    },
    'quiz_current_score': {
      AppLanguage.fr: 'Score : {0}',
      AppLanguage.de: 'Punkte: {0}',
      AppLanguage.it: 'Punteggio: {0}',
      AppLanguage.en: 'Score: {0}',
    },
    'quiz_scientific_explanation': {
      AppLanguage.fr: 'Explication scientifique (PER) :',
      AppLanguage.de: 'Wissenschaftliche Erklärung:',
      AppLanguage.it: 'Spiegazione scientifica:',
      AppLanguage.en: 'Scientific explanation:',
    },
    'quiz_next_question': {
      AppLanguage.fr: 'Question suivante',
      AppLanguage.de: 'Nächste Frage',
      AppLanguage.it: 'Prossima domanda',
      AppLanguage.en: 'Next question',
    },
    'quiz_finish_button': {
      AppLanguage.fr: 'Voir les résultats',
      AppLanguage.de: 'Ergebnisse ansehen',
      AppLanguage.it: 'Vedi i risultati',
      AppLanguage.en: 'View results',
    },
    'quiz_results_title': {
      AppLanguage.fr: 'Bilan de la Session',
      AppLanguage.de: 'Ergebnis der Sitzung',
      AppLanguage.it: 'Riepilogo della Sessione',
      AppLanguage.en: 'Session Results',
    },
    'quiz_final_score': {
      AppLanguage.fr: 'Ton score : {0} / {1} ({2}%)',
      AppLanguage.de: 'Dein Ergebnis: {0} / {1} ({2}%)',
      AppLanguage.it: 'Il tuo punteggio: {0} / {1} ({2}%)',
      AppLanguage.en: 'Your score: {0} / {1} ({2}%)',
    },
    'quiz_grade_expert': {
      AppLanguage.fr: 'Niveau Expert Géologue ! Tu maîtrises parfaitement la géodynamique terrestre et le programme PER.',
      AppLanguage.de: 'Experten-Geologe! Du beherrschst die Geodynamik und den Lehrplan perfekt.',
      AppLanguage.it: 'Livello Geologo Esperto! Padroneggi perfettamente la geodinamica terrestre.',
      AppLanguage.en: 'Expert Geologist Level! You have mastered Earth geodynamics and curriculum standards.',
    },
    'quiz_grade_good': {
      AppLanguage.fr: 'Très bon résultat ! Les grands principes tectoniques et géologiques sont bien compris.',
      AppLanguage.de: 'Sehr gutes Ergebnis! Die tektonischen und geologischen Grundlagen sind gut verstanden.',
      AppLanguage.it: 'Ottimo risultato! I principi tettonici e geologici sono ben compresi.',
      AppLanguage.en: 'Very good result! Core tectonic and geological concepts are well understood.',
    },
    'quiz_grade_retry': {
      AppLanguage.fr: 'Encore un petit effort ! Reviens observer les animations des plaques et relis les légendes pour t\'améliorer.',
      AppLanguage.de: 'Noch etwas Übung nötig! Schau dir die Plattensimulationen nochmals an, um dich zu verbessern.',
      AppLanguage.it: 'Ancora un piccolo sforzo! Esplora di nuovo le simulazioni e rileggi le legende per migliorare.',
      AppLanguage.en: 'A little more practice needed! Explore the plate simulations and read legends to improve.',
    },
    'quiz_restart_button': {
      AppLanguage.fr: 'Recommencer une série',
      AppLanguage.de: 'Neue Runde starten',
      AppLanguage.it: 'Inizia nuova sessione',
      AppLanguage.en: 'Start new round',
    },
    'quiz_home_button': {
      AppLanguage.fr: 'Retour à l\'accueil du Quiz',
      AppLanguage.de: 'Zurück zur Quiz-Übersicht',
      AppLanguage.it: 'Torna all\'inizio del Quiz',
      AppLanguage.en: 'Back to Quiz Home',
    },
  };
}

