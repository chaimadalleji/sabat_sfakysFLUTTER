import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginVendeurPage extends StatelessWidget {
   final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion Vendeur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: authController.usernameController,
              decoration: InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: authController.passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Mot de passe"),
            ),
            SizedBox(height: 20),
            Obx(() => Text(authController.errorMessage.value, style: TextStyle(color: Colors.red))),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => authController.login(), // 🔹 Appel à la méthode login sans type
              child: Text("Se connecter"),
            ),
            SizedBox(height: 20),
            Text("Ou connectez-vous avec"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas de compte ? "),
                GestureDetector(
                  onTap: () => authController.goToRegister(type: "vendeur"), // Redirige vers l'inscription vendeur
                  child: Text(
                    "Inscrivez-vous ici",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
