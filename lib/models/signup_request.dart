class SignupRequest {
  String username;
  String email;
  String password;
  String adresse;
  String telephone;
  String sexe;
  String role;
  String? statut;
  String? numeroIdentificationEntreprise;
  String? materiauxUtilises;
  String? methodesProduction;
  String? programmeRecyclage;
  String? transportLogistiqueVerte;
  String? initiativesSociales;
  double? scoreEcologique;

  SignupRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.adresse,
    required this.telephone,
    required this.sexe,
    required this.role,
    this.statut,
    this.numeroIdentificationEntreprise,
    this.materiauxUtilises,
    this.methodesProduction,
    this.programmeRecyclage,
    this.transportLogistiqueVerte,
    this.initiativesSociales,
    this.scoreEcologique,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "username": username,
      "email": email,
      "password": password,
      "adresse": adresse,
      "telephone": telephone,
      "sexe": sexe,
      "role": role,
      "statut": statut,
      "numeroIdentificationEntreprise": numeroIdentificationEntreprise,
      "materiauxUtilises": materiauxUtilises,
      "methodesProduction": methodesProduction,
      "programmeRecyclage": programmeRecyclage,
      "transportLogistiqueVerte": transportLogistiqueVerte,
      "initiativesSociales": initiativesSociales,
      "scoreEcologique": scoreEcologique,
    };

    return data;
  }
}
