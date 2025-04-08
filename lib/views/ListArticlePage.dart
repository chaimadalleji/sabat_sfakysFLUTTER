import 'package:flutter/material.dart';
import 'package:sabat_sfakys/services/ArticleService.dart';
import 'package:sabat_sfakys/models/Article.dart';
import 'package:sabat_sfakys/services/PanierService.dart';

class ListArticlePage extends StatefulWidget {
  @override
  _ListArticlePageState createState() => _ListArticlePageState();
}

class _ListArticlePageState extends State<ListArticlePage> {
  List<Article> allArticles = [];
  String selectedCouleur = '';
  String selectedPointure = '';

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  fetchArticles() async {
    final articles = await ArticleService().getArticles();
    setState(() {
      allArticles = articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des Articles')),
      body: ListView.builder(
        itemCount: allArticles.length,
        itemBuilder: (context, index) {
          final article = allArticles[index];
          return ListTile(
            title: Text(article.name),
            subtitle: Text(article.description),
            onTap: () => ouvrirModal(article),
          );
        },
      ),
    );
  }

  ouvrirModal(Article article) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(article.name),
          content: Column(
            children: [
              Text('Sélectionner Couleur: $selectedCouleur'),
              Text('Sélectionner Pointure: $selectedPointure'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Ajouter au panier
                PanierService().ajouterAuPanier(article);
                Navigator.pop(context);
              },
              child: Text('Ajouter au Panier'),
            ),
          ],
        );
      },
    );
  }
}
