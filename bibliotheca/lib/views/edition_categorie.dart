import 'package:bibliotheca/controllers/edition_controller.dart';
import 'package:bibliotheca/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class EditionCategorie extends StatefulWidget {
  const EditionCategorie({super.key});
  @override
  State<EditionCategorie> createState() => _EditionCategorieState();
}

class _EditionCategorieState extends State<EditionCategorie> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CategorieEditionController();
  final _libelleCtrl = TextEditingController();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _controller.libelle = _libelleCtrl.text;
      print('--- Sauvegarde Catégorie: "${_controller.libelle}" ---');
      await _controller.save();
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
          FormTextField(
            controller: _libelleCtrl,
            label: "Nom catégorie",
            validator: (v) => v == null || v.isEmpty ? 'Champs requis' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
        ],
      ),
    ),
  );
}
