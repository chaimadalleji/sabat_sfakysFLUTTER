import 'package:sabat_sfakys/models/photo.dart';

class Fournisseur {
  int id;
  String nom;
  String email;
  String adresse;
  String telephone;
  String motDePasse;
  String statut;
  Photo logo;
  String numeroIdentificationEntreprise;
  String materiauxUtilises;
  String methodesProduction;
  String programmeRecyclage;
  String transportLogistiqueVerte;
  String initiativesSociales;
  double scoreEcologique;

  Fournisseur({
    required this.id,
    required this.nom,
    required this.email,
    required this.adresse,
    required this.telephone,
    required this.motDePasse,
    required this.statut,
    required this.logo,
    required this.numeroIdentificationEntreprise,
    required this.materiauxUtilises,
    required this.methodesProduction,
    required this.programmeRecyclage,
    required this.transportLogistiqueVerte,
    required this.initiativesSociales,
    required this.scoreEcologique,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      adresse: json['adresse'] ?? '',
      telephone: json['telephone'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      statut: json['statut'] ?? 'EN_ATTENTE',
      logo: Photo.fromJson(json['logo'] ?? {}),
      numeroIdentificationEntreprise: json['numeroIdentificationEntreprise'] ?? '',
      materiauxUtilises: json['materiauxUtilises'] ?? '',
      methodesProduction: json['methodesProduction'] ?? '',
      programmeRecyclage: json['programmeRecyclage'] ?? '',
      transportLogistiqueVerte: json['transportLogistiqueVerte'] ?? '',
      initiativesSociales: json['initiativesSociales'] ?? '',
      scoreEcologique: (json['scoreEcologique'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'adresse': adresse,
      'telephone': telephone,
      'motDePasse': motDePasse,
      'statut': statut,
      'logo': logo.toJson(),
      'numeroIdentificationEntreprise': numeroIdentificationEntreprise,
      'materiauxUtilises': materiauxUtilises,
      'methodesProduction': methodesProduction,
      'programmeRecyclage': programmeRecyclage,
      'transportLogistiqueVerte': transportLogistiqueVerte,
      'initiativesSociales': initiativesSociales,
      'scoreEcologique': scoreEcologique,
    };
  }
}