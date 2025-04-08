import 'package:sabat_sfakys/models/couleur.dart';
import 'package:sabat_sfakys/models/pointure.dart';

class Stock {
  int id;
  Couleur couleur;
  Pointure pointure;
  int quantite;

  Stock({
    required this.id,
    required this.couleur,
    required this.pointure,
    required this.quantite,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couleur': couleur.toJson(),
      'pointure': pointure.toJson(),
      'quantite': quantite,
    };
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] ?? 0, // Default value in case of null
      couleur: Couleur.fromJson(json['couleur'] ?? {}),
      pointure: Pointure.fromJson(json['pointure'] ?? {}),
      quantite: json['quantite'] ?? 0, // Default value in case of null
    );
  }
}

class Article {
  int id;
  String ref;
  String name;
  String description;
  double prixFournisseur;
  double prixVente;
  String genre;
  String tissu;
  String statut;
  String? category;
  List<String> photos;
  String fournisseurEmail;
  List<Stock> stocks;

  Article({
    required this.id,
    required this.ref,
    required this.name,
    required this.description,
    required this.prixFournisseur,
    required this.prixVente,
    required this.genre,
    required this.tissu,
    required this.statut,
    this.category,
    required this.photos,
    required this.fournisseurEmail,
    required this.stocks,
  });

  // Convert an Article to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ref': ref,
      'name': name,
      'description': description,
      'prixFournisseur': prixFournisseur,
      'prixVente': prixVente,
      'genre': genre,
      'tissu': tissu,
      'statut': statut,
      'category': category,
      'photos': photos,
      'fournisseurEmail': fournisseurEmail,
      'stocks': stocks.map((stock) => stock.toJson()).toList(),
    };
  }

  // Initial empty article for creating new ones
  factory Article.initial() {
    return Article(
      id: 0,
      ref: '',
      name: '',
      description: '',
      prixFournisseur: 0.0,
      prixVente: 0.0,
      genre: '',
      tissu: '',
      statut: 'en_attente',
      category: null,
      photos: [],
      fournisseurEmail: '',
      stocks: [],
    );
  }

  // Build an Article from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0, // Default value for 'id'
      ref: json['ref'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      prixFournisseur: (json['prixFournisseur'] ?? 0).toDouble(),
      prixVente: (json['prixVente'] ?? 0).toDouble(),
      genre: json['genre'] ?? '',
      tissu: json['tissu'] ?? '',
      statut: json['statut'] ?? 'en_attente',
      category: json['category']?.toString(),
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : [],
      fournisseurEmail: json['fournisseurEmail'] ?? '',
      stocks: json['stocks'] != null
          ? List<Stock>.from(json['stocks'].map((x) => Stock.fromJson(x)))
          : [],
    );
  }
}
