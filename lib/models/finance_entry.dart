enum EntryType { income, expense }

class FinanceEntry {
  const FinanceEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final EntryType type;

  bool get isIncome => type == EntryType.income;

  bool get isExpense => type == EntryType.expense;

  FinanceEntry copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    EntryType? type,
  }) {
    return FinanceEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type.name,
    };
  }

  factory FinanceEntry.fromJson(Map<String, dynamic> json) {
    return FinanceEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      type: EntryType.values.byName(json['type'] as String),
    );
  }
}