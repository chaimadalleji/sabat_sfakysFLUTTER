import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sabat_sfakys/models/photo.dart';
import 'api_service.dart'; // Utilisation de ApiService pour les requêtes

class PhotoService {
  // URL de base pour l'API
  final String baseUrl =  'http://localhost:8080';  // Remplace cette adresse par celle de ton serveur
  final String baseUrl2 ='http://localhost:8080/photo'; 
  // 📌 Upload une photo
  Future<String?> uploadPhoto(File file) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      // Utilisation de l'URL de base pour l'upload
      Response response = await ApiService.dio.post("$baseUrl/photo/upload", data: formData);
      print("✅ Upload réussi : ${response.data}");
      return response.data['message'];
    } catch (e) {
      print("❌ Erreur lors de l'upload : $e");
      return null;
    }
  }

  // 📌 Supprimer une photo
  Future<String?> deletePhoto(String fileName) async {
    try {
      // Utilisation de l'URL de base pour la suppression
      Response response = await ApiService.dio.delete("$baseUrl/photo/delete/$fileName");
      print("✅ Suppression réussie : ${response.data}");
      return response.data['message'];
    } catch (e) {
      print("❌ Erreur lors de la suppression : $e");
      return null;
    }
  }

  // 📌 Récupérer toutes les photos
  Future<List<Photo>> getAllPhotos() async {
    try {
      // Utilisation de l'URL de base pour récupérer les photos
      Response response = await ApiService.dio.get("$baseUrl/photo");
      List<dynamic> data = response.data;
      print("✅ Photos récupérées : ${data.length}");
      return data.map((json) => Photo.fromJson(json)).toList();
    } catch (e) {
      print("❌ Erreur lors de la récupération des photos : $e");
      return [];
    }
  }
}
