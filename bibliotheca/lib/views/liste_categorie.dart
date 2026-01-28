import 'package:bibliotheca/views/edition_categorie.dart';
import 'package:bibliotheca/controllers/list_controller.dart';
import 'package:flutter/material.dart';

class ListeCategorie extends StatefulWidget {
  const ListeCategorie({super.key});
  @override
  State<ListeCategorie> createState() => _ListeCategorieState();
}

class _ListeCategorieState extends State<ListeCategorie> {
  final _controller = CategorieController();

  @override
  void initState() {
    super.initState();
    _controller.loadItems(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Liste des catégories"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _controller.refresh(() => setState(() {})),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditionCategorie()),
      ).then((_) => _controller.loadItems(() => setState(() {}))),
    ),
    body: _controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : _controller.items.isEmpty
        ? const Center(child: Text("Aucune catégorie."))
        : ListView.builder(
            itemCount: _controller.items.length,
            itemBuilder: (context, i) => ListTile(
              leading: const Icon(Icons.category),
              title: Text(_controller.items[i]['libelle'] ?? ''),
            ),
          ),
  );
}
