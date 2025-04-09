import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sabat_sfakys/controllers/photo_controller.dart';

class PhotoView extends StatelessWidget {
  final PhotoController photoController = Get.put(PhotoController());
  final File? photo;

  PhotoView({this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Photos")),
      body: Column(
        children: [
          // Si une photo est passée, afficher cette photo
          if (photo != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                photo!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          
          // Bouton d'upload avec indicateur de progression
          Obx(() => photoController.isLoading.value && photoController.uploadProgress > 0
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(value: photoController.uploadProgress.value),
                    SizedBox(height: 8),
                    Text('Upload: ${(photoController.uploadProgress.value * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              )
            : ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.upload),
                label: Text("Uploader une Photo"),
              ),
          ),
          
          Expanded(
            child: Obx(() {
              if (photoController.isLoading.value && photoController.photos.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              if (photoController.photos.isEmpty) {
                return Center(child: Text("Aucune photo trouvée."));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: EdgeInsets.all(10),
                itemCount: photoController.photos.length,
                itemBuilder: (context, index) {
                  var photo = photoController.photos[index];
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            photo.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              print('Erreur de chargement: ${photo.url} - $error');
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image, color: Colors.red),
                                    Text('Erreur de chargement', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => photoController.deletePhoto(photo.name),
                            padding: EdgeInsets.all(5),
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Sélectionner une image et l'uploader
  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      photoController.uploadPhoto(file);
    }
  }
}