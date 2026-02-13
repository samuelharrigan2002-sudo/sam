import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:   const akey(), // La première page qui s'affiche
    );
  }
}

class Produit {
  final String nom;
  final String image;
  final double prix;
  Produit({required this.nom, required this.image, required this.prix});
}
//-------------- paj akey---------------------
class akey extends StatelessWidget {
  const akey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const produitpaj(),
    );
  }
}
class produitpaj extends StatefulWidget {
  const produitpaj({super.key});

  @override
  State<produitpaj> createState() => _produitpajState();
}
class _produitpajState extends State<produitpaj> {
  // Liste de produits
  final List<Produit> produits = [
    Produit(nom: "Casque VR", image: "https://picsum.photos/id/1/200/200", prix: 350.00),
    Produit(nom: "Souris Gamer", image: "https://picsum.photos/id/2/200/200", prix: 25.00),
    Produit(nom: "Clavier RGB", image: "https://picsum.photos/id/3/200/200", prix: 120.00),
    Produit(nom: "Écran 4K", image: "https://picsum.photos/id/4/200/200", prix: 450.00),
  ];

  final Set<int> _likes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("EBoutikoo", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(child: Text("EBoutikoo", style: TextStyle(color: Colors.white, fontSize: 24)))
          ),
          ListTile(title: const Text("Konekte"), onTap: () {}),
          ListTile(title: const Text("Lis Pwodui"), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const lispwo()),);}),
          ListTile(title: const Text("Dekonekte"), onTap: () {}),
        ]),
      ),
      // --- 3. STRUCTURE MIXTE (SLIVERS) ---
      body: CustomScrollView(
        slivers: [
          // A. Les 2 premiers produits en pleine largeur (SliverList)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildProductCard(index, isFullWidth: true),
              childCount: produits.length >= 2 ? 2 : produits.length,
            ),
          ),
          // B. Le reste en grille de 2 (SliverGrid)
          if (produits.length > 2)
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8, // Ajusté pour le format carré
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProductCard(index + 2),
                  childCount: produits.length - 2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- 4. LE CASIER (WIDGET D'AFFICHAGE) ---
  Widget _buildProductCard(int index, {bool isFullWidth = false}) {
    final p = produits[index];

    return GestureDetector(
      onTap: () {
        // Navigation vers les détails
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(produit: p)));
      },
      child: Card(
        margin: isFullWidth ? const EdgeInsets.all(10) : EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE DU PRODUIT
            Image.network(
                p.image,
                height: isFullWidth ? 200 : 120, // Hauteur adaptable
                width: double.infinity,
                fit: BoxFit.cover
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text("${p.prix} \$", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),

                  // BOUTONS SOUS LE PRIX
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                            _likes.contains(index) ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red
                        ),
                        onPressed: () => setState(() {
                          _likes.contains(index) ? _likes.remove(index) : _likes.add(index);
                        }),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.add_shopping_cart, color: Colors.blue, size: 24),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. PAGE DE DÉTAILS ---
class DetailsPage extends StatelessWidget {
  final Produit produit;
  const DetailsPage({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produit.nom),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centre les éléments horizontalement
            children: [
              // --- SECTION IMAGE ---
              // On place l'image dans un Container avec une taille fixe (Carré)
              Center(
                child: Container(
                  width: 250, // Largeur fixe
                  height: 250, // Hauteur fixe pour faire un carré
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      produit.image,
                      fit: BoxFit.cover, // L'image remplit le carré sans déformation
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- SECTION INFOS ---
              Text(
                produit.nom,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "${produit.prix} \$",
                style: const TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
              ),

              const Divider(height: 40, thickness: 1),

              const Text(
                "Description du produit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ce produit de haute qualité est disponible sur EBoutikoo. "
                    "Profitez d'une livraison rapide et d'une garantie exceptionnelle.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),

              const SizedBox(height: 40),

              // --- BOUTON D'ACTION ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Action d'achat ou ajout au panier
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text("Acheter maintenant", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ------------------ paj produi------------------
class lispwo extends StatefulWidget {
  const lispwo({super.key});

  @override
  State<lispwo> createState() => _lispwoState();
}
class _lispwoState extends State<lispwo> {
  // Liste de produits
  final List<Produit> produits = [
    Produit(nom: "Casque VR", image: "https://picsum.photos/id/1/200/200", prix: 350.00),
    Produit(nom: "Souris Gamer", image: "https://picsum.photos/id/2/200/200", prix: 25.00),
    Produit(nom: "Clavier RGB", image: "https://picsum.photos/id/3/200/200", prix: 120.00),
    Produit(nom: "Écran 4K", image: "https://picsum.photos/id/4/200/200", prix: 450.00),
  ];

  final Set<int> _likes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Lis Pwodui", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // --- GRILLE DE PRODUITS (2 colonnes) ---
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        // SliverGridDelegateWithFixedCrossAxisCount permet de définir le nombre de colonnes
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 éléments par ligne
          crossAxisSpacing: 10, // Espace horizontal entre les carrés
          mainAxisSpacing: 10, // Espace vertical entre les carrés
          childAspectRatio: 0.75, // Ajuste la hauteur des carrés (largeur / hauteur)
        ),
        itemCount: produits.length,
        itemBuilder: (context, index) {
          final p = produits[index];
          final isLiked = _likes.contains(index);

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. IMAGE (Prend le haut du carré)
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(p.image, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                // 2. INFOS (Nom et Prix)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${p.prix} \$", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),

                      // 3. BOUTONS (En dessous du prix)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Bouton Like
                          IconButton(
                            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey),
                            onPressed: () => setState(() => isLiked ? _likes.remove(index) : _likes.add(index)),
                          ),
                          // Bouton Panier
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


