import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* =======================
   APPLICATION
======================= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter IHM',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage(),
    );
  }
}

/* =======================
   PAGE 1 - ACCUEIL
======================= */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page d'accueil"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Aller à la page IHM"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: "Flutter IHM")),
            );
          },
        ),
      ),
    );
  }
}

/* =======================
   PAGE 2 - IHM COMPLETE
======================= */
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* ----- Like ----- */
  bool _likeBool = false;

  /* ----- BottomNavigationBar ----- */
  int _selectedIndex = 0;

  /* ----- Contenus centraux ----- */
  final List<Widget> _pages = [
    const Center(child: Text("Accueil", style: TextStyle(fontSize: 22))),
    const Center(child: Text("Profil", style: TextStyle(fontSize: 22))),
    const Center(child: Text("Paramètres", style: TextStyle(fontSize: 22))),
  ];

  void _itemClique(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _likeThis() {
    setState(() {
      _likeBool = !_likeBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* ----- APPBAR ----- */
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              _likeBool ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _likeThis,
          )
        ],
      ),

      /* ----- DRAWER ----- */
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Accueil"),
              onTap: () {
                _itemClique(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              onTap: () {
                _itemClique(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Paramètres"),
              onTap: () {
                _itemClique(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      /* ----- BODY ----- */
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),

          /* ----- IMAGES ----- */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/flutter.png',
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
              height: 120,
            ),
          ),

          /* ----- BOUTON NAVIGATION ----- */
          ElevatedButton(
            child: const Text("Retour"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      /* ----- FLOATING ACTION BUTTON ----- */
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      /* ----- BOTTOM NAVIGATION BAR ----- */
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _itemClique,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
        ],
      ),
    );
  }
}
