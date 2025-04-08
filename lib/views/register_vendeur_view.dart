import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/signup_request.dart';

class RegisterVendeurView extends StatefulWidget {
  @override
  _RegisterVendeurViewState createState() => _RegisterVendeurViewState();
}

class _RegisterVendeurViewState extends State<RegisterVendeurView> {
  final AuthController authController = Get.put(AuthController());

  final List<String> materiauxOptions = ['Cuir', 'Coton bio', 'Textile recyclé'];
  final List<String> methodesProductionOptions = ['Énergie renouvelable', 'Production locale', 'Sans déchet'];
  final List<String> programmeRecyclageOptions = ['Acceptation de retours usagés', 'Recyclage sur place'];
  final List<String> transportLogistiqueOptions = ['Transport neutre en carbone', 'Livraison verte'];
  final List<String> initiativesSocialesOptions = ['Collaboration avec artisans locaux', 'Insertion professionnelle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription Vendeur")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: authController.usernameController,
                decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              TextField(
                controller: authController.phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              TextField(
                controller: authController.addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mot de passe"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: authController.numeroIdentificationEntrepriseController,
                decoration: const InputDecoration(labelText: "Numéro Identification Entreprise"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: TextEditingController(text: authController.selectedScoreEcologique.value),
                decoration: const InputDecoration(labelText: "Score Écologique"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              Obx(() => DropdownButtonFormField<String>(
                value: authController.selectedMateriauxUtilises.value.isEmpty
                    ? null
                    : authController.selectedMateriauxUtilises.value,
                items: materiauxOptions.map((String material) {
                  return DropdownMenuItem<String>(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (value) => authController.selectedMateriauxUtilises.value = value!,
                decoration: const InputDecoration(labelText: "Matériaux Utilisés"),
              )),
              const SizedBox(height: 10),

              Obx(() => DropdownButtonFormField<String>(
                value: authController.selectedMethodesProduction.value.isEmpty
                    ? null
                    : authController.selectedMethodesProduction.value,
                items: methodesProductionOptions.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) => authController.selectedMethodesProduction.value = value!,
                decoration: const InputDecoration(labelText: "Méthodes de Production"),
              )),
              const SizedBox(height: 10),

              Obx(() => DropdownButtonFormField<String>(
                value: authController.selectedProgrammeRecyclage.value.isEmpty
                    ? null
                    : authController.selectedProgrammeRecyclage.value,
                items: programmeRecyclageOptions.map((String program) {
                  return DropdownMenuItem<String>(
                    value: program,
                    child: Text(program),
                  );
                }).toList(),
                onChanged: (value) => authController.selectedProgrammeRecyclage.value = value!,
                decoration: const InputDecoration(labelText: "Programme de Recyclage"),
              )),
              const SizedBox(height: 10),

              Obx(() => DropdownButtonFormField<String>(
                value: authController.selectedTransportLogistiqueVerte.value.isEmpty
                    ? null
                    : authController.selectedTransportLogistiqueVerte.value,
                items: transportLogistiqueOptions.map((String transport) {
                  return DropdownMenuItem<String>(
                    value: transport,
                    child: Text(transport),
                  );
                }).toList(),
                onChanged: (value) => authController.selectedTransportLogistiqueVerte.value = value!,
                decoration: const InputDecoration(labelText: "Transport Logistique Verte"),
              )),
              const SizedBox(height: 10),

              Obx(() => DropdownButtonFormField<String>(
                value: authController.selectedInitiativesSociales.value.isEmpty
                    ? null
                    : authController.selectedInitiativesSociales.value,
                items: initiativesSocialesOptions.map((String initiative) {
                  return DropdownMenuItem<String>(
                    value: initiative,
                    child: Text(initiative),
                  );
                }).toList(),
                onChanged: (value) => authController.selectedInitiativesSociales.value = value!,
                decoration: const InputDecoration(labelText: "Initiatives Sociales"),
              )),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  SignupRequest request = SignupRequest(
                    username: authController.usernameController.text,
                    password: authController.passwordController.text,
                    email: authController.emailController.text,
                    telephone: authController.phoneController.text,
                    adresse: authController.addressController.text,
                    sexe: authController.userGender.value,
                    numeroIdentificationEntreprise: authController.numeroIdentificationEntrepriseController.text,
                    materiauxUtilises: authController.selectedMateriauxUtilises.value,
                    methodesProduction: authController.selectedMethodesProduction.value,
                    programmeRecyclage: authController.selectedProgrammeRecyclage.value,
                    transportLogistiqueVerte: authController.selectedTransportLogistiqueVerte.value,
                    initiativesSociales: authController.selectedInitiativesSociales.value,
                    statut: "EN_ATTENTE",
                    role: "ROLE_FOURNISSEUR",
                  );

                  bool success = await authController.registerVendeur(request);

                  if (success) {
                    Get.offNamed("/login-vendeur");
                  } else {
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
            ],
          ),
        ),
      ),
    );
  }
}
