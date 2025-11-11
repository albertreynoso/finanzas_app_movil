import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/firebase_service.dart';
import '../models/card_model.dart';

class CardRepository {
  final FirebaseService _firebaseService = FirebaseService();
  
  Stream<List<CardModel>> getCards() {
    return _firebaseService.cards
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CardModel.fromJson(data);
      }).toList();
    });
  }
  
  Future<void> addCard(CardModel card) async {
    final data = card.toJson();
    data['timestamp'] = FieldValue.serverTimestamp();
    await _firebaseService.addDocument('tarjetas', data);
  }
  
  Future<void> updateCard(String id, CardModel card) async {
    await _firebaseService.updateDocument('tarjetas', id, card.toJson());
  }
  
  Future<void> deleteCard(String id) async {
    await _firebaseService.deleteDocument('tarjetas', id);
  }
  
  Future<void> updateCardBalance(String id, double amount) async {
    await _firebaseService.updateDocument('tarjetas', id, {
      'currentBalance': FieldValue.increment(amount),
    });
  }
}