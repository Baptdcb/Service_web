import 'package:bibliotheca/views/edition_livre.dart';
import 'package:bibliotheca/controllers/list_controller.dart';
import 'package:flutter/material.dart';

class ListeLivrePage extends StatefulWidget {
  const ListeLivrePage({super.key});
  @override
  State<ListeLivrePage> createState() => _ListeLivrePageState();
}

class _ListeLivrePageState extends State<ListeLivrePage> {
  final _controller = LivreController();

  @override
  void initState() {
    super.initState();
    _controller.loadItems(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Liste des livres"),
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
        MaterialPageRoute(builder: (_) => const EditionLivre()),
      ).then((_) => _controller.loadItems(() => setState(() {}))),
    ),
    body: _controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : _controller.items.isEmpty
        ? const Center(child: Text("Aucun livre trouvé."))
        : ListView.builder(
            itemCount: _controller.items.length,
            itemBuilder: (context, i) => ListTile(
              leading: const Icon(Icons.book),
              title: Text(_controller.items[i]['libelle'] ?? 'Sans titre'),
              subtitle: Text(_controller.items[i]['description'] ?? ''),
            ),
          ),
  );
}
