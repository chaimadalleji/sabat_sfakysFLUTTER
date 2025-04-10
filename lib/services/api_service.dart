import 'package:dio/dio.dart';
import 'dart:io'; // Add this import for File class
import 'token_service.dart'; // Service pour stocker et récupérer le token

class ApiService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: "http://localhost:8080/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: "application/json",
  ));

  // Configuration de l'intercepteur pour ajouter automatiquement le token
  static void setupInterceptor() {
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
          return handler.next(e);
        },
      ),
    );
  }

  // 📌 Méthode générique pour envoyer des données en JSON
  static Future<Response?> sendRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(endpoint, data: data);
      print("✅ Réponse reçue : ${response.data}");
      return response;
    } catch (e) {
      print("❌ Erreur lors de l'envoi de la requête : $e");
      return null;
    }
  }

  // 📤 Méthode pour uploader un fichier
  static Future<Response?> uploadFile(File file, String endpoint) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      // Option pour suivre la progression
      Response response = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (int sent, int total) {
          print("📤 Progression: ${(sent / total * 100).toStringAsFixed(0)}%");
        },
      );
      
      print("✅ Fichier téléchargé avec succès");
      return response;
    } catch (e) {
      print("❌ Erreur lors de l'upload du fichier : $e");
      return null;
    }
  }

  // 📦 Classe Article pour sérialiser et désérialiser
  static Article articleFromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'] != null ? Stock.fromJson(json['stock']) : null,
    );
  }

  static Map<String, dynamic> articleToJson(Article article) {
    return {
      'id': article.id,
      'name': article.name,
      'description': article.description,
      'price': article.price,
      'stock': article.stock?.toJson(),
    };
  }

  // 📡 Récupérer les articles depuis l'API
  static Future<List<Article>> getArticles() async {
    try {
      Response response = await dio.get('articles');
      List jsonResponse = response.data;
      return jsonResponse.map((data) => articleFromJson(data)).toList();
    } catch (e) {
      print("❌ Erreur lors de la récupération des articles : $e");
      return [];
    }
  }

  // 📝 Créer un article
  static Future<void> createArticle(Article article) async {
    try {
      Response response = await dio.post(
        'articles',
        data: articleToJson(article),
      );
      if (response.statusCode == 201) {
        print("✅ Article créé avec succès : ${response.data}");
      } else {
        print("❌ Erreur lors de la création de l'article");
      }
    } catch (e) {
      print("❌ Erreur lors de la création de l'article : $e");
    }
  }

  // 📦 Méthode pour récupérer le profil de l'utilisateur
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      Response response = await dio.get('user/profile');
      return response.data; // Retourne les données du profil de l'utilisateur
    } catch (e) {
      print("❌ Erreur lors de la récupération du profil : $e");
      return {}; // Retourne un profil vide en cas d'erreur
    }
  }
}

// 📦 Classe Article
class Article {
  int id;
  String name;
  String description;
  double price;
  Stock? stock;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.stock,
  });
}

// 📦 Classe Stock
class Stock {
  int quantity;

  Stock({required this.quantity});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
    };
  }
}