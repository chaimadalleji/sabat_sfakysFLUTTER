import 'package:flutter/material.dart';
import 'package:sabat_sfakys/models/Article.dart';
import 'package:sabat_sfakys/models/category.dart';
import 'package:sabat_sfakys/models/couleur.dart';
import 'package:sabat_sfakys/models/photo.dart';
import 'package:sabat_sfakys/models/pointure.dart';
import 'package:sabat_sfakys/services/ArticleService.dart';
import 'package:sabat_sfakys/services/category_service.dart';
import 'package:sabat_sfakys/services/photo_service.dart';
import 'package:sabat_sfakys/services/token_service.dart';


class CreateArticlePage extends StatefulWidget {
  @override
  _CreateArticlePageState createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final ArticleService articleService = ArticleService();
  final CategoryService categoryService = CategoryService();
  final PhotoService photoService = PhotoService();
  final TokenService tokenService = TokenService();

  List<Photo> allPhotos = [];
  List<Photo> selectedPhotos = [];
  List<Category> allCategories = [];
  List<Couleur> couleursDisponibles = [];
  List<Pointure> pointuresDisponibles = [];
  List<Stock> articleStocks = [];

  Couleur? selectedCouleur;
  Pointure? selectedPointure;
  int quantite = 0;

  Article articleForm = Article.initial();

  final List<String> genreOptions = ['Homme', 'Femme', 'Enfant', 'Unisexe'];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = await TokenService.getUser();
    if (user != null && user['email'] != null) {
      setState(() {
        articleForm.fournisseurEmail = user['email']; // ✅ Correct
      });
    }

    couleursDisponibles = await articleService.getCouleurs();
    pointuresDisponibles = await articleService.getPointures();
    allPhotos = await photoService.getAllPhotos();
    allCategories = await categoryService.getAllCategories();

    setState(() {}); // Pour actualiser l'UI avec les données chargées
  }

  void generateStock() {
    if (selectedCouleur != null && selectedPointure != null && quantite > 0) {
      final stock = Stock(
        id: 0,
        couleur: selectedCouleur!,
        pointure: selectedPointure!,
        quantite: quantite,
      );
      setState(() {
        articleStocks.add(stock);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Veuillez sélectionner une couleur, une pointure et une quantité.'))
      );
    }
  }

  void togglePhotoSelection(Photo photo) {
    setState(() {
      if (selectedPhotos.contains(photo)) {
        selectedPhotos.remove(photo);
      } else {
        selectedPhotos.add(photo);
      }

      // Correction ici : on assigne seulement les URLs (ou chemins)
      articleForm.photos = selectedPhotos.map((p) => p.name).toList();
    });
  }

  /*Future<void> submitArticle() async {
    if (articleForm.ref.isNotEmpty &&
        articleForm.name.isNotEmpty &&
        articleForm.prixFournisseur > 0 &&
        articleForm.prixVente > 0 &&
        selectedPhotos.isNotEmpty &&
        articleStocks.isNotEmpty &&
        articleForm.description.isNotEmpty &&
        articleForm.statut.isNotEmpty &&
        articleForm.genre.isNotEmpty) {
      articleForm.stocks = articleStocks;

      // Call the service to create the article
      final result = await articleService.create(articleForm);

      if (result > 0) {  // Check if the result is a valid ID (greater than 0)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Article créé avec succès!'))
        );
        Navigator.pushNamed(context, '/articles');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Échec de la création'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Veuillez remplir tous les champs obligatoires'))
      );
    }
  }*/
Future<void> submitArticle() async {
  if (articleForm.ref.isNotEmpty &&
      articleForm.name.isNotEmpty &&
      articleForm.prixFournisseur > 0 &&
      articleForm.prixVente > 0 &&
      // Suppression de la condition selectedPhotos.isNotEmpty
      articleStocks.isNotEmpty &&
      articleForm.description.isNotEmpty &&
      articleForm.statut.isNotEmpty &&
      articleForm.genre.isNotEmpty) {
    articleForm.stocks = articleStocks;

    // Call the service to create the article
    final result = await articleService.create(articleForm);

    if (result > 0) {  // Check if the result is a valid ID (greater than 0)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Article créé avec succès!'))
      );
      Navigator.pushNamed(context, '/articles');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Échec de la création'))
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Veuillez remplir tous les champs obligatoires'))
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un article")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section d'informations basiques
            Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informations de base', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(labelText: 'Référence'),
                      onChanged: (value) => articleForm.ref = value,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Nom'),
                      onChanged: (value) => articleForm.name = value,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      onChanged: (value) => articleForm.description = value,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Genre'),
                      value: articleForm.genre.isEmpty ? null : articleForm.genre,
                      items: genreOptions.map((genre) => DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            articleForm.genre = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Section des prix
            Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informations de prix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Prix fournisseur',
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          articleForm.prixFournisseur = double.tryParse(value) ?? 0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Prix de vente',
                        prefixIcon: Icon(Icons.sell),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          articleForm.prixVente = double.tryParse(value) ?? 0,
                    ),
                  ],
                ),
              ),
            ),

            // Section de catégorie et statut
            Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catégorie et détails', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    DropdownButtonFormField<Category>(
                      decoration: InputDecoration(
                        labelText: 'Catégorie',
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: allCategories.isNotEmpty ? null : null,
                      hint: Text('Sélectionner une catégorie'),
                      items: allCategories
                          .map((category) => DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            articleForm.category = value.name;
                          });
                        }
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Statut',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      onChanged: (value) => articleForm.statut = value,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Tissu',
                        prefixIcon: Icon(Icons.texture),
                      ),
                      onChanged: (value) => articleForm.tissu = value,
                    ),
                  ],
                ),
              ),
            ),

            // Section de gestion des stocks
            Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gestion des stocks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    DropdownButtonFormField<Couleur>(
                      decoration: InputDecoration(
                        labelText: 'Couleur',
                        prefixIcon: Icon(Icons.color_lens),
                      ),
                      value: selectedCouleur,
                      hint: Text('Sélectionner une couleur'),
                      items: couleursDisponibles
                          .map((couleur) => DropdownMenuItem<Couleur>(
                                value: couleur,
                                child: Text(couleur.nom),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCouleur = value;
                        });
                      },
                    ),
                    DropdownButtonFormField<Pointure>(
                      decoration: InputDecoration(
                        labelText: 'Pointure',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      value: selectedPointure,
                      hint: Text('Sélectionner une pointure'),
                      items: pointuresDisponibles
                          .map((pointure) => DropdownMenuItem<Pointure>(
                                value: pointure,
                                // Correction ici: utilisation de taille au lieu de valeur
                                child: Text(pointure.taille.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPointure = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantité',
                        prefixIcon: Icon(Icons.inventory),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => quantite = int.tryParse(value) ?? 0,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Ajouter au stock"),
                      onPressed: generateStock,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    Text('Stocks ajoutés:', style: TextStyle(fontWeight: FontWeight.bold)),
                    articleStocks.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Aucun stock ajouté pour l\'instant', 
                              style: TextStyle(fontStyle: FontStyle.italic))
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: articleStocks.length,
                            itemBuilder: (context, index) {
                              final stock = articleStocks[index];
                              return ListTile(
                                // Correction ici: utilisation de taille au lieu de valeur
                                title: Text('${stock.couleur.nom} - Pointure ${stock.pointure.taille}'),
                                subtitle: Text('Quantité: ${stock.quantite}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      articleStocks.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),

           // Section de sélection des photos
Card(
  margin: EdgeInsets.only(bottom: 16),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos de l\'article', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Photos sélectionnées: ${selectedPhotos.length}'),
        SizedBox(height: 8),
        Container(
          height: 150,
          
          child: allPhotos.isEmpty
              ? Center(child: Text('Aucune photo disponible'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = allPhotos[index];
                    final isSelected = selectedPhotos.contains(photo);
                    // Construire l'URL complète pour l'image
                    final imageUrl = 'http://localhost:8080/upload/${photo.name}';
                    
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => togglePhotoSelection(photo),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: isSelected ? 3 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  imageUrl, // Utiliser l'URL complète ici
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.broken_image, size: 40),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  ),
),

            // Bouton de soumission
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Créer l'article", style: TextStyle(fontSize: 16)),
              onPressed: submitArticle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}