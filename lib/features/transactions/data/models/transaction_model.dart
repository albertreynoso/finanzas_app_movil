class TransactionModel {
  final String id;
  final String type; // 'expense' or 'income'
  final double amount;
  final String description;
  final String category;
  final String paymentMethod;
  final String? cardId;
  final DateTime date;
  final String? notes;
  final bool isRecurring;
  final String? recurringPaymentDate;
  final String? recurringFrequency;
  final bool? recurringActive;
  final DateTime createdAt;
  
  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    required this.paymentMethod,
    this.cardId,
    required this.date,
    this.notes,
    this.isRecurring = false,
    this.recurringPaymentDate,
    this.recurringFrequency,
    this.recurringActive,
    required this.createdAt,
  });
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      paymentMethod: json['paymentMethod'] as String,
      cardId: json['cardId'] as String?,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPaymentDate: json['recurringPaymentDate'] as String?,
      recurringFrequency: json['recurringFrequency'] as String?,
      recurringActive: json['recurringActive'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'category': category,
      'paymentMethod': paymentMethod,
      'cardId': cardId,
      'date': date.toIso8601String(),
      'notes': notes,
      'isRecurring': isRecurring,
      'recurringPaymentDate': recurringPaymentDate,
      'recurringFrequency': recurringFrequency,
      'recurringActive': recurringActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
