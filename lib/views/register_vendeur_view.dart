import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../controllers/auth_controller.dart';
import '../models/signup_request.dart';

class RegisterVendeurView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  final List<String> materiauxOptions = ['Cuir', 'Coton bio', 'Textile recyclé'];
  final List<String> methodesProductionOptions = ['Énergie renouvelable', 'Production locale', 'Sans déchet'];
  final List<String> programmeRecyclageOptions = ['Acceptation de retours usagés', 'Recyclage sur place'];
  final List<String> transportLogistiqueOptions = ['Transport neutre en carbone', 'Livraison verte'];
  final List<String> initiativesSocialesOptions = ['Collaboration avec artisans locaux', 'Insertion professionnelle'];
  
  RegisterVendeurView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mettre à jour les logos au chargement
    authController.updateLogoOptions();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription Vendeur"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offNamed('/accueil'),
        ),
        actions: [
          // Bouton pour uploader un logo
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () async {
              await Get.toNamed('/upload-photo');
              // Mettre à jour les logos après le retour
              authController.updateLogoOptions();
            },
            tooltip: 'Ajouter un logo',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Créer un compte vendeur',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Informations de base
              TextField(
                controller: authController.usernameController,
                decoration: const InputDecoration(
                  labelText: "Nom d'utilisateur",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: authController.passwordController,
                decoration: const InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: authController.addressController,
                decoration: const InputDecoration(
                  labelText: "Adresse",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: authController.phoneController,
                decoration: const InputDecoration(
                  labelText: "Téléphone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              // Affichage du logo sélectionné (aperçu)
              Obx(() {
                if (authController.selectedLogo.value.isNotEmpty && 
                    authController.selectedLogo.value.containsKey('data')) {
                  return Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(authController.selectedLogo.value['data']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 0);
              }),
              
              // Sélection du logo
              Row(
                children: [
                  Expanded(
                    child: Obx(() => DropdownButtonFormField<Map<String, dynamic>>(
                      value: authController.selectedLogo.value.isEmpty 
                          ? null 
                          : authController.selectedLogo.value,
                      items: authController.logoOptions.map((logo) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: logo,
                          child: Row(
                            children: [
                              // Miniature du logo si disponible
                              if (logo.containsKey('data')) 
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: const EdgeInsets.only(right: 8),
                                  child: Image.memory(
                                    base64Decode(logo['data']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              // Nom du logo
                              Text(logo['name'] ?? 'Logo sans nom'),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          authController.selectedLogo.value = value;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Sélectionnez un logo",
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate),
                    onPressed: () async {
                      await Get.toNamed('/upload-photo');
                      authController.updateLogoOptions();
                    },
                    tooltip: 'Ajouter un logo',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: authController.numeroIdentificationEntrepriseController,
                decoration: const InputDecoration(
                  labelText: "Numéro Identification Entreprise",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Informations écologiques
              const Text(
                'Pratiques écologiques',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

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
                onChanged: (value) {
                  if (value != null) {
                    authController.selectedMateriauxUtilises.value = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Matériaux Utilisés",
                  border: OutlineInputBorder(),
                ),
              )),
              const SizedBox(height: 16),

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
                onChanged: (value) {
                  if (value != null) {
                    authController.selectedMethodesProduction.value = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Méthodes de Production",
                  border: OutlineInputBorder(),
                ),
              )),
              const SizedBox(height: 16),

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
                onChanged: (value) {
                  if (value != null) {
                    authController.selectedProgrammeRecyclage.value = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Programme de Recyclage",
                  border: OutlineInputBorder(),
                ),
              )),
              const SizedBox(height: 16),

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
                onChanged: (value) {
                  if (value != null) {
                    authController.selectedTransportLogistiqueVerte.value = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Transport Logistique Verte",
                  border: OutlineInputBorder(),
                ),
              )),
              const SizedBox(height: 16),

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
                onChanged: (value) {
                  if (value != null) {
                    authController.selectedInitiativesSociales.value = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Initiatives Sociales",
                  border: OutlineInputBorder(),
                ),
              )),
              const SizedBox(height: 16),
              
              TextField(
                controller: authController.scoreEcologiqueController,
                decoration: const InputDecoration(
                  labelText: "Score Écologique (1-10)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              
              // Message d'erreur
              Obx(() => Visibility(
                visible: authController.errorMessage.value.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    authController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),

              // Bouton d'inscription
              ElevatedButton(
                onPressed: () async {
                  // Vérification des champs obligatoires
                  if (authController.usernameController.text.isEmpty ||
                      authController.emailController.text.isEmpty ||
                      authController.passwordController.text.isEmpty ||
                      authController.phoneController.text.isEmpty ||
                      authController.addressController.text.isEmpty ||
                      authController.selectedLogo.value.isEmpty ||
                      authController.numeroIdentificationEntrepriseController.text.isEmpty ||
                      authController.selectedMateriauxUtilises.value.isEmpty ||
                      authController.selectedMethodesProduction.value.isEmpty ||
                      authController.selectedProgrammeRecyclage.value.isEmpty ||
                      authController.selectedTransportLogistiqueVerte.value.isEmpty ||
                      authController.selectedInitiativesSociales.value.isEmpty ||
                      authController.scoreEcologiqueController.text.isEmpty) {
                    
                    authController.errorMessage.value = "Tous les champs sont obligatoires";
                    return;
                  }
                  
                  SignupRequest request = SignupRequest(
                    username: authController.usernameController.text,
                    password: authController.passwordController.text,
                    email: authController.emailController.text,
                    telephone: authController.phoneController.text,
                    adresse: authController.addressController.text,
                    logo: authController.selectedLogo.value,
                    numeroIdentificationEntreprise: authController.numeroIdentificationEntrepriseController.text,
                    materiauxUtilises: authController.selectedMateriauxUtilises.value,
                    methodesProduction: authController.selectedMethodesProduction.value,
                    programmeRecyclage: authController.selectedProgrammeRecyclage.value,
                    transportLogistiqueVerte: authController.selectedTransportLogistiqueVerte.value,
                    initiativesSociales: authController.selectedInitiativesSociales.value,
                    scoreEcologique: authController.scoreEcologiqueController.text,
                    statut: "EN_ATTENTE",
                    role: "ROLE_FOURNISSEUR",
                  );

                  bool success = await authController.registerVendeur(request);

                  if (success) {
                    Get.offNamed("/login-vendeur");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text("S'INSCRIRE", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              
              // Options alternatives de connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text('Google'),
                    onPressed: () => authController.signInWithGoogle(),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.facebook),
                    label: const Text('Facebook'),
                    onPressed: () => authController.signInWithFacebook(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Lien vers login
              TextButton(
                onPressed: () => Get.toNamed('/login-vendeur'),
                child: const Text('Déjà inscrit? Connectez-vous'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}