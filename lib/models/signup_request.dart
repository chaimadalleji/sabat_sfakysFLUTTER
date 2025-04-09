class SignupRequest {
  final String username;
  final String password;
  final String email;
  final String telephone;
  final String adresse;
  final Map<String, dynamic>? logo;
  final String? numeroIdentificationEntreprise;
  final String? materiauxUtilises;
  final String? methodesProduction;
  final String? programmeRecyclage;
  final String? transportLogistiqueVerte;
  final String? initiativesSociales;
  final String? scoreEcologique;
  final String? statut;
  final String role;
  final String? sexe;

  SignupRequest({
    required this.username,
    required this.password,
    required this.email,
    required this.telephone,
    required this.adresse,
    this.logo,
    this.numeroIdentificationEntreprise,
    this.materiauxUtilises,
    this.methodesProduction,
    this.programmeRecyclage,
    this.transportLogistiqueVerte,
    this.initiativesSociales,
    this.scoreEcologique,
    this.statut,
    required this.role,
    this.sexe,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'logo': logo,
      'numeroIdentificationEntreprise': numeroIdentificationEntreprise,
      'materiauxUtilises': materiauxUtilises,
      'methodesProduction': methodesProduction,
      'programmeRecyclage': programmeRecyclage,
      'transportLogistiqueVerte': transportLogistiqueVerte,
      'initiativesSociales': initiativesSociales,
      'scoreEcologique': scoreEcologique,
      'statut': statut,
      'role': role,
      'sexe': sexe,
    };
  }
}