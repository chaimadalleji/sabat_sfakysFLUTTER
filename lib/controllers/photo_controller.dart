import 'dart:io';
import 'package:get/get.dart';
import 'package:sabat_sfakys/models/photo.dart';
import 'package:sabat_sfakys/services/photo_service.dart';

class PhotoController extends GetxController {
  var isLoading = false.obs;
  var photos = <Photo>[].obs;
  var uploadProgress = 0.0.obs;

  final PhotoService _photoService = PhotoService();

  // Récupérer les photos
  void fetchPhotos() async {
    isLoading(true);
    try {
      photos.value = await _photoService.getAllPhotos();
    } finally {
      isLoading(false);
    }
  }

  // Upload une photo
  void uploadPhoto(File file) async {
    isLoading(true);
    try {
      await _photoService.uploadPhoto(file);
      fetchPhotos(); // Rafraîchir les photos
    } finally {
      isLoading(false);
    }
  }

  // Supprimer une photo
  void deletePhoto(String fileName) async {
    isLoading(true);
    try {
      await _photoService.deletePhoto(fileName);
      fetchPhotos();
    } finally {
      isLoading(false);
    }
  }
}
