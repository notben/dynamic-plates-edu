# Antigravity Rules - Dynamic Plates Edu

Consultez le fichier de référence principal : [.antigravity/rules.md](file:///c:/Dynamic_Plates_Edu/Dynamic_Plates_Edu/.antigravity/rules.md)

Ces règles sont strictement contraignantes pour l'ensemble du cycle de vie du projet :
1. **Identité & Cibles** : `Dynamic_Plates_Edu`, package `dynamic_plates_edu`, bundle ID `ch.edu.dynamicplates`, Flutter 3.47+, iOS 16.0+, Android SDK 35 (16 KB page alignment), Desktop/Web pour dev local.
2. **Workflow Git & Gitea** : Commits atomiques (Conventional Commits), zéro secrets/certificats commités, passage obligatoire de `flutter analyze` et `flutter test` avant commit.
3. **Moteur Graphique & Rendu** : 100% procédural avec `CustomPainter` et `Canvas`, responsive smartphone/tablette, i18n FR (PER suisse romand) / DE / IT / EN, animations pilotées par `progress` [0.0 - 1.0].
4. **DevSecOps & Stores** : Zéro collecte de données (nLPD / RGPD / COPPA), 100% offline-first, zéro permission sensible (pas d'Internet en prod Android), PrivacyInfo.xcprivacy (UserDefaults CA92.1 uniquement), Parental Gate pour tout lien web.
