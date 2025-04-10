import 'dart:io';
import 'package:dio/dio.dart';
import '../models/photo.dart';

class PhotoService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:8080';
  final String baseUrl2 = 'http://localhost:8080/photo';
  
  PhotoService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);  // Augmenté à 15 secondes
    _dio.options.receiveTimeout = const Duration(seconds: 10);  // Augmenté à 10 secondes
  }

  // Get all photos
  Future<List<Photo>> getPhotos() async {
    try {
      final response = await _dio.get('/photo');
      return (response.data as List)
          .map((json) => Photo.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }

  // Upload a file with progress tracking
  Future<dynamic> upload(File file, Function(int, int) onProgress) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _dio.post(
        '$baseUrl2/upload',
        data: formData,
        onSendProgress: onProgress,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Add the missing uploadPhoto method that was causing the error
  static Future<dynamic> uploadPhoto(File file) async {
    try {
      final dio = Dio();
      dio.options.baseUrl = 'http://localhost:8080';
      
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(
        '/photo/upload',
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
      return response.data;
    } catch (e) {
      print("❌ Erreur lors de l'upload du fichier : $e");
      return null;
    }
  }

  // Get list of files
  Future<List<dynamic>> getFiles() async {
    try {
      final response = await _dio.get('/files');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get files: $e');
    }
  }

  // Delete a file
  Future<String> deleteFile(String fileName) async {
    try {
      final response = await _dio.delete(
        '/deleteFile/$fileName',
        options: Options(responseType: ResponseType.plain),
      );
      return response.data.toString();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  // Create multiple photos
  Future<List<Photo>> createMultiplePhotos(List<Photo> photos) async {
    try {
      final response = await _dio.post(
        '/photo/multiple',
        data: photos.map((photo) => photo.toJson()).toList(),
      );
      return (response.data as List)
          .map((json) => Photo.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to create multiple photos: $e');
    }
  }

  // Mettre à jour une photo
  Future<Photo> updatePhoto(int id, Photo photo) async {
    try {
      final response = await _dio.put(
        '/photo', // Changer '/photos/$id' en '/photo'
        data: photo.toJson(),
      );
      return Photo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update photo: $e');
    }
  }

  // Delete a photo
  Future<void> deletePhoto(int id) async {
    try {
      await _dio.delete('/photos/$id');
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  // Upload multiple photos
  Future<List<dynamic>> uploadMultiplePhotos(List<File> files) async {
    try {
      FormData formData = FormData();
      
      for (var file in files) {
        String fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }

      final response = await _dio.post('/uploadMultiple', data: formData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to upload multiple photos: $e');
    }
  }

  // Get all photos from photo endpoint
  Future<List<Photo>> getAllPhotos() async {
    try {
      final response = await _dio.get(baseUrl2);
      // Convertir la réponse List<dynamic> en List<Photo>
      return (response.data as List)
          .map((json) => Photo.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all photos: $e');
    }
  }
}