import 'package:bibliotheca/models/database/dao.dart';

abstract class EditionController {
  Future<void> save();
  bool validate();
}

class LivreEditionController extends EditionController {
  String titre = '';
  String description = '';
  int? categorieId;
  int? auteurId;

  @override
  bool validate() =>
      titre.isNotEmpty && categorieId != null && auteurId != null;

  @override
  Future<void> save() async {
    final data = {
      'libelle': titre,
      'description': description,
      'auteur_id': auteurId,
      'categorie_id': categorieId,
    };
    print('--- Insertion Livre ---');
    print('Données: $data');
    await DatabaseHelper().insertLivre(data);
    print('Livre inséré avec succès');
  }
}

class CategorieEditionController extends EditionController {
  String libelle = '';

  @override
  bool validate() => libelle.isNotEmpty;

  @override
  Future<void> save() async {
    final data = {'libelle': libelle};
    print('--- Insertion Catégorie ---');
    print('Données: $data');
    await DatabaseHelper().insertCategorie(data);
    print('Catégorie insérée avec succès');
  }
}

class AuteurEditionController extends EditionController {
  String nom = '';
  String prenoms = '';
  String email = '';

  @override
  bool validate() => nom.isNotEmpty && prenoms.isNotEmpty;

  @override
  Future<void> save() async {
    final data = {'nom': nom, 'prenoms': prenoms, 'email': email};
    print('--- Insertion Auteur ---');
    print('Données: $data');
    await DatabaseHelper().insertAuteur(data);
    print('Auteur inséré avec succès');
  }
}
