import 'package:bibliotheca/controllers/edition_controller.dart';
import 'package:bibliotheca/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class EditionAuteur extends StatefulWidget {
  const EditionAuteur({super.key});
  @override
  State<EditionAuteur> createState() => _EditionAuteurState();
}

class _EditionAuteurState extends State<EditionAuteur> {
  final _formKey = GlobalKey<FormState>();
  final _controller = AuteurEditionController();
  final _nomCtrl = TextEditingController();
  final _prenomsCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _controller.nom = _nomCtrl.text;
      _controller.prenoms = _prenomsCtrl.text;
      _controller.email = _emailCtrl.text;
      print(
        '--- Sauvegarde Auteur: ${_controller.prenoms} ${_controller.nom} ---',
      );
      await _controller.save();
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
          FormTextField(
            controller: _nomCtrl,
            label: "Nom",
            validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
          ),
          FormTextField(
            controller: _prenomsCtrl,
            label: "Prénoms",
            validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
          ),
          FormTextField(controller: _emailCtrl, label: "Email"),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
        ],
      ),
    ),
  );
}
