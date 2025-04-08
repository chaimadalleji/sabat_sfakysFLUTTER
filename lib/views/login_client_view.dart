import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginClientView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion Client")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Champ Nom d'utilisateur
            TextField(
              controller: authController.usernameController,
              decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            const SizedBox(height: 10),

            // Champ Mot de passe
            TextField(
              controller: authController.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Mot de passe"),
            ),
            const SizedBox(height: 20),

            // Affichage des erreurs
            Obx(() => Text(
                  authController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                )),
            const SizedBox(height: 10),

            // Bouton de connexion
            ElevatedButton(
              onPressed: () async {
                print("📢 Tentative de connexion...");
                print("🔹 Username: ${authController.usernameController.text}");
                print("🔹 Password: ${authController.passwordController.text}");

                bool success = await authController.login();

                print("✅ Connexion réussie ? $success");

                if (success) {
                  // Redirection après succès
                  Get.offNamed("/home-client");
                } else {
                  print("❌ Erreur: ${authController.errorMessage.value}");
                  Get.snackbar(
                    "Erreur",
                    authController.errorMessage.value,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text("Se connecter"),
            ),

            const SizedBox(height: 20),
            const Text("Ou connectez-vous avec"),

            const SizedBox(height: 20),

            // Lien pour s'inscrire
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous n'avez pas de compte ? "),
                GestureDetector(
                  onTap: () => authController.goToRegister(type: "client"),
                  child: const Text(
                    "Inscrivez-vous ici",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
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
