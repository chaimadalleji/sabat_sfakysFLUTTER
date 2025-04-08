class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  /// Convertir l'objet en JSON pour l'envoyer à l'API
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
