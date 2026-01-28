import 'package:bibliotheca/views/liste_auteur.dart';
import 'package:bibliotheca/views/liste_categorie.dart';
import 'package:bibliotheca/views/liste_livre.dart';
import 'package:bibliotheca/widgets/menu_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigate(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Bienvenue sur Bibliotheca")),
    body: GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      children: [
        MenuTile(
          icon: Icons.book,
          label: "Livres",
          onTap: () => _navigate(const ListeLivrePage()),
        ),
        MenuTile(
          icon: Icons.category,
          label: "Catégories",
          onTap: () => _navigate(const ListeCategorie()),
        ),
        MenuTile(
          icon: Icons.person,
          label: "Auteurs",
          onTap: () => _navigate(const ListeAuteur()),
        ),
      ],
    ),
  );
}
