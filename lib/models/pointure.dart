class Pointure {
  int id;
  int taille;

  Pointure({required this.id, required this.taille});

  factory Pointure.fromJson(Map<String, dynamic> json) {
    return Pointure(
      id: json['id'],
      taille: json['taille'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taille': taille,
    };
  }

  @override
  String toString() => taille.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pointure && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
