import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
