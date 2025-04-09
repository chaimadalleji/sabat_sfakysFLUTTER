import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sabat_sfakys/controllers/photo_controller.dart';

class CreatePhotoView extends StatelessWidget {
  // Utiliser le lazy loading de Get pour s'assurer que le controller est initialisé
  final photoController = Get.put(PhotoController());
  final ImagePicker _picker = ImagePicker();
  
  // Déplacer _selectedImage dans le controller ou utiliser un controller séparé
  final Rx<File?> selectedImage = Rx<File?>(null);

  CreatePhotoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une Photo"),
        actions: [
          // Bouton d'upload visible uniquement quand une image est sélectionnée
          Obx(() => selectedImage.value != null 
            ? IconButton(
                icon: Icon(Icons.check),
                onPressed: () => _uploadImage(),
              )
            : SizedBox.shrink()
          ),
        ],
      ),
      body: Obx(() {
        // Si une image est en train d'être uploadée, afficher la progression
        if (photoController.isLoading.value && photoController.uploadProgress.value > 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(value: photoController.uploadProgress.value),
                SizedBox(height: 16),
                Text(
                  'Upload en cours: ${(photoController.uploadProgress.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        // Si une image est sélectionnée, l'afficher avec des options
        if (selectedImage.value != null) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      selectedImage.value!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _selectImage(context),
                      icon: Icon(Icons.refresh),
                      label: Text("Changer"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _uploadImage(),
                      icon: Icon(Icons.upload),
                      label: Text("Uploader"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        
        // Si aucune image n'est sélectionnée, afficher les options de sélection
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_library, size: 80, color: Colors.grey[400]),
              SizedBox(height: 20),
              Text(
                "Aucune photo sélectionnée",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _selectImage(context),
                icon: Icon(Icons.add_photo_alternate),
                label: Text("Sélectionner une photo"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => selectedImage.value == null 
        ? Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sourceButton(context, ImageSource.gallery, Icons.photo_library, "Galerie"),
                _sourceButton(context, ImageSource.camera, Icons.camera_alt, "Caméra"),
              ],
            ),
          )
        : SizedBox() // Utiliser un widget vide au lieu de null
      ),
    );
  }

  // Widget de bouton pour choisir la source
  Widget _sourceButton(BuildContext context, ImageSource source, IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () => _pickImage(source),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  // Dialogue pour choisir une source d'image
  void _selectImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galerie'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Caméra'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Sélectionner une image depuis la source spécifiée
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compression pour éviter les fichiers trop volumineux
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        "Erreur", 
        "Impossible de sélectionner l'image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload l'image sélectionnée
  Future<void> _uploadImage() async {
    if (selectedImage.value == null) return;
    
    try {
      // Upload l'image et attend la fin
      await photoController.uploadPhoto(selectedImage.value!);
      
      // Affiche un message de succès
      Get.snackbar(
        "Succès", 
        "Photo uploadée avec succès",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
      // Retour à la page précédente après un court délai
      await Future.delayed(Duration(seconds: 1));
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Erreur", 
        "Échec de l'upload: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}