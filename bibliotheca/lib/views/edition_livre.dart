import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/controllers/edition_controller.dart';
import 'package:bibliotheca/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class EditionLivre extends StatefulWidget {
  const EditionLivre({super.key});
  @override
  State<EditionLivre> createState() => _EditionLivreState();
}

class _EditionLivreState extends State<EditionLivre> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LivreEditionController();
  final _titreCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
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
      _controller.titre = _titreCtrl.text;
      _controller.description = _descCtrl.text;
      print('Catégorie sélectionnée: ${_controller.categorieId}');
      print('Auteur sélectionné: ${_controller.auteurId}');
      await _controller.save();
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
          FormTextField(
            controller: _titreCtrl,
            label: "Titre du livre",
            validator: (v) => v!.isEmpty ? 'Requis' : null,
          ),
          DropdownButtonFormField<int>(
            value: _controller.categorieId,
            items: _categories
                .map(
                  (cat) => DropdownMenuItem<int>(
                    value: cat['id'],
                    child: Text(cat['libelle'] ?? ''),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _controller.categorieId = value),
            decoration: const InputDecoration(labelText: "Catégorie"),
            validator: (v) => v == null ? 'Requis' : null,
          ),
          DropdownButtonFormField<int>(
            value: _controller.auteurId,
            items: _auteurs
                .map(
                  (aut) => DropdownMenuItem<int>(
                    value: aut['id'],
                    child: Text("${aut['prenoms']} ${aut['nom']}"),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _controller.auteurId = value),
            decoration: const InputDecoration(labelText: "Auteur"),
            validator: (v) => v == null ? 'Requis' : null,
          ),
          FormTextField(
            controller: _descCtrl,
            label: "Description du livre",
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
        ],
      ),
    ),
  );
}
