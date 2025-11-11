import 'package:flutter/foundation.dart';
import '../data/models/card_model.dart';
import '../data/repositories/card_repository.dart';

class CardProvider with ChangeNotifier {
  final CardRepository _repository = CardRepository();
  
  List<CardModel> _cards = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<CardModel> get cards => _cards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<CardModel> get creditCards => _cards.where((c) => c.cardType == 'credito').toList();
  List<CardModel> get debitCards => _cards.where((c) => c.cardType == 'debito').toList();
  
  double get totalCreditLimit {
    return creditCards.fold(0, (sum, card) => sum + (card.creditLimit ?? 0));
  }
  
  double get totalCurrentBalance {
    return _cards.fold(0, (sum, card) => sum + (card.currentBalance ?? 0));
  }
  
  double get availableCredit => totalCreditLimit - totalCurrentBalance;
  
  void initCards() {
    _repository.getCards().listen((cards) {
      _cards = cards;
      notifyListeners();
    });
  }
  
  Future<bool> addCard(CardModel card) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _repository.addCard(card);
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
  
  Future<bool> updateCard(String id, CardModel card) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _repository.updateCard(id, card);
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
  
  Future<bool> deleteCard(String id) async {
    try {
      await _repository.deleteCard(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}