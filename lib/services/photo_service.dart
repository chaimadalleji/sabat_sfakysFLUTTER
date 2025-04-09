import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sabat_sfakys/models/photo.dart';
import 'package:sabat_sfakys/services/api_service.dart'; // Votre API service existant

class PhotoService {
  // URL de base - utilise celle de votre ApiService
  final String baseUrl = ApiService.dio.options.baseUrl;

  // 📌 Upload une photo avec suivi de progression
  Future<String?> uploadPhoto(File file, {Function(double)? onProgress}) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      // Utiliser l'instance de Dio de votre ApiService existant
      Response response = await ApiService.dio.post(
        "photo/upload", // On utilise les chemins relatifs car baseUrl est déjà défini
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total != 0) {
            onProgress(sent / total);
          }
        }
      );
      
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
      Response response = await ApiService.dio.delete("photo/delete/$fileName");
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
      Response response = await ApiService.dio.get("photo");
      List<dynamic> data = response.data;
      print("✅ Photos récupérées : ${data.length}");
      
      return data.map((json) {
        Photo photo = Photo.fromJson(json);
        // Assurer que l'URL est complète
        if (!photo.url.startsWith('http')) {
          photo = Photo(
            id: photo.id,
            name: photo.name,
            url: '${baseUrl}uploads/${photo.name}'
          );
        }
        return photo;
      }).toList();
    } catch (e) {
      print("❌ Erreur lors de la récupération des photos : $e");
      return [];
    }
  }
}