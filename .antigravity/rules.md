# Règles de l'Agent Antigravity - Dynamic Plates Edu

## 1. Identité du Projet & Dépôt Gitea
- **Nom du dépôt Gitea / dossier** : `Dynamic_Plates_Edu`
- **Remote Git** : `http://192.168.0.31:4000/root/Dynamic_Plates_Edu.git`
- **Nom du package Dart interne** : `dynamic_plates_edu`
- **Bundle ID iOS / Application ID Android** : `ch.edu.dynamicplates`
- **Langage & Framework** : Flutter 3.47+ (Dart 3.13+, Null Safety strict)
- **Cibles de compilation natives** :
  - **iOS** : Swift / ARM64 (iOS 16.0+)
  - **Android** : Kotlin / ARM64 (`compileSdk = 35`, `targetSdk = 35`, `minSdk = 26`), alignement mémoire 16 KB (Android 15+)
  - **Desktop / Web** : Windows x64 et Web pour prévisualisation et tests locaux rapides

## 2. Workflow Git & Gitea
- **Conventional Commits stricts** : Format atomique obligatoire (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `perf:`).
- **Validation Qualité pré-commit** : Exécuter systématiquement `flutter analyze` et `flutter test` avant tout commit. Interdiction absolue de commiter du code qui ne compile pas ou avec des avertissements/erreurs d'analyse.
- **Sécurité Git absolue (DevSecOps)** : Ne JAMAIS commiter de clés de signature, certificats, profils ou secrets dans Gitea :
  - `*.jks`, `*.keystore`, `key.properties`
  - `*.p8`, `*.p12`, `*.cer`, `*.mobileprovision`
  - `.env`, `*.env.*`, `google-services.json`, `GoogleService-Info.plist` (si secrets présents)
- **Persistance du contexte** : Maintenir et versionner le dossier `.antigravity/` dans Gitea pour partager les règles, le contexte et les skills avec l'équipe.

## 3. Architecture Logicielle & Moteur Graphique
- **Architecture modulaire Feature-First** :
  - `lib/core/` : Thème (Design System géologique, dark/light, palette contrastée), i18n, gestion audio, constantes et utilitaires.
  - `lib/features/tectonic_lab/` : Laboratoire interactif des limites de plaques (subduction, divergence, faille transformante, collision continentale).
  - `lib/features/extreme_phenomena/` : Séismes, tsunamis, volcans et points chauds.
  - `lib/features/world_atlas/` : Atlas mondial vectoriel interactif des plaques tectoniques, fosses, dorsales et orogènes.
  - `lib/features/quiz/` : Module d'auto-évaluation pédagogique avec sauvegarde locale des scores.
- **Moteur Vectoriel Natif (60/120 FPS)** :
  - Rendu 100% procédural et vectoriel via `CustomPainter` et `Canvas`.
  - Aucune vidéo lourde pré-rendue (afin de garantir 0 latence, 60/120 FPS et un poids d'application ultra-léger).
  - Simulations paramétriques pilotées par un float normalisé `progress` (`0.0` à `1.0`), manipulable en temps réel au toucher/souris (*Drag the plates*) ou via slider temporel géologique (0 à 50 Ma).
- **Design Pédagogique & Responsive** :
  - Tablette / iPad : Vue Paysage optimisée avec `NavigationRail` et grand viewport de simulation interactif.
  - Smartphone / iPhone : Vue adaptative Portrait/Paysage avec `NavigationBar`.
  - Respect strict des `SafeArea` (Dynamic Island, encoches iPhone, barres de gestes Android).
- **Multilinguisme (i18n)** :
  - Français (`fr`) par défaut : terminologie officielle conforme au Plan d'études romand (PER) du Cycle d'Orientation (12-16 ans).
  - Allemand (`de`), Italien (`it`), Anglais (`en`).

## 4. Conformité & Sécurité Apple App Store / Google Play Store (Mineurs / Éducation)
- **Politique Zero-Data & Vie Privée (nLPD Suisse / RGPD / COPPA)** :
  - Aucune collecte de données personnelles ni télémétrie.
  - 0 SDK publicitaire (pas d'AdMob, Unity Ads, etc.).
  - 0 SDK d'analytics tiers (pas de Firebase, Google Analytics, Mixpanel, etc.).
  - 0 SDK de réseau social.
  - Aucun système de compte utilisateur ou authentification requise.
- **100% Offline-First (Hermétique)** :
  - Fonctionnement autonome sans connexion Internet.
  - Toutes les ressources (polices, cartes vectorielles, sons synthétisés/effets, textes éducatifs) sont stockées localement dans `assets/`.
- **Zéro Permission Sensible** :
  - Aucune demande de permission : ni Localisation/GPS, ni Caméra, ni Microphone, ni Photos/Stockage externe.
  - Dans `android/app/src/main/AndroidManifest.xml` de production, ne pas déclarer `android.permission.INTERNET` pour garantir l'herméticité.
- **Exigences Apple App Store (`ios/Runner/`)** :
  - Fichier `PrivacyInfo.xcprivacy` déclarant `NSPrivacyTracking = false`, `NSPrivacyCollectedDataTypes = []`, et uniquement la raison d'accès `NSPrivacyAccessedAPICategoryUserDefaults` (`CA92.1`) pour la sauvegarde locale des scores du quiz.
  - Fichier `Info.plist` : `ITSAppUsesNonExemptEncryption = false`.
  - Contrôle parental ("Parental Gate" mathématique) obligatoire avant l'ouverture de tout lien web externe éventuel pour conformité stricte catégorie "Enfants / Éducation".
- **Exigences Google Play Store (`android/`)** :
  - `compileSdk = 35`, `targetSdk = 35`, `minSdk = 26`.
  - Compatibilité native avec l'alignement des pages mémoire **16 KB** (Android 15+).
  - Obfuscation et réduction de code R8 activées (`isMinifyEnabled = true`, `isShrinkResources = true`) sur les builds Release AAB.
