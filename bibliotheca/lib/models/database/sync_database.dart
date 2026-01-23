import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:bibliotheca/models/database/dao.dart';

// URL de base de l'API
const String baseUrl = 'http://localhost:8080/api';

// Fonction principale pour tout synchroniser
Future<void> synchronize() async {
  print('--- Début de la synchronisation ---');

  // 1. Récupérer les données de l'API (Ordre : Parents puis Enfants)
  await syncCategoriesWithAPI();
  await syncAuteursWithAPI();
  await syncLivresWithAPI();

  // 2. Envoyer les données locales vers l'API
  await pushCategoriesToAPI();
  await pushAuteursToAPI();
  await pushLivresToAPI();

  print('--- Synchronisation terminée ---');
}

// -----------------------------------------------------------------------------
// CATEGORIES
// -----------------------------------------------------------------------------

// Synchronisation des catégories entre l'API et la base locale
Future<void> syncCategoriesWithAPI() async {
  final db = await DatabaseHelper().database;
  var url = Uri.parse('$baseUrl/categories');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      final List<dynamic> categories = decoded is List ? decoded : <dynamic>[];
      for (final item in categories) {
        final Map<String, dynamic> categorie = item as Map<String, dynamic>;
        await db.insert('categorie', {
          'id': categorie['id'],
          'libelle': categorie['libelle'],
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      print('Categories récupérées : ${categories.length}');
    } else {
      print('Erreur (GET Categories) : ${response.statusCode}');
    }
  } catch (e) {
    print('Exception (GET Categories) : $e');
  }
}

// Synchronisation des catégories locales avec l'API
Future<void> pushCategoriesToAPI() async {
  final db = await DatabaseHelper().database;
  List<Map<String, dynamic>> categories = await db.query('categorie');

  for (var categorie in categories) {
    try {
      var id = categorie['id'];
      var body = json.encode({'id': id, 'libelle': categorie['libelle']});

      // 1. Tenter la mise à jour (PUT)
      var urlPut = Uri.parse('$baseUrl/categories/$id');
      var responsePut = await http.put(
        urlPut,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
        continue;
      }

      // 2. Si non trouvé (404), créer (POST)
      if (responsePut.statusCode == 404) {
        var urlPost = Uri.parse('$baseUrl/categories');
        var responsePost = await http.post(
          urlPost,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        if (responsePost.statusCode != 200 && responsePost.statusCode != 201) {
          print('Erreur (POST Categorie $id) : ${responsePost.statusCode}');
        }
      } else {
        print('Erreur (PUT Categorie $id) : ${responsePut.statusCode}');
      }
    } catch (e) {
      print('Exception (Push Categorie) : $e');
    }
  }
}

// -----------------------------------------------------------------------------
// AUTEURS
// -----------------------------------------------------------------------------

// Synchronisation des auteurs (API -> Local)
Future<void> syncAuteursWithAPI() async {
  final db = await DatabaseHelper().database;
  var url = Uri.parse('$baseUrl/auteurs');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      final List<dynamic> auteurs = decoded is List ? decoded : <dynamic>[];

      for (final item in auteurs) {
        final Map<String, dynamic> auteur = item as Map<String, dynamic>;
        await db.insert('auteur', {
          'id': auteur['id'],
          'nom': auteur['nom'] ?? 'Inconnu',
          'prenoms': auteur['prenom'] ?? '', // API field is 'prenom'
          'email': auteur['mail'], // API field is 'mail'
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      print('Auteurs récupérés : ${auteurs.length}');
    } else {
      print('Erreur (GET Auteurs) : ${response.statusCode}');
    }
  } catch (e) {
    print('Exception (GET Auteurs) : $e');
  }
}

// Synchronisation des auteurs (Local -> API)
Future<void> pushAuteursToAPI() async {
  final db = await DatabaseHelper().database;
  List<Map<String, dynamic>> auteurs = await db.query('auteur');

  for (var auteur in auteurs) {
    try {
      var id = auteur['id'];
      var body = json.encode({
        'id': id,
        'nom': auteur['nom'],
        'prenom': auteur['prenoms'], // Map local 'prenoms' to API 'prenom'
        'mail': auteur['email'], // Map local 'email' to API 'mail'
      });

      // 1. Tenter la mise à jour (PUT)
      var urlPut = Uri.parse('$baseUrl/auteurs/$id');
      var responsePut = await http.put(
        urlPut,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
        // Succès mise à jour
        continue;
      }

      // 2. Si non trouvé (404), créer (POST)
      // On accepte aussi de fall-back si le PUT échoue pour autre raison non-fatale,
      // mais attention aux 500 qui pourraient se répéter.
      if (responsePut.statusCode == 404) {
        var urlPost = Uri.parse('$baseUrl/auteurs');
        var responsePost = await http.post(
          urlPost,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        if (responsePost.statusCode != 200 && responsePost.statusCode != 201) {
          print('Erreur (POST Auteur $id) : ${responsePost.statusCode}');
        }
      } else {
        print('Erreur (PUT Auteur $id) : ${responsePut.statusCode}');
      }
    } catch (e) {
      print('Exception (Push Auteur) : $e');
    }
  }
}

// -----------------------------------------------------------------------------
// LIVRES
// -----------------------------------------------------------------------------

// Synchronisation des livres (API -> Local)
Future<void> syncLivresWithAPI() async {
  final db = await DatabaseHelper().database;
  var url = Uri.parse('$baseUrl/livres');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      final List<dynamic> livres = decoded is List ? decoded : <dynamic>[];

      for (final item in livres) {
        final Map<String, dynamic> livre = item as Map<String, dynamic>;

        // Gestion des IDs, en supposant que l'API peut renvoyer un objet ou un ID simple
        int? auteurId;
        if (livre['auteur'] is Map) {
          auteurId = livre['auteur']['id'];
        } else {
          auteurId = livre['auteurId'] ?? livre['auteur'];
        }

        int? categorieId;
        if (livre['categorie'] is Map) {
          categorieId = livre['categorie']['id'];
        } else {
          categorieId = livre['categorieId'] ?? livre['categorie'];
        }

        await db.insert('livre', {
          'id': livre['id'],
          'libelle': livre['libelle'],
          'description': livre['description'],
          // Ces colonnes ne sont pas dans le CREATE TABLE de dao.dart actuel
          // 'nbPage': livre['nbPage'],
          // 'image': livre['image'],
          'auteur_id': auteurId,
          'categorie_id': categorieId,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      print('Livres récupérés : ${livres.length}');
    } else {
      print('Erreur (GET Livres) : ${response.statusCode}');
    }
  } catch (e) {
    print('Exception (GET Livres) : $e');
  }
}

// Synchronisation des livres (Local -> API)
Future<void> pushLivresToAPI() async {
  final db = await DatabaseHelper().database;
  List<Map<String, dynamic>> livres = await db.query('livre');

  for (var livre in livres) {
    try {
      var id = livre['id'];
      // Body commun
      Map<String, dynamic> bodyContent = {
        'libelle': livre['libelle'],
        'description': livre['description'],
        // 'nbPage': livre['nbPage'],
        // 'image': livre['image'],
        // Pour insert/update, l'API attend souvent juste les IDs des relations ou les objets
        'auteurId': livre['auteur_id'],
        'categorieId': livre['categorie_id'],
        'auteur': {'id': livre['auteur_id']},
        'categorie': {'id': livre['categorie_id']},
      };

      // 1. Tenter la mise à jour (PUT) - Avec ID
      var bodyPut = json.encode({...bodyContent, 'id': id});
      var urlPut = Uri.parse('$baseUrl/livres/$id');
      var responsePut = await http.put(
        urlPut,
        headers: {'Content-Type': 'application/json'},
        body: bodyPut,
      );

      if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
        continue;
      }

      // 2. Si 404, créer (POST) - SANS ID
      if (responsePut.statusCode == 404) {
        var urlPost = Uri.parse('$baseUrl/livres');
        var bodyPost = json.encode(bodyContent); // ID absent

        var responsePost = await http.post(
          urlPost,
          headers: {'Content-Type': 'application/json'},
          body: bodyPost,
        );
        if (responsePost.statusCode == 200 || responsePost.statusCode == 201) {
          var created = json.decode(responsePost.body);
          int newId = created['id'];
          if (newId != id) {
            await db.update(
              'livre',
              {'id': newId},
              where: 'id = ?',
              whereArgs: [id],
            );
            print("Livre synchro: ID local $id -> ID distant $newId");
          }
        } else {
          print('Erreur (POST Livre $id) : ${responsePost.statusCode}');
        }
      } else {
        print('Erreur (PUT Livre $id) : ${responsePut.statusCode}');
      }
    } catch (e) {
      print('Exception (Push Livre) : $e');
    }
  }
}
