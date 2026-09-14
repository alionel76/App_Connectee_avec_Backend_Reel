# 📱 Projet Flutter — App Connectée avec Backend Réel

Cette application démontre une maîtrise complète du développement Flutter moderne en intégrant une **Clean Architecture**, des **APIs REST**, une **Gestion d'état avec BLoC**, et une **Persistance robuste** pour le mode hors-ligne.

## 🚀 Fonctionnalités Clés
- **Authentification Sécurisée** : Connexion via JWT avec gestion automatique du **Refresh Token** via un intercepteur Dio personnalisé. Les tokens sont stockés de manière sécurisée avec `FlutterSecureStorage`.
- **Catalogue de Produits** : 
    - Écran de Login.
    - Écran de Liste des Produits (API DummyJSON).
    - Écran de Détail Produit complet.
- **Mode Hors-ligne Résilient** : Mise en cache locale intégrale avec **Hive**. L'application détecte la perte de réseau et bascule automatiquement sur les données locales pour garantir une expérience utilisateur ininterrompue.
- **Gestion des Erreurs** : Système de gestion des exceptions réseau et métier avec affichage de messages utilisateur clairs.

## 🏗️ Architecture & Technologies
- **Clean Architecture (Feature-First)** : Séparation stricte des couches `Data`, `Domain` et `Presentation` au sein de chaque feature (`auth`, `products`).
- **Repository Pattern** : Unification des sources de données distantes et locales.
- **Dio Client** : Intercepteurs pour l'injection du token, le rafraîchissement automatique (Refresh Token) et les logs.
- **Bloc Pattern** : Gestion de l'état prévisible et réactive.
- **Tests Unitaires** : Couverture des couches Repository et Domain (UseCases).
- **CI/CD** : Pipeline GitHub Actions intégré pour l'analyse du code et l'exécution automatique des tests.

## 🛠️ Installation & Démarrage
1. **Dépendances** : `flutter pub get`
2. **Génération de code (Hive)** : `flutter pub run build_runner build --delete-conflicting-outputs`
3. **Tests** : `flutter test`
4. **Exécution** : `flutter run`

## 🔑 Identifiants de Test
- **Username** : `emilys`
- **Password** : `emilyspass`
