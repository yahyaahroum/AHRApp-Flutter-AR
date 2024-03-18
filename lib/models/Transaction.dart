class Transaction {

  final int id;
  final DateTime date_transaction;
  final String type_transaction;
  final String genre_transaction;
  final double valeur;
  final int id_client;

  Transaction({required this.id, required this.date_transaction, required this.type_transaction, required this.genre_transaction, required this.valeur, required this.id_client});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: int.parse(json['id']),
      date_transaction: DateTime.parse(json['date_transaction']),
      type_transaction: json['type_transaction'],
      genre_transaction: json['genre_transaction'],
      valeur: double.parse(json['valeur']),
      id_client: int.parse(json['id_client']),

    );
  }

  Map<String, dynamic> toJson() => {

   'date_transaction':date_transaction,
   'type_transaction':type_transaction,
   'genre_transaction':genre_transaction,
   'valeur':valeur,
   'id_client':id_client,

  };
}