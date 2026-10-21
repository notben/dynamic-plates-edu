# Skill : Checklist DevSecOps & Conformité Stores (Apple & Google Play)

Ce document liste l'ensemble des vérifications automatiques et des critères d'audit à valider impérativement avant tout build de Release de **Dynamic Plates Edu**.

---

## 1. Audit iOS : `ios/Runner/PrivacyInfo.xcprivacy`
Le fichier de manifeste de confidentialité Apple est obligatoire depuis iOS 17+.

- [ ] **Présence du fichier** : `ios/Runner/PrivacyInfo.xcprivacy` doit exister et être intégré dans la cible Xcode `Runner`.
- [ ] **Pas de suivi inter-applications (`NSPrivacyTracking`)** :
  ```xml
  <key>NSPrivacyTracking</key>
  <false/>
  ```
- [ ] **Aucune donnée collectée (`NSPrivacyCollectedDataTypes`)** :
  ```xml
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  ```
- [ ] **API Requises strictement limitées à UserDefaults (`CA92.1`)** :
  ```xml
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>CA92.1</string>
      </array>
    </dict>
  </array>
  ```

---

## 2. Audit iOS : `ios/Runner/Info.plist`
- [ ] **Exemption de chiffrement** :
  ```xml
  <key>ITSAppUsesNonExemptEncryption</key>
  <false/>
  ```
- [ ] **Zéro permission sensible** :
  Vérifier l'absence absolue des clés suivantes dans `Info.plist` :
  - `NSCameraUsageDescription`
  - `NSMicrophoneUsageDescription`
  - `NSLocationWhenInUseUsageDescription`
  - `NSPhotoLibraryUsageDescription`
  - `NSUserTrackingUsageDescription`
- [ ] **Contrôle Parental (Catégorie Enfants / Éducation)** :
  Tout déclenchement de `launchUrl` vers un domaine web externe (ex. site de l'école ou crédits) doit impérativement être intercepté par un widget `ParentalGateDialog` (défi mathématique) validé avant l'ouverture.

---

## 3. Audit Android : `android/app/src/main/AndroidManifest.xml`
- [ ] **Zéro permission Internet en Release** :
  Retirer toute balise :
  ```xml
  <!-- INTERDIT EN PROD -->
  <uses-permission android:name="android.permission.INTERNET" />
  ```
  *(Seul un AndroidManifest de debug local peut temporairement l'utiliser pour le hot-reload Flutter).*
- [ ] **Zéro permission sensible** :
  Aucune permission `ACCESS_FINE_LOCATION`, `CAMERA`, `RECORD_AUDIO`, `READ_EXTERNAL_STORAGE`.
- [ ] **Application ID** :
  Le `applicationId` ou `package` doit être `ch.edu.dynamicplates`.

---

## 4. Audit Android : `android/app/build.gradle.kts`
- [ ] **Version des SDK cibles** :
  - `compileSdk = 35`
  - `targetSdk = 35`
  - `minSdk = 26`
- [ ] **Alignement des pages mémoire 16 KB (Android 15+)** :
  Garantir la compatibilité 16 KB pour les bibliothèques C++ / NDK si présentes.
- [ ] **Obfuscation et Shrinking R8** :
  ```kotlin
  buildTypes {
      release {
          signingConfig = signingConfigs.getByName("release") // ou debug pour dev
          isMinifyEnabled = true
          isShrinkResources = true
          proguardFiles(
              getDefaultProguardFile("proguard-android-optimize.txt"),
              "proguard-rules.pro"
          )
      }
  }
  ```

---

## 5. Script d'Audit Automatisé Pré-Release (PowerShell)

Exécuter cette commande de vérification avant de créer un tag de release :

```powershell
# Vérification absence INTERNET dans AndroidManifest principal
$manifest = Get-Content "android/app/src/main/AndroidManifest.xml" -Raw
if ($manifest -match "android.permission.INTERNET") {
    Write-Error "VIOLATION STORE: android.permission.INTERNET trouvé dans AndroidManifest.xml !"
    exit 1
}

# Vérification PrivacyInfo iOS
if (-not (Test-Path "ios/Runner/PrivacyInfo.xcprivacy")) {
    Write-Error "VIOLATION STORE: ios/Runner/PrivacyInfo.xcprivacy manquant !"
    exit 1
}

# Vérification absence de secrets commis
$secrets = git status --porcelain | Select-String -Pattern "\.(jks|keystore|p8|p12|mobileprovision|env)"
if ($secrets) {
    Write-Error "SÉCURITÉ: Fichier de clés ou secret détecté !"
    exit 1
}

Write-Host "✅ Audit DevSecOps Stores : Validé avec succès !" -ForegroundColor Green
```
