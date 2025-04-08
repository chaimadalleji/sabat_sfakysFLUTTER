import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../services/token_service.dart';
import '../models/signup_request.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;
  var errorMessage = ''.obs;

  final String apiUrl = 'http://localhost:8080/api/auth';

  /// 🔹 Connexion avec `LoginRequest`
  Future<void> loginUser(LoginRequest request) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/signin'),
        body: json.encode(request.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        String jwtToken = responseBody['accessToken']; // 🛠️ Assure-toi que c'est bien "accessToken"
        DateTime expirationTime = DateTime.now().add(Duration(hours: 1));

        TokenService.saveToken(jwtToken, expirationTime: expirationTime);
        TokenService.saveUser({
          "username": responseBody['username'],
          "email": responseBody['email'],
          "role": responseBody['role'],
        });

        isLoggedIn.value = true;

        if (responseBody['role'] == 'ROLE_CLIENT') {
          Get.offNamed("/home-client");
        } else {
          Get.offNamed("/home-vendeur");
        }
      } else {
        errorMessage.value = "Nom d'utilisateur ou mot de passe incorrect.";
      }
    } catch (e) {
      errorMessage.value = "Erreur réseau, veuillez vérifier votre connexion.";
    }
  }

  /// 🔹 Inscription avec `SignupRequest` (client)
  Future<void> signupUser(SignupRequest request) async {
    try {
      var requestBody = request.toJson();
      var response = await http.post(
        Uri.parse('$apiUrl/signup'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        String jwtToken = responseBody['accessToken'];
        DateTime expirationTime = DateTime.now().add(Duration(hours: 1));

        TokenService.saveToken(jwtToken, expirationTime: expirationTime);
        TokenService.saveUser({
          "username": responseBody['username'],
          "email": responseBody['email'],
          "role": responseBody['role'],
        });

        isLoggedIn.value = true;

        if (responseBody['role'] == 'ROLE_CLIENT') {
          Get.offNamed("/home-client");
        } else {
          Get.offNamed("/home-vendeur");
        }
      } else {
        errorMessage.value = "Erreur lors de l'inscription.";
      }
    } catch (e) {
      errorMessage.value = "Erreur réseau, veuillez vérifier votre connexion.";
    }
  }

  /// 🔹 Inscription spécifique pour un vendeur (sans logo)
  Future<void> registerVendeur(SignupRequest request) async {
    try {
      var formData = dio.FormData.fromMap({
        "username": request.username,
        "password": request.password,
        "email": request.email,
        "adresse": request.adresse,
        "telephone": request.telephone,
        "role": "ROLE_FOURNISSEUR",
        "numeroIdentificationEntreprise": request.numeroIdentificationEntreprise,
        "materiauxUtilises": request.materiauxUtilises,
        "methodesProduction": request.methodesProduction,
        "programmeRecyclage": request.programmeRecyclage,
        "transportLogistiqueVerte": request.transportLogistiqueVerte,
        "initiativesSociales": request.initiativesSociales,
        "scoreEcologique": request.scoreEcologique,
      });

      var response = await dio.Dio().post(
        '$apiUrl/signup-vendeur',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseBody = response.data;
        String jwtToken = responseBody['accessToken'];
        DateTime expirationTime = DateTime.now().add(Duration(hours: 1));

        TokenService.saveToken(jwtToken, expirationTime: expirationTime);
        TokenService.saveUser({
          "username": responseBody['username'],
          "email": responseBody['email'],
          "role": responseBody['role'],
        });

        isLoggedIn.value = true;
        Get.offNamed("/home-vendeur");
      } else {
        errorMessage.value = "Erreur lors de l'inscription du vendeur.";
      }
    } catch (e) {
      print("Erreur : $e");
      errorMessage.value = "Erreur réseau, veuillez vérifier votre connexion.";
    }
  }
}
