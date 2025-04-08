import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sabat_sfakys/models/Article.dart';
import 'package:sabat_sfakys/models/couleur.dart';
import 'package:sabat_sfakys/models/pointure.dart';

class ArticleService {
  final String apiUrl = 'http://localhost:8080/article';

  // Fetch a list of articles
  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  // Method to create an article
  Future<int> create(Article article) async {
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
      body: json.encode(article.toJson()), // Make sure the article has a `toJson` method
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      // Assuming the backend returns an ID or success status in the response body
      return json.decode(response.body)['id'];  // Assuming the API returns the ID of the created article
    } else {
      throw Exception('Failed to create article');
    }
  }

  // Fetch list of colors
  Future<List<Couleur>> getCouleurs() async {
    final response = await http.get(Uri.parse('http://localhost:8080/couleurs'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Couleur.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des couleurs');
    }
  }

  // Fetch list of sizes (Pointure)
  Future<List<Pointure>> getPointures() async {
    final response = await http.get(Uri.parse('http://localhost:8080/pointures'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Pointure.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des pointures');
    }
  }
}
