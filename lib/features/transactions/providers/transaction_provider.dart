import 'package:flutter/foundation.dart';
import '../data/models/transaction_model.dart';
import '../data/repositories/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  double get totalIncome {
    return _transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);
  }
  
  double get totalExpenses {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
  }
  
  double get balance => totalIncome - totalExpenses;
  
  void initTransactions() {
    _repository.getTransactions().listen((transactions) {
      _transactions = transactions;
      notifyListeners();
    });
  }
  
  Future<bool> addTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _repository.addTransaction(transaction);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateTransaction(String id, TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _repository.updateTransaction(id, transaction);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  List<TransactionModel> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }
  
  List<TransactionModel> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }
  
  Map<String, double> getExpensesByCategory() {
    final expenses = _transactions.where((t) => t.type == 'expense');
    final Map<String, double> result = {};
    
    for (var transaction in expenses) {
      result[transaction.category] = (result[transaction.category] ?? 0) + transaction.amount;
    }
    
    return result;
  }
}