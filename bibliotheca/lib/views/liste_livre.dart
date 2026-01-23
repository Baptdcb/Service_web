import 'package:bibliotheca/views/edition_livre.dart';
import 'package:flutter/material.dart';
import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/models/database/sync_database.dart';

class ListeLivrePage extends StatefulWidget {
  const ListeLivrePage({Key? key}) : super(key: key);
  @override
  State<ListeLivrePage> createState() => _ListeLivrePageState();
}

class _ListeLivrePageState extends State<ListeLivrePage> {
  List<Map<String, dynamic>> _livres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerLivres();
  }

  Future<void> _chargerLivres() async {
    setState(() => _isLoading = true);
    try {
      final livres = await DatabaseHelper().getLivres();
      setState(() {
        _livres = livres;
      });
    } catch (e) {
      debugPrint('Erreur chargement livres: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _rafraichirDonnees() async {
    await synchronize();
    await _chargerLivres();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Liste des livres"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _rafraichirDonnees,
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditionLivre()),
        ).then((_) => _chargerLivres());
      },
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _livres.isEmpty
        ? const Center(child: Text("Aucun livre trouvé."))
        : ListView.builder(
            itemCount: _livres.length,
            itemBuilder: (context, i) {
              final item = _livres[i];
              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(item['libelle'] ?? 'Sans titre'),
                subtitle: Text(item['description'] ?? ''),
                onTap: () {},
              );
            },
          ),
  );
}
