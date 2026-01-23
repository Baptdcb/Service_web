import 'package:bibliotheca/models/database/dao.dart';
import 'package:flutter/material.dart';

class EditionAuteur extends StatefulWidget {
  const EditionAuteur({Key? key}) : super(key: key);
  @override
  State<EditionAuteur> createState() => _EditionAuteurState();
}

class _EditionAuteurState extends State<EditionAuteur> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().insertAuteur({
        'nom': _nomController.text,
        'prenoms': _prenomsController.text,
        'email': _emailController.text,
      });
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Edition d'auteur")),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _nomController,
            decoration: const InputDecoration(labelText: "Nom"),
            validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
          ),
          TextFormField(
            controller: _prenomsController,
            decoration: const InputDecoration(labelText: "Prénoms"),
            validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
        ],
      ),
    ),
  );
}
