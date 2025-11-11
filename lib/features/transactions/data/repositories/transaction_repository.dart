import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/firebase_service.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final FirebaseService _firebaseService = FirebaseService();
  
  Stream<List<TransactionModel>> getTransactions() {
    return _firebaseService.transactions
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }).toList();
    });
  }
  
  Future<void> addTransaction(TransactionModel transaction) async {
    final data = transaction.toJson();
    data['timestamp'] = FieldValue.serverTimestamp();
    await _firebaseService.addDocument('transacciones', data);
  }
  
  Future<void> updateTransaction(String id, TransactionModel transaction) async {
    await _firebaseService.updateDocument('transacciones', id, transaction.toJson());
  }
  
  Future<void> deleteTransaction(String id) async {
    await _firebaseService.deleteDocument('transacciones', id);
  }
  
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final snapshot = await _firebaseService.transactions
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return TransactionModel.fromJson(data);
    }).toList();
  }
}
