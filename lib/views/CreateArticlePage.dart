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
      print('❌ Veuillez sélectionner une couleur, une pointure et une quantité.');
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

  Future<void> submitArticle() async {
    if (articleForm.ref.isNotEmpty &&
        articleForm.name.isNotEmpty &&
        articleForm.prixFournisseur > 0 &&
        articleForm.prixVente > 0 &&
        selectedPhotos.isNotEmpty &&
        articleStocks.isNotEmpty &&
        articleForm.description.isNotEmpty &&
        articleForm.statut.isNotEmpty) {
      articleForm.stocks = articleStocks;

      // Call the service to create the article
      final result = await articleService.create(articleForm); // Change to the correct method

      if (result > 0) {  // Check if the result is a valid ID (greater than 0)
        Navigator.pushNamed(context, '/articles');
      } else {
        print('❌ Échec de la création');
      }
    } else {
      print('❌ Veuillez remplir tous les champs obligatoires');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un article")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
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
              onChanged: (value) => articleForm.description = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Prix fournisseur'),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  articleForm.prixFournisseur = double.tryParse(value) ?? 0,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Prix de vente'),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  articleForm.prixVente = double.tryParse(value) ?? 0,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Statut'),
              onChanged: (value) => articleForm.statut = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tissu'),
              onChanged: (value) => articleForm.tissu = value,
            ),
            DropdownButtonFormField<Category>(
              decoration: InputDecoration(labelText: 'Catégorie'),
              value: allCategories.isNotEmpty ? allCategories[0] : null,
              items: allCategories
                  .map((category) => DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) =>articleForm.category = value?.name

            ),
            ElevatedButton(
              onPressed: generateStock,
              child: Text("Ajouter Stock"),
            ),
            ElevatedButton(
              onPressed: submitArticle,
              child: Text("Créer l'article"),
            ),
          ],
        ),
      ),
    );
  }
}
