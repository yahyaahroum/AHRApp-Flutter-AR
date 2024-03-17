class Client {

  final int id;
  final String nom;
  final String prenom;
  final String tel;
  final String ville;

  Client({required this.id, required this.nom, required this.prenom, required this.tel, required this.ville});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        id: int.parse(json['id']),
        nom: json['nom'],
        prenom: json['prenom'],
        tel: json['tel'],
        ville: json['ville'],

    );
  }

  Map<String, dynamic> toJson() => {

    'nom':nom,
    'prenom':prenom,
    'tel':tel,
    'ville':ville,
};
}