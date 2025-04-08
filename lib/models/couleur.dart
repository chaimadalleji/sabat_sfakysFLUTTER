class Couleur {
  int id;
  String nom;

  Couleur({required this.id, required this.nom});

  factory Couleur.fromJson(Map<String, dynamic> json) {
    return Couleur(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  @override
  String toString() => nom;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Couleur && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
