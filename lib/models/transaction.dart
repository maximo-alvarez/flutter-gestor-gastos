// Modelo transacción, que permite registrar
// las transacciones en la aplicación.
class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String categoryId;
  final String type;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'] is int ? (map['amount'] as int).toDouble() : map['amount'],
      date: DateTime.parse(map['date']),
      categoryId: map['categoryId'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
      'type': type,
    };
  }
}
