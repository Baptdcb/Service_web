import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:first_app_flutter/models/categorie.dart';

class Dao {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bibliotheca.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, libelle TEXT)',
        );
      },
    );
  }

  static Future<Categorie> createCategorie(Categorie cat) async {
    final db = await database;
    // Remove id from manual map if you want autoincrement to generate it, 
    // though toJson includes it. SQLite ignores null primary key on insert usually 
    // or we can remove it.
    var map = cat.toJson();
    if (map['id'] == null) {
      map.remove('id');
    }
    
    cat.id = await db.insert('categories', map);
    return cat;
  }

  static Future<void> updateCategorie(Categorie cat) async {
    final db = await database;
    await db.update(
      'categories',
      cat.toJson(),
      where: 'id = ?',
      whereArgs: [cat.id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Categorie>> listeCategorie() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Categorie.fromJson(maps[i]);
    });
  }
}
