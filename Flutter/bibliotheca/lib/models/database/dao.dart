import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;
  // Accès à la base de données SQLite
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialisation de la base de données SQLite
  _initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Création des tables
  _onCreate(Database db, int version) async {
    await db.execute('''
 CREATE TABLE categorie (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 libelle TEXT NOT NULL
 )
 ''');
    await db.execute('''
 CREATE TABLE auteur (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 nom TEXT NOT NULL,
 prenoms TEXT NOT NULL,
 email TEXT
 )
 ''');
    await db.execute('''
 CREATE TABLE livre (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 libelle TEXT NOT NULL,
 description TEXT,
 auteur_id INTEGER NOT NULL,
 categorie_id INTEGER NOT NULL
 )
 ''');
  }

  // Insérer une catégorie dans la base de données locale
  Future<void> insertCategorie(Map<String, dynamic> categorie) async {
    final db = await database;
    await db.insert(
      'categorie',
      categorie,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer toutes les catégories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return db.query('categorie');
  }

  // Insérer un auteur
  Future<void> insertAuteur(Map<String, dynamic> auteur) async {
    final db = await database;
    await db.insert(
      'auteur',
      auteur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer tous les auteurs
  Future<List<Map<String, dynamic>>> getAuteurs() async {
    final db = await database;
    return db.query('auteur');
  }

  // Insérer un livre
  Future<void> insertLivre(Map<String, dynamic> livre) async {
    final db = await database;
    await db.insert(
      'livre',
      livre,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer tous les livres
  Future<List<Map<String, dynamic>>> getLivres() async {
    final db = await database;
    return db.query('livre');
  }
}
