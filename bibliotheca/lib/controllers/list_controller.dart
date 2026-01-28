import 'package:flutter/material.dart';
import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/models/database/sync_database.dart';

abstract class ListController<T> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> fetchData();

  Future<void> loadItems(VoidCallback setState) async {
    isLoading = true;
    setState();
    try {
      items = await fetchData();
    } catch (e) {
      debugPrint('Erreur: $e');
    } finally {
      isLoading = false;
      setState();
    }
  }

  Future<void> refresh(VoidCallback setState) async {
    await synchronize();
    await loadItems(setState);
  }
}

class LivreController extends ListController {
  @override
  Future<List<Map<String, dynamic>>> fetchData() =>
      DatabaseHelper().getLivres();
}

class CategorieController extends ListController {
  @override
  Future<List<Map<String, dynamic>>> fetchData() =>
      DatabaseHelper().getCategories();
}

class AuteurController extends ListController {
  @override
  Future<List<Map<String, dynamic>>> fetchData() =>
      DatabaseHelper().getAuteurs();
}
