---
name: store-compliance-security
description: Directives DevSecOps et conformité Apple App Store (Éducation / Enfants) et Google Play Store (Mineurs / 16 KB page size / Zero Data).
---

# Conformité App Store & Google Play Store (Secteur Éducation / Mineurs)

Directives strictes pour garantir une validation instantanée sans rejet sur les stores Apple et Google.

## 1. Apple App Store (iOS 16+ / iPadOS 16+)
- **Fichier `ios/Runner/PrivacyInfo.xcprivacy`** :
  - `NSPrivacyTracking`: `<false/>`
  - `NSPrivacyCollectedDataTypes`: tableau vide `<array/>`
  - `NSPrivacyAccessedAPITypes`:
    - `NSPrivacyAccessedAPIType`: `NSPrivacyAccessedAPICategoryUserDefaults`
    - `NSPrivacyAccessedAPITypeReasons`: `CA92.1` (accès local exclusif à l'application pour les réglages et progression)
- **Fichier `ios/Runner/Info.plist`** :
  - `ITSAppUsesNonExemptEncryption`: `<false/>`
- **Parental Gate (Obligatoire pour catégorie Éducation / Enfants)** :
  - Tout lien externe (ex. site de l'établissement, crédits, mentions légales) doit être précédé d'un défi cognitif (ex. multiplication aléatoire `7 × 8 = ?`) pour empêcher les mineurs de quitter l'application par inadvertance.

## 2. Google Play Store (Android SDK 35 & 16 KB)
- **Alignement des pages mémoire 16 KB** :
  - Configurer Gradle et NDK pour supporter les pages 16 KB exigées sur Android 15+.
- **Zéro Permission** :
  - `AndroidManifest.xml` en production : aucune permission réseau (`android.permission.INTERNET` retirée), aucune géolocalisation, aucun accès caméra/micro/stockage.
- **R8 ProGuard** :
  - `isMinifyEnabled = true`, `isShrinkResources = true` dans `build.gradle.kts` pour réduire la taille et obfusquer le code.

## 3. Conformité Légale (Suisse nLPD & RGPD & COPPA)
- Aucun cookie, aucun identifiant publicitaire (IDFA / GAID).
- 100% de traitement local in-memory et persistance locale chiffrée ou basique (scores).
