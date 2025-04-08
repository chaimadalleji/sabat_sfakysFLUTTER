// lib/services/category_service.dart

import 'package:dio/dio.dart';
import 'package:sabat_sfakys/models/category.dart';

import 'api_service.dart'; // Assure-toi que l'import est correct

class CategoryService {
  final Dio _dio = ApiService.dio;

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('category'); // Assurez-vous que 'category' est le bon endpoint
      if (response.statusCode == 200) {
        List<Category> categories = [];
        for (var category in response.data) {
          categories.add(Category.fromJson(category));
        }
        return categories;
      } else {
        throw Exception('Erreur serveur');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des catégories: $e');
    }
  }

  // Méthode pour supprimer une catégorie
  Future<void> deleteCategory(int id) async {
    try {
      final response = await _dio.delete('category/$id');
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression de la catégorie');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la catégorie: $e');
    }
  }
}
