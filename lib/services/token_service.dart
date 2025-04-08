import 'package:get_storage/get_storage.dart';

class TokenService {
  static final box = GetStorage();

  // Sauvegarde du token et de sa date d'expiration
  static void saveToken(String token, {required DateTime expirationTime}) {
    box.write("token", token);
    box.write("token_expiration", expirationTime.toIso8601String());
  }

  // Récupération du token si il est valide (non expiré)
  static String? getToken() {
    String? token = box.read("token");
    String? expirationTimeStr = box.read("token_expiration");

    if (token != null && expirationTimeStr != null) {
      DateTime expirationTime = DateTime.tryParse(expirationTimeStr) ?? DateTime.now();

      // Vérifie si le token n'est pas expiré
      if (expirationTime.isAfter(DateTime.now())) {
        return token;
      } else {
        clearToken(); // Si le token est expiré, on le supprime
      }
    }
    
    return null; // Retourne null si le token n'est pas valide
  }

  // Efface le token et sa date d'expiration
  static void clearToken() {
    box.remove("token");
    box.remove("token_expiration");
  }

  // Sauvegarde les informations utilisateur
  static void saveUser(Map<String, dynamic> user) {
    box.write("user", user);
  }

  // Récupération des informations utilisateur
  static Map<String, dynamic>? getUser() {
    return box.read("user");
  }

  // Efface les informations utilisateur
  static void clearUser() {
    box.remove("user");
  }

  // Déconnexion, supprime tout (token + user)
  static void logout() {
    box.erase(); // Supprime tout
  }
}
