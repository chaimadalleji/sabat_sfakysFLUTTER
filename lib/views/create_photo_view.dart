import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sabat_sfakys/controllers/photo_controller.dart';

class CreatePhotoView extends StatelessWidget {
  final PhotoController photoController = Get.find<PhotoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une Photo")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: pickImage,
          icon: Icon(Icons.photo),
          label: Text("Sélectionner une photo"),
        ),
      ),
    );
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      photoController.uploadPhoto(file);
      Get.back(); // Retour à la page précédente après upload
    }
  }
}
