import 'package:get/get.dart';
import '../controllers/photo_controller.dart';

class PhotoBinding extends Bindings {
  @override
  void dependencies() {
    // Vérifier si le contrôleur existe déjà pour éviter les doublons
    if (!Get.isRegistered<PhotoController>()) {
      Get.put<PhotoController>(PhotoController());
    }
  }
}