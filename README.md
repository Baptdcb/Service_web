# Projet Bibliotheca

Ce projet est une application de gestion de bibliothèque composée d'un backend Spring Boot et d'un frontend Flutter.

## Prérequis

- MySQL
- Java 17+
- Flutter SDK

## 1. Configuration de la Base de Données

1. Assurez-vous que votre serveur MySQL est lancé.
2. Créez une base de données nommée `bibliotheca` :
   ```sql
   CREATE DATABASE bibliotheca;
   ```
3. Les identifiants par défaut configurés dans le backend sont :
   - **URL** : `jdbc:mysql://localhost:3306/bibliotheca`
   - **Utilisateur** :
   - **Mot de passe** :

## 2. Lancement du Backend (API REST)

Le backend est situé dans le dossier `API REST`.

1. Allez dans le répertoire du backend :
   ```bash
   cd "API REST"
   ```
2. Lancez l'application avec Maven :
   ```bash
   ./mvnw spring-boot:run
   ```
3. Une fois lancé, l'API est accessible sur `http://localhost:8080`.
4. Vous pouvez consulter la documentation Swagger à l'adresse : `http://localhost:8080/swagger-ui.html`

## 3. Lancement du Frontend (Flutter)

Le frontend est situé dans le dossier `bibliotheca`.

1. Allez dans le répertoire du frontend :
   ```bash
   cd bibliotheca
   ```
2. Récupérez les dépendances :
   ```bash
   flutter pub get
   ```
3. Lancez l'application :
   ```bash
   flutter run
   ```
   _Note : Assurez-vous d'avoir un émulateur lancé ou un appareil connecté._
