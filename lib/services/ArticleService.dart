import 'package:dio/dio.dart';
import 'package:sabat_sfakys/models/Article.dart';
import 'package:sabat_sfakys/models/couleur.dart';
import 'package:sabat_sfakys/models/pointure.dart';
import 'token_service.dart'; // Service pour stocker et récupérer le token

class ArticleService {
  final String baseUrl = 'http://localhost:8080';
  late Dio dio;

  ArticleService() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: "application/json",
    ));
    _setupInterceptor();
  }

  // Configuration de l'intercepteur pour ajouter automatiquement le token
  void _setupInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await TokenService.getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          print("📤 Requête envoyée : ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("📥 Réponse reçue : ${response.statusCode}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("🚨 Erreur HTTP : ${e.response?.statusCode} - ${e.message}");
          // Si on reçoit une erreur 403 Forbidden, cela signifie probablement que le token est invalide
          if (e.response?.statusCode == 403) {
            print("⚠️ Accès refusé. Vérifiez que votre token est valide.");
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Fetch a list of articles
  Future<List<Article>> getArticles() async {
    try {
      final response = await dio.get('/article');
      final List<dynamic> data = response.data;
      return data.map((article) => Article.fromJson(article)).toList();
    } catch (e) {
      print("❌ Erreur lors de la récupération des articles : $e");
      throw Exception('Failed to load articles');
    }
  }

  // Method to create an article
  Future<int> create(Article article) async {
    try {
      final response = await dio.post(
        '/article/create',
        data: article.toJson(),
      );
      
      if (response.statusCode == 200) {
        return response.data['id'];  // Assuming the API returns the ID of the created article
      } else {
        throw Exception('Failed to create article');
      }
    } catch (e) {
      print("❌ Erreur lors de la création de l'article : $e");
      throw Exception('Failed to create article: $e');
    }
  }

  // Fetch list of colors
  Future<List<Couleur>> getCouleurs() async {
    try {
      final response = await dio.get('/article/couleurs');
      final List<dynamic> data = response.data;
      return data.map((e) => Couleur.fromJson(e)).toList();
    } catch (e) {
      print("❌ Erreur lors du chargement des couleurs : $e");
      throw Exception('Erreur lors du chargement des couleurs');
    }
  }

  // Fetch list of sizes (Pointure)
  Future<List<Pointure>> getPointures() async {
    try {
      final response = await dio.get('/article/pointures');
      final List<dynamic> data = response.data;
      return data.map((e) => Pointure.fromJson(e)).toList();
    } catch (e) {
      print("❌ Erreur lors du chargement des pointures : $e");
      throw Exception('Erreur lors du chargement des pointures');
    }
  }
}