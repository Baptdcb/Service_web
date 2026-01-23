import 'package:bibliotheca/models/database/dao.dart';
import 'package:flutter/material.dart';

class EditionCategorie extends StatefulWidget {
  const EditionCategorie({Key? key}) : super(key: key);
  @override
  State<EditionCategorie> createState() => _EditionCategorieState();
}

class _EditionCategorieState extends State<EditionCategorie> {
  final _formKey = GlobalKey<FormState>();
  final _libelleController = TextEditingController();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().insertCategorie({
        'libelle': _libelleController.text,
      });
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Edition de catégorie")),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _libelleController,
            decoration: const InputDecoration(labelText: "Nom catégorie"),
            validator: (value) =>
                value == null || value.isEmpty ? 'Champs requis' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
        ],
      ),
    ),
  );
}
