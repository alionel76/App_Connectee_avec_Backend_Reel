# Projet Flutter — App connectée avec backend réel

Cette application valide la maîtrise des APIs REST, de la Clean Architecture, de la gestion d'état avec BLoC et de la persistance des données pour un mode hors-ligne résilient.

## 🚀 Fonctionnalités
- **Authentification JWT** : Connexion, déconnexion et persistance sécurisée du jeton avec `FlutterSecureStorage` (Backend: DummyJSON API).
- **Catalogue de Produits (3 Écrans)** :
  1. Écran de Connexion (Auth)
  2. Écran de Liste des Produits (REST)
  3. Écran de Détail du Produit
- **Mode Hors-ligne & Cache Local** : Mise en cache complète des données avec **Hive**. Si le réseau est indisponible, l'application bascule automatiquement sur les données locales.
- **Gestion des Erreurs** : Interception et affichage de messages d'erreur clairs en cas de problème réseau ou d'identifiants invalides.

## 🏗️ Architecture & Exigences Techniques
- **Clean Architecture** organisée par Feature (`core`, `features/auth`, `features/products`), découpée en couches `data`, `domain` et `presentation`.
- **Repository Pattern** pour l'unification des sources de données locales et distantes.
- **Dio Client** avec `AuthInterceptor` pour l'injection automatique du token JWT et `LogInterceptor` pour le débogage.
- **Tests Unitaires** : Couverture complète de la couche Repository et UseCases (9 tests unitaires validés avec `mocktail`).

## 🔑 Identifiants de Test (DummyJSON)
- **Username** : `emilys`
- **Password** : `emilyspass`

## 🛠️ Installation & Démarrage
1. Récupérer les dépendances :
   ```bash
   flutter pub get
   ```
2. Générer les adaptateurs Hive :
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. Lancer les tests unitaires :
   ```bash
   flutter test
   ```
4. Exécuter l'application :
   ```bash
   flutter run
   ```
