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

  Fournisseur({
    required this.id,
    required this.nom,
    required this.email,
    required this.adresse,
    required this.telephone,
    required this.motDePasse,
    required this.statut,
    required this.logo,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      motDePasse: json['motDePasse'],
      statut: json['statut'],
      logo: Photo.fromJson(json['logo']),
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
    };
  }
}
