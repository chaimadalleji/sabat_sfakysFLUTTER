import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:sabat_sfakys/services/photo_service.dart';

import '../services/token_service.dart';
import '../models/signup_request.dart';


class AuthController extends GetxController {
  // 🔹 Services
  final PhotoService _photoService = PhotoService();

  // 🔹 Champs communs
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var userGender = ''.obs;

  // 🔹 Champs spécifiques au vendeur
  var numeroIdentificationEntrepriseController = TextEditingController();
  var scoreEcologiqueController = TextEditingController(); // Ajouté
  var selectedMateriauxUtilises = ''.obs;
  var selectedMethodesProduction = ''.obs;
  var selectedProgrammeRecyclage = ''.obs;
  var selectedTransportLogistiqueVerte = ''.obs;
  var selectedInitiativesSociales = ''.obs;
  var selectedScoreEcologique = ''.obs;
  
  // 🔹 Logo et image
  var selectedLogo = Rx<Map<String, dynamic>>({});  // Ajouté
  var logoOptions = <Map<String, dynamic>>[].obs;  // Ajouté

  // 🔹 États
  var errorMessage = ''.obs;
  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  final String apiUrl = 'http://localhost:8080/api/auth';

  @override
  void onInit() {
    super.onInit();
    fetchLogoOptions();
  }

  /// Récupère les options de logo disponibles
  void fetchLogoOptions() async {
    try {
      final photos = await _photoService.getAllPhotos();
      logoOptions.value = photos.map((photo) => {
        'id': photo.id,
        'name': photo.name,
        'url': photo.url
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des logos: $e");
    }
  }

  /// Connexion avec Google
  void signInWithGoogle() {
    print("Connexion avec Google");
    // Implémentation future
  }

  /// Connexion avec Facebook
  void signInWithFacebook() {
    print("Connexion avec Facebook");
    // Implémentation future
  }

  /// Connexion utilisateur (Client ou Vendeur)
  Future<bool> login() async {
    print("📢 Tentative de connexion...");

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = "Veuillez remplir tous les champs.";
      return false;
    }

    var requestBody = {
      "username": usernameController.text,
      "password": passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/signin'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      print("🔹 Status: ${response.statusCode}");
      print("🔹 Response: ${response.body}");

      return _handleResponse(response);
    } catch (e) {
      errorMessage.value = "Erreur réseau.";
      return false;
    }
  }

  /// Inscription client
  Future<bool> signupUser(SignupRequest request) async {
    print("📢 Inscription d'un client...");

    var requestBody = {
      "username": request.username,
      "password": request.password,
      "email": request.email,
      "adresse": request.adresse,
      "telephone": request.telephone,
      "role": "ROLE_CLIENT",
      "sexe": userGender.value,
    };

    isLoading.value = true;

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/signup'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      isLoading.value = false;
      return _handleSignupResponse(response);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "Erreur réseau.";
      return false;
    }
  }

  /// Inscription vendeur (avec logo)
  Future<bool> registerVendeur(SignupRequest request) async {
    print("📢 Inscription d'un vendeur...");

    var formData = dio.FormData.fromMap({
      "username": request.username,
      "password": request.password,
      "email": request.email,
      "adresse": request.adresse,
      "telephone": request.telephone,
      "logo": request.logo,  // Assurez-vous que le backend peut traiter cela correctement
      "role": "ROLE_FOURNISSEUR",  // Changé de ROLE_FOURNISSEUR à ROLE_VENDEUR
      "numeroIdentificationEntreprise": request.numeroIdentificationEntreprise,
      "materiauxUtilises": request.materiauxUtilises,
      "methodesProduction": request.methodesProduction,
      "programmeRecyclage": request.programmeRecyclage,
      "transportLogistiqueVerte": request.transportLogistiqueVerte,
      "initiativesSociales": request.initiativesSociales,
      "scoreEcologique": request.scoreEcologique,
      "statut": "EN_ATTENTE"
    });

    try {
      var response = await dio.Dio().post('$apiUrl/signup', data: formData);

      if (response.statusCode == 200) {
        Get.snackbar("Succès", "Inscription réussie !");
        clearFields();
        return true;
      } else {
        errorMessage.value = "Échec de l'inscription.";
        return false;
      }
    } catch (e) {
      errorMessage.value = "Erreur réseau: ${e.toString()}";
      return false;
    }
  }

  /// Gestion de la réponse d'inscription
  bool _handleSignupResponse(http.Response response) {
    if (response.statusCode == 200) {
      Get.snackbar("Succès", "Inscription réussie !");
      clearFields();
      return true;
    } else {
      errorMessage.value = json.decode(response.body)['message'] ?? "Erreur lors de l'inscription.";
      return false;
    }
  }

  /// Gestion de la réponse de connexion
  bool _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      String token = responseBody['accessToken'];

      Map<String, dynamic> user = {
        'id': responseBody['id'],
        'username': responseBody['username'],
        'email': responseBody['email'],
        'role': responseBody['role'],
      };

      DateTime expirationTime = DateTime.now().add(const Duration(hours: 1));

      TokenService.saveToken(token, expirationTime: expirationTime);
      TokenService.saveUser(user);

      isLoggedIn.value = true;
      Get.snackbar("Succès", "Connexion réussie !");
      return true;
    } else {
      var responseBody = json.decode(response.body);
      errorMessage.value = responseBody['message'] ?? "Échec de la connexion";
      return false;
    }
  }

  /// Nettoyage des champs
  void clearFields() {
    usernameController.clear();
    passwordController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    userGender.value = '';

    numeroIdentificationEntrepriseController.clear();
    scoreEcologiqueController.clear();  // Ajouté
    selectedMateriauxUtilises.value = '';
    selectedMethodesProduction.value = '';
    selectedProgrammeRecyclage.value = '';
    selectedTransportLogistiqueVerte.value = '';
    selectedInitiativesSociales.value = '';
    selectedScoreEcologique.value = '';
    selectedLogo.value = {};  // Ajouté
  }

  /// Déconnexion
  void logout() {
    TokenService.clearToken();
    TokenService.clearUser();
    isLoggedIn.value = false;
    Get.offAllNamed("/welcome");
  }

  /// Redirection vers la bonne vue d'inscription
  void goToRegister({required String type}) {
    Get.toNamed(type == "client" ? "/register-client" : "/register-vendeur");
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    numeroIdentificationEntrepriseController.dispose();
    scoreEcologiqueController.dispose();  // Ajouté
    super.dispose();
  }
}