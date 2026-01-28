import 'package:bibliotheca/views/edition_auteur.dart';
import 'package:bibliotheca/controllers/list_controller.dart';
import 'package:flutter/material.dart';

class ListeAuteur extends StatefulWidget {
  const ListeAuteur({super.key});
  @override
  State<ListeAuteur> createState() => _ListeAuteurState();
}

class _ListeAuteurState extends State<ListeAuteur> {
  final _controller = AuteurController();

  @override
  void initState() {
    super.initState();
    _controller.loadItems(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Liste des auteurs"),
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
        MaterialPageRoute(builder: (_) => const EditionAuteur()),
      ).then((_) => _controller.loadItems(() => setState(() {}))),
    ),
    body: _controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : _controller.items.isEmpty
        ? const Center(child: Text("Aucun auteur."))
        : ListView.builder(
            itemCount: _controller.items.length,
            itemBuilder: (context, i) {
              final item = _controller.items[i];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  "${item['prenoms'] ?? ''} ${item['nom'] ?? ''}".trim(),
                ),
                subtitle: Text(item['email'] ?? ''),
              );
            },
          ),
  );
}
