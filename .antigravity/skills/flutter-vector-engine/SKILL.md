---
name: flutter-vector-engine
description: Directives et patrons d'architecture pour le moteur de simulation géologique vectoriel 60/120 FPS avec Flutter CustomPainter et Canvas.
---

# Moteur Vectoriel Géologique - CustomPainter & Canvas

Ce skill fournit les directives et patterns d'ingénierie pour concevoir les simulations géologiques haute performance de *Dynamic Plates Edu*.

## 1. Principes de Rendu 60/120 FPS
- **Pas de vidéos ni GIFs lourds** : Tout est dessiné procéduralement sur le `Canvas`.
- **Contrôle par paramètre normalisé** :
  - Chaque scène géologique (Subduction, Dorsale océanique, Faille de San Andreas, Collision continentale) est une fonction pure de `progress` ($\in [0.0, 1.0]$).
  - Le `progress` peut être incrémenté via une animation continue (Ticker/AnimationController), piloté au slider géologique (0 à 50 Ma), ou manipulé directement par le geste tactile/souris de l'élève (*Drag the plates* via `GestureDetector` / `Listener`).
- **Optimisation du `shouldRepaint`** :
  - Ne recalculer les `Path` et ne repeindre que si `progress`, `themeMode` ou la taille ont changé.
  - Pré-allouer les `Paint` dans les constantes ou l'état du Painter pour éviter le garbage collection à chaque frame.
- **Rendu en couches (Layering)** :
  1. Manteau asthénosphérique (convection, cellules magmatiques, flèches dynamiques).
  2. Lithosphère océanique / continentale (croûte supérieure, sédiments, croûte inférieure).
  3. Relief de surface / Océan (eau avec dégradé et transparence, fosse, chaîne de montagnes).
  4. Phénomènes actifs (magmatisme, arcs volcaniques, foyers sismiques avec cercles d'ondes animés).
  5. Annotations pédagogiques (flèches de contrainte, étiquettes géologiques adaptées à la langue active).

## 2. Découpage Pédagogique (Cycle d'Orientation / PER)
- **Subduction océanique-continentale** (ex. Cordillère des Andes)
- **Subduction océanique-océanique** (ex. Fosse des Mariannes / Arc insulaire)
- **Accrétion / Dorsale médio-océanique** (ex. Dorsale médio-atlantique)
- **Collision continent-continent** (ex. formation des Alpes / Himalaya)
- **Faille transformante / Coulissage** (ex. Faille de San Andreas)
- **Point chaud intraplaque** (ex. Îles Hawaï)
