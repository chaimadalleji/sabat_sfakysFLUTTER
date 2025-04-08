import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/signup_request.dart';

class RegisterClientView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription Client")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Champ adresse
              TextField(
                controller: authController.addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
              ),
              const SizedBox(height: 10),

              // Champ email
              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // Champ mot de passe
              TextField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mot de passe"),
              ),
              const SizedBox(height: 10),

              // Champ téléphone
              TextField(
                controller: authController.phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              // Champ nom d'utilisateur
              TextField(
                controller: authController.usernameController,
                decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
              ),
              const SizedBox(height: 10),

              // Champ sexe
              Obx(() => DropdownButtonFormField<String>(
                    value: authController.userGender.value.isNotEmpty
                        ? authController.userGender.value
                        : null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        authController.userGender.value = newValue;
                      }
                    },
                    decoration: const InputDecoration(labelText: "Sexe"),
                    items: ['Homme', 'Femme'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 20),

              // Bouton inscription
              ElevatedButton(
                onPressed: () async {
                  // Créer un objet SignupRequest avec les données du formulaire
                  SignupRequest request = SignupRequest(
                    username: authController.usernameController.text,
                    password: authController.passwordController.text,
                    email: authController.emailController.text,
                    telephone: authController.phoneController.text, // 🔹 Correction ici
                    adresse: authController.addressController.text, // 🔹 Correction ici
                    sexe: authController.userGender.value, // 🔹 Correction ici
                    role: "ROLE_CLIENT",
                  );

                  print("Inscription en cours...");
                  print("Username: ${request.username}");
                  print("Email: ${request.email}");
                  print("Telephone: ${request.telephone}");
                  print("Role: ${request.role}");

                  // Appeler la méthode d'inscription
                  bool success = await authController.signupUser(request);

                  print("Inscription réussie ? $success");

                  if (success) {
                    // Rediriger vers la page de connexion après inscription réussie
                    Get.offNamed("/login-client");
                  } else {
                    // Afficher un message d'erreur en cas d'échec
                    print("Erreur: ${authController.errorMessage.value}");
                    Get.snackbar(
                      "Erreur",
                      authController.errorMessage.value,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text("S'inscrire"),
              ),
              const SizedBox(height: 20),

              // ✅ Lien pour retourner à la connexion
              TextButton(
                onPressed: () {
                  Get.offNamed("/login-client"); // Redirige vers la page de connexion
                },
                child: const Text(
                  "Déjà un compte ? Connectez-vous ici",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
