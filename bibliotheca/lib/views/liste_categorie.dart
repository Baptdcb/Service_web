import 'package:bibliotheca/views/edition_categorie.dart';
import 'package:flutter/material.dart';
import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/models/database/sync_database.dart';

class ListeCategorie extends StatefulWidget {
  const ListeCategorie({Key? key}) : super(key: key);
  @override
  State<ListeCategorie> createState() => _ListeCategorieState();
}

class _ListeCategorieState extends State<ListeCategorie> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerCategories();
  }

  Future<void> _chargerCategories() async {
    setState(() => _isLoading = true);
    try {
      final data = await DatabaseHelper().getCategories();
      setState(() {
        _categories = data;
      });
    } catch (e) {
      debugPrint("Erreur catégories: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _rafraichir() async {
    await synchronize();
    await _chargerCategories();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Liste des catégories"),
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _rafraichir),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditionCategorie()),
        ).then((_) => _chargerCategories());
      },
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _categories.isEmpty
        ? const Center(child: Text("Aucune catégorie."))
        : ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, i) => ListTile(
              leading: const Icon(Icons.category),
              title: Text(_categories[i]['libelle'] ?? ''),
              onTap: () {},
            ),
          ),
  );
}
