import 'package:firebase_auth/firebase_auth.dart';
import '../../../../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();
  
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseService.signInWithEmailAndPassword(email, password);
      final user = userCredential.user!;
      
      return UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName ?? '',
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
  
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseService.createUserWithEmailAndPassword(email, password);
      final user = userCredential.user!;
      
      await user.updateDisplayName(name);
      
      final userModel = UserModel(
        id: user.uid,
        email: user.email!,
        name: name,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      
      // Save user data to Firestore
      await _firebaseService.addDocument('users', userModel.toJson());
      
      return userModel;
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
  
  Future<void> signOut() async {
    await _firebaseService.signOut();
  }
  
  Future<void> resetPassword(String email) async {
    await _firebaseService.sendPasswordResetEmail(email);
  }
  
  User? getCurrentUser() {
    return _firebaseService.currentUser;
  }
  
  Stream<User?> authStateChanges() {
    return _firebaseService.authStateChanges;
  }
}