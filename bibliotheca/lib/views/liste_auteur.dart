import 'package:bibliotheca/views/edition_auteur.dart';
import 'package:flutter/material.dart';
import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/models/database/sync_database.dart';

class ListeAuteur extends StatefulWidget {
  const ListeAuteur({Key? key}) : super(key: key);
  @override
  State<ListeAuteur> createState() => _ListeAuteurState();
}

class _ListeAuteurState extends State<ListeAuteur> {
  List<Map<String, dynamic>> _auteurs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerAuteurs();
  }

  Future<void> _chargerAuteurs() async {
    setState(() => _isLoading = true);
    try {
      final data = await DatabaseHelper().getAuteurs();
      setState(() {
        _auteurs = data;
      });
    } catch (e) {
      debugPrint("Erreur auteurs: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _rafraichir() async {
    await synchronize();
    await _chargerAuteurs();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Liste des auteurs"),
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _rafraichir),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditionAuteur()),
        ).then((_) => _chargerAuteurs());
      },
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _auteurs.isEmpty
        ? const Center(child: Text("Aucun auteur."))
        : ListView.builder(
            itemCount: _auteurs.length,
            itemBuilder: (context, i) {
              final item = _auteurs[i];
              final nom = item['nom'] ?? '';
              final prenoms = item['prenoms'] ?? '';
              final email = item['email'] ?? '';
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text("$prenoms $nom".trim()),
                subtitle: Text(email),
                onTap: () {},
              );
            },
          ),
  );
}
