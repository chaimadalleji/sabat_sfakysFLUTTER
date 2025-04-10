import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sabat_sfakys/views/PhotoListPage.dart';
import 'package:sabat_sfakys/views/create_photo_page.dart'; // Import de la page CreatePhotoPage

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage du logo
            Image.asset(
              'assets/logo (1).png',  // Chemin du logo dans les assets
              width: 150,              // Largeur de l'image
              height: 150,             // Hauteur de l'image
            ),
            SizedBox(height: 20),
            Text(
              "Choisissez votre type de compte",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => selectAccount("client"),
              child: Text("Je suis un client"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => selectAccount("vendeur"),
              child: Text("Je suis un vendeur"),
            ),
            
            // Ajout d'un séparateur
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(thickness: 1, indent: 50, endIndent: 50),
            ),
            
            // Nouveau bouton pour l'upload de photos qui redirige vers CreatePhotoPage
            ElevatedButton.icon(
              onPressed: () => Get.to(() => CreatePhotoPage()),
              icon: Icon(Icons.photo_camera),
              label: Text("Upload Photo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            
            // Bouton pour voir toutes les photos
            TextButton.icon(
              onPressed: () => Get.to(() => PhotoListPage()),
              icon: Icon(Icons.photo_library),
              label: Text("Voir la galerie de photos"),
            ),
          ],
        ),
      ),
    );
  }

  void selectAccount(String role) {
    if (role == "client") {
      Get.toNamed("/login-client");
    } else if (role == "vendeur") {
      Get.toNamed("/login-vendeur");
    }
  }
}