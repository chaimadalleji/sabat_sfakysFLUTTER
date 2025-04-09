import 'dart:io';
import 'package:get/get.dart';
import 'package:sabat_sfakys/models/photo.dart';
import 'package:sabat_sfakys/services/photo_service.dart';

class PhotoController extends GetxController {
  var isLoading = false.obs;
  var photos = <Photo>[].obs;
  var uploadProgress = 0.0.obs;

  final PhotoService _photoService = PhotoService();

  @override
  void onInit() {
    super.onInit();
    fetchPhotos(); // Récupérer les photos au démarrage
  }

  // Récupérer les photos
  Future<void> fetchPhotos() async {
    isLoading(true);
    try {
      photos.value = await _photoService.getAllPhotos();
    } catch (e) {
      print("❌ Erreur lors du chargement des photos: $e");
      Get.snackbar(
        "Erreur", 
        "Impossible de charger les photos",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Upload une photo avec progression
  Future<void> uploadPhoto(File file) async {
    isLoading(true);
    uploadProgress.value = 0;
    try {
      await _photoService.uploadPhoto(
        file,
        onProgress: (progress) {
          uploadProgress.value = progress;
        }
      );
      await fetchPhotos(); // Rafraîchir les photos après upload
      return; // Retourne vide en cas de succès
    } catch (e) {
      print("❌ Erreur lors de l'upload: $e");
      rethrow; // Renvoie l'erreur pour la gérer dans la vue
    } finally {
      isLoading(false);
    }
  }

  // Supprimer une photo
  Future<void> deletePhoto(String fileName) async {
    try {
      isLoading(true);
      await _photoService.deletePhoto(fileName);
      await fetchPhotos(); // Rafraîchir après suppression
    } catch (e) {
      print("❌ Erreur lors de la suppression: $e");
      Get.snackbar(
        "Erreur", 
        "Impossible de supprimer la photo",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}