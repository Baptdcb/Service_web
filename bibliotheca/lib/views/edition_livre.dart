import 'package:bibliotheca/models/database/dao.dart';
import 'package:flutter/material.dart';

class EditionLivre extends StatefulWidget {
  const EditionLivre({Key? key}) : super(key: key);
  @override
  State<EditionLivre> createState() => _EditionLivreState();
}

class _EditionLivreState extends State<EditionLivre> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedCategorieId;
  int? _selectedAuteurId;

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _auteurs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cats = await DatabaseHelper().getCategories();
    final auts = await DatabaseHelper().getAuteurs();
    setState(() {
      _categories = cats;
      _auteurs = auts;
    });
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().insertLivre({
        'libelle': _titreController.text,
        'description': _descriptionController.text,
        'auteur_id': _selectedAuteurId,
        'categorie_id': _selectedCategorieId,
      });
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Edition de livre")),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          MaterialButton(
            onPressed: () {},
            child: const CircleAvatar(radius: 50, child: Icon(Icons.book)),
          ),
          TextFormField(
            controller: _titreController,
            decoration: const InputDecoration(labelText: "Titre du livre"),
            validator: (v) => v!.isEmpty ? 'Requis' : null,
          ),
          DropdownButtonFormField<int>(
            value: _selectedCategorieId,
            items: _categories.map((cat) {
              return DropdownMenuItem<int>(
                value: cat['id'],
                child: Text(cat['libelle'] ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategorieId = value;
              });
            },
            decoration: const InputDecoration(labelText: "Catégorie"),
            validator: (v) => v == null ? 'Requis' : null,
          ),
          DropdownButtonFormField<int>(
            value: _selectedAuteurId,
            items: _auteurs.map((aut) {
              return DropdownMenuItem<int>(
                value: aut['id'],
                child: Text("${aut['prenoms']} ${aut['nom']}"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAuteurId = value;
              });
            },
            decoration: const InputDecoration(labelText: "Auteur"),
            validator: (v) => v == null ? 'Requis' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Description du livre",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
        ],
      ),
    ),
  );
}
