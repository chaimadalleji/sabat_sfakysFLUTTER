import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sabat_sfakys/controllers/photo_controller.dart';

class PhotoView extends StatelessWidget {
  final PhotoController photoController = Get.put(PhotoController());

  // Constructor pour recevoir un fichier photo si nécessaire
  final File? photo;

  PhotoView({this.photo}); // Si une photo est passée, l'utiliser.

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
          ElevatedButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.upload),
            label: Text("Uploader une Photo"),
          ),
          Expanded(
            child: Obx(() {
              if (photoController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (photoController.photos.isEmpty) {
                return Center(child: Text("Aucune photo trouvée."));
              }
              return ListView.builder(
                itemCount: photoController.photos.length,
                itemBuilder: (context, index) {
                  var photo = photoController.photos[index];
                  return ListTile(
                    leading: Image.network(photo.url, width: 50, height: 50),
                    title: Text(photo.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => photoController.deletePhoto(photo.name),
                    ),
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
