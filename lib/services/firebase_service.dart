import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Auth getters
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Firestore collections
  CollectionReference get transactions => _firestore.collection('transacciones');
  CollectionReference get cards => _firestore.collection('tarjetas');
  CollectionReference get users => _firestore.collection('users');
  
  // Auth methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }
  
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  
  Future<void> signOut() {
    return _auth.signOut();
  }
  
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
  
  // Firestore CRUD operations
  Future<DocumentReference> addDocument(String collection, Map<String, dynamic> data) {
    return _firestore.collection(collection).add(data);
  }
  
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(docId).update(data);
  }
  
  Future<void> deleteDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).delete();
  }
  
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    return _firestore.collection(collection).orderBy('timestamp', descending: true).snapshots();
  }
  
  Future<QuerySnapshot> getCollection(String collection) {
    return _firestore.collection(collection).get();
  }
}
