# Dynamic Plates Edu 🌍🌋

Application pédagogique interactive de géologie et de tectonique des plaques, spécialement conçue pour les élèves du **Cycle d'Orientation (12-16 ans, Suisse romande)** et conforme au **Plan d'études romand (PER)**.

---

## 🎯 Piliers Fondamentaux

- **⚡ Moteur Vectoriel Natif (60/120 FPS)** : Rendu 100% procédural via Flutter `CustomPainter` et `Canvas`. Zéro vidéo pré-rendue. Toutes les simulations (subduction, divergence, plissement alpin, séismes, volcanisme) sont pilotées en temps réel par un paramètre `progress` ($\in [0.0, 1.0]$) contrôlé au doigt ou à la souris (*Drag the plates*).
- **🔒 Politique Zero-Data & Vie Privée (nLPD Suisse / RGPD / COPPA)** : 
  - Aucune collecte de données personnelles, aucun compte requis.
  - Zéro SDK publicitaire, zéro SDK d'analytique tiers.
  - Aucune permission sensible sollicitée (ni caméra, ni micro, ni géolocalisation).
  - Absence de la permission `INTERNET` dans les builds de production Android pour une herméticité totale.
- **📦 100% Offline-First** : Toutes les polices, atlas vectoriels, sons et ressources pédagogiques sont embarqués localement.
- **📱 Responsive & Multiplateforme** :
  - **iOS / iPadOS 16.0+** : Interface adaptée avec `NavigationRail` sur iPad et `NavigationBar` sur iPhone avec respect strict des `SafeArea` et de la Dynamic Island.
  - **Android SDK 35** : Optimisation pour Android 15+ avec compatibilité native pour l'alignement mémoire **16 KB** et obfuscation R8.
  - **Web & Desktop (Windows)** : Support complet pour prévisualisation locale et déploiement en classe.
- **🌐 Multilingue (i18n)** : Français (langue par défaut avec terminologie officielle PER), Allemand, Italien, Anglais.

---

## 🏛️ Architecture du Projet

L'application suit une architecture modulaire *Feature-First* :

```text
lib/
├── core/                        # Fondations transverses
│   ├── theme/                   # Design System géologique (dark/light, contrastes)
│   ├── localization/            # i18n FR / DE / IT / EN (terminologie PER)
│   ├── audio/                   # Moteur audio hors-ligne
│   └── constants/               # Constantes physiques et géologiques
│
├── features/
│   ├── tectonic_lab/            # Laboratoire interactif des limites de plaques
│   │   ├── domain/              # Modèles géodynamiques (plaques, vitesses)
│   │   └── presentation/        # CustomPainters procéduraux (subduction, rifting)
│   ├── extreme_phenomena/       # Phénomènes extrêmes (séismes, tsunamis, volcans)
│   ├── world_atlas/             # Atlas interactif vectoriel des plaques mondiales
│   └── quiz/                    # Module d'auto-évaluation pédagogique
│
└── main.dart                    # Point d'entrée de l'application
```

---

## 🛡️ Conformité Stores & DevSecOps

- **Apple App Store** :
  - `ios/Runner/PrivacyInfo.xcprivacy` : Déclaration `NSPrivacyTracking = false`, types de données collectées vides, et accès limité à `CA92.1` (`UserDefaults`) pour la sauvegarde locale des scores.
  - `Info.plist` : `ITSAppUsesNonExemptEncryption = false`.
  - Contrôle parental cognitif (*Parental Gate*) obligatoire sur tout lien externe sortant.
- **Google Play Store** :
  - `compileSdk = 35`, `targetSdk = 35`, `minSdk = 26`.
  - Obfuscation et réduction de code R8 (`isMinifyEnabled = true`, `isShrinkResources = true`).
  - Alignement des pages mémoire 16 KB garanti.
- **Gestion des Secrets** : Zéro clé de signature (`*.jks`, `*.keystore`, `*.p12`, `*.mobileprovision`) dans le dépôt Git.

---

## 🤖 Règles et Compétences Agent Antigravity

Le dépôt intègre la configuration pour l'agent Antigravity :
- [`.antigravity/rules.md`](file:///.antigravity/rules.md) : Règles strictes de développement, DevSecOps et workflow Git.
- [`.antigravity/skills/geology_simulation_engine.md`](file:///.antigravity/skills/geology_simulation_engine.md) : Directives du moteur vectoriel géologique (Bézier, gradients, particules, ondes P/S).
- [`.antigravity/skills/store_compliance_checklist.md`](file:///.antigravity/skills/store_compliance_checklist.md) : Checklist de validation pré-release pour l'App Store et Google Play.

---

## 🚀 Démarrage et Validation

```powershell
# Installation des dépendances
flutter pub get

# Analyse statique rigoureuse
flutter analyze

# Lancement des tests unitaires et widgets
flutter test

# Exécution sur l'environnement de dev
flutter run
```

---

## 🔄 Intégration Continue (Gitea Actions)

Un workflow automatisé est configuré dans [`.gitea/workflows/ci.yml`](file:///.gitea/workflows/ci.yml) pour valider à chaque commit :
1. Résolution des dépendances (`flutter pub get`)
2. Analyse statique stricte (`flutter analyze`)
3. Exécution de la suite de tests (`flutter test`)
