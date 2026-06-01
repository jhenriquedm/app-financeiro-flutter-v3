enum TransactionType {
  income,
  expense,
}

class TransactionModel {
  final int? id;
  final String? userId;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;

  TransactionModel({
    this.id,
    this.userId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionModel(
      id: map['id'] as int?,
      userId: map['userId'] as String?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      type: map['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      category: map['category'] as String,
    );
  }

  TransactionModel copyWith({
    int? id,
    String? userId,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }
}