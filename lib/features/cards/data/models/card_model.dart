class CardModel {
  final String id;
  final String cardNumber;
  final String bankName;
  final String cardType; // 'credito' or 'debito'
  final int billingDate;
  final int paymentDueDate;
  final double? creditLimit;
  final double? currentBalance;
  final String cardHolder;
  final String expiryDate;
  final String? notes;
  final DateTime createdAt;
  
  CardModel({
    required this.id,
    required this.cardNumber,
    required this.bankName,
    required this.cardType,
    required this.billingDate,
    required this.paymentDueDate,
    this.creditLimit,
    this.currentBalance,
    required this.cardHolder,
    required this.expiryDate,
    this.notes,
    required this.createdAt,
  });
  
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      bankName: json['bankName'] as String,
      cardType: json['cardType'] as String,
      billingDate: json['billingDate'] as int,
      paymentDueDate: json['paymentDueDate'] as int,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      currentBalance: (json['currentBalance'] as num?)?.toDouble(),
      cardHolder: json['cardHolder'] as String,
      expiryDate: json['expiryDate'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'bankName': bankName,
      'cardType': cardType,
      'billingDate': billingDate,
      'paymentDueDate': paymentDueDate,
      'creditLimit': creditLimit,
      'currentBalance': currentBalance,
      'cardHolder': cardHolder,
      'expiryDate': expiryDate,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  String get formattedCardNumber {
    final cleaned = cardNumber.replaceAll(' ', '');
    if (cleaned.length >= 4) {
      return '•••• ${cleaned.substring(cleaned.length - 4)}';
    }
    return cardNumber;
  }
}