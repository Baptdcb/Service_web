import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:bibliotheca/models/database/dao.dart';

// URL de base de l'API
const String baseUrl = 'http://localhost:8080/api';

// Fonction principale pour tout synchroniser
Future<void> synchronize() async {
  print('--- Début de la synchronisation ---');

  // 1. Envoyer les données locales vers l'API EN PREMIER
  await pushCategoriesToAPI();
  await pushAuteursToAPI();
  await pushLivresToAPI();

  // 2. Récupérer les données mises à jour de l'API (Ordre : Parents puis Enfants)
  await syncCategoriesWithAPI();
  await syncAuteursWithAPI();
  await syncLivresWithAPI();

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
        // BODY SANS ID pour le POST
        var bodyPost = json.encode({'libelle': categorie['libelle']});

        var responsePost = await http.post(
          urlPost,
          headers: {'Content-Type': 'application/json'},
          body: bodyPost,
        );

        if (responsePost.statusCode == 200 || responsePost.statusCode == 201) {
          // Mise à jour de l'ID local avec celui reçu du serveur
          var created = json.decode(responsePost.body);
          int newId = created['id'];
          if (newId != id) {
            // Vérifier si le nouvel ID existe déjà localement pour éviter le conflit UNIQUE
            var existing = await db.query(
              'categorie',
              where: 'id = ?',
              whereArgs: [newId],
            );

            if (existing.isNotEmpty) {
              // Conflit : L'ID distant existe déjà localement (mais ce n'est pas le même enregistrement puisqu'on vient de le créer/poster).
              // Cela arrive si on a fait un GET avant qui a ramené cet ID, ou si une autre synchro l'a créé.
              // Solution : Supprimer l'entrée locale temporaire (ID 6) et garder celle qui a le bon ID (ID 10) si elle est à jour,
              // OU mettre à jour l'entrée existante (ID 10) avec les données locales et supprimer l'ancienne (ID 6).

              // Ici, on choisit de supprimer l'entrée locale temporaire car le serveur fait foi
              // et on suppose que l'entrée avec newId (10) contient les bonnes infos ou sera mise à jour au prochain sync.
              // Mais il faut aussi migrer les livres liés à l'ancien ID (6) vers le nouveau (10).

              print(
                "Conflit ID Categorie: ID $newId existe déjà. Fusion/Migration de $id vers $newId.",
              );

              // 1. Migrer les livres
              await db.update(
                'livre',
                {'categorie_id': newId},
                where: 'categorie_id = ?',
                whereArgs: [id],
              );

              // 2. Supprimer l'ancienne catégorie locale
              await db.delete('categorie', where: 'id = ?', whereArgs: [id]);
            } else {
              // Pas de conflit, mise à jour standard
              await db.update(
                'categorie',
                {'id': newId},
                where: 'id = ?',
                whereArgs: [id],
              );
              // Optionnel : Mettre à jour les livres qui référençaient l'ancien ID
              await db.update(
                'livre',
                {'categorie_id': newId},
                where: 'categorie_id = ?',
                whereArgs: [id],
              );
            }
            print("Categorie synchro: ID local $id -> ID distant $newId");
          }
        } else {
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
    var id = auteur['id'];
    try {
      // Sanitization pour éviter les 400 Bad Request
      String nom = (auteur['nom'] as String?)?.trim() ?? '';
      if (nom.isEmpty) nom = 'Inconnu';

      String prenom = (auteur['prenoms'] as String?)?.trim() ?? '';
      if (prenom.isEmpty) prenom = 'Inconnu';

      String? email = (auteur['email'] as String?)?.trim();
      if (email != null && email.isNotEmpty) {
        // Validation basique de l'email
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(email)) {
          print("Email invalide ignoré pour l'auteur ID $id: $email");
          email = null;
        }
      } else {
        email = null;
      }

      var bodyRaw = {'nom': nom, 'prenom': prenom, 'mail': email};

      // 1. Tenter la mise à jour (PUT)
      var urlPut = Uri.parse('$baseUrl/auteurs/$id');
      var responsePut = await http.put(
        urlPut,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({...bodyRaw, 'id': id}),
      );

      if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
        // Succès mise à jour
        continue;
      }

      // 2. Si non trouvé (404) ou Bad Request (400 - peut arriver si ID incoherent), tenter créer (POST)
      if (responsePut.statusCode == 404 || responsePut.statusCode == 400) {
        var urlPost = Uri.parse('$baseUrl/auteurs');
        // BODY SANS ID pour le POST (bodyRaw déjà préparé)

        var responsePost = await http.post(
          urlPost,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(bodyRaw),
        );
        print(
          "Réponse POST Auteur (ID local $id) : ${responsePost.statusCode} - ${responsePost.body}",
        ); // DEBUG
        if (responsePost.statusCode == 200 || responsePost.statusCode == 201) {
          // Mise à jour de l'ID local avec celui reçu du serveur
          var created = json.decode(responsePost.body);
          int newId = created['id'];
          if (newId != id) {
            // Vérifier si le nouvel ID existe déjà localement
            var existing = await db.query(
              'auteur',
              where: 'id = ?',
              whereArgs: [newId],
            );

            if (existing.isNotEmpty) {
              print(
                "Conflit ID Auteur: ID $newId existe déjà. Fusion/Migration de $id vers $newId.",
              );

              // 1. Migrer les livres
              await db.update(
                'livre',
                {'auteur_id': newId},
                where: 'auteur_id = ?',
                whereArgs: [id],
              );

              // 2. Supprimer l'ancien auteur local
              await db.delete('auteur', where: 'id = ?', whereArgs: [id]);
            } else {
              await db.update(
                'auteur',
                {'id': newId},
                where: 'id = ?',
                whereArgs: [id],
              );
              // Optionnel : Mettre à jour les livres qui référençaient l'ancien ID
              await db.update(
                'livre',
                {'auteur_id': newId},
                where: 'auteur_id = ?',
                whereArgs: [id],
              );
            }
            print("Auteur synchro: ID local $id -> ID distant $newId");
          }
        } else {
          print('Erreur (POST Auteur $id) : ${responsePost.statusCode}');
        }
      } else {
        print('Erreur (PUT Auteur $id) : ${responsePut.statusCode}');
      }
    } catch (e) {
      print('Exception (Push Auteur $id) : $e');
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
        'libelle': livre['libelle'] ?? '',
        'description': livre['description'] ?? '',
        // 'nbPage': livre['nbPage'],
        // 'image': livre['image'],
      };

      // Ajout conditionnel des relations
      if (livre['auteur_id'] != null) {
        bodyContent['auteur'] = {'id': livre['auteur_id']};
        // bodyContent['auteurId'] = livre['auteur_id']; // Optionnel selon l'API
      }
      if (livre['categorie_id'] != null) {
        bodyContent['categorie'] = {'id': livre['categorie_id']};
        // bodyContent['categorieId'] = livre['categorie_id']; // Optionnel selon l'API
      }

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
      if (responsePut.statusCode == 404 || responsePut.statusCode == 400) {
        var urlPost = Uri.parse('$baseUrl/livres');
        var bodyPost = json.encode(bodyContent); // ID absent
        print("Tentative POST Livre sans ID: $bodyPost"); // DEBUG

        var responsePost = await http.post(
          urlPost,
          headers: {'Content-Type': 'application/json'},
          body: bodyPost,
        );
        if (responsePost.statusCode == 200 || responsePost.statusCode == 201) {
          var created = json.decode(responsePost.body);
          int newId = created['id'];
          if (newId != id) {
            // Vérifier si le nouvel ID existe déjà localement
            var existing = await db.query(
              'livre',
              where: 'id = ?',
              whereArgs: [newId],
            );

            if (existing.isNotEmpty) {
              print(
                "Conflit ID Livre: ID $newId existe déjà. Suppression locale de l'ancien ID $id.",
              );
              // Contrairement aux catégories/auteurs, le livre est une feuille, on peut juste supprimer l'ancien
              // car il a été recréé sur le serveur sous le newId et on ne va pas propagé cet ID ailleurs pour l'instant.
              // MAIS attention si on a des données locales plus récentes sur newId...
              // Ici on suppose que le POST vient de réussir, donc newId contient nos données.
              // On supprime l'enregistrement temporaire local
              await db.delete('livre', where: 'id = ?', whereArgs: [id]);
            } else {
              await db.update(
                'livre',
                {'id': newId},
                where: 'id = ?',
                whereArgs: [id],
              );
            }
            print("Livre synchro: ID local $id -> ID distant $newId");
          }
        } else {
          print(
            'Erreur (POST Livre $id) : ${responsePost.statusCode} - Body: ${responsePost.body}',
          );
        }
      } else {
        print(
          'Erreur (PUT Livre $id) : ${responsePut.statusCode} - Body: ${responsePut.body}',
        );
      }
    } catch (e) {
      print('Exception (Push Livre) : $e');
    }
  }
}
