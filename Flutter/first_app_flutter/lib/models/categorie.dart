class Categorie {
  int? id;
  String libelle;

  Categorie({this.id, required this.libelle});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      libelle: json['libelle'],
    );
  }
}
