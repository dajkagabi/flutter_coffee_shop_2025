//Firebase Auth Service
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Bejelentkezés e-mail/jelszóval
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  // Regisztráció e-mail/jelszóval
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();
  }

  // Vendégként bejelentkezés
  Future<void> signInAsGuest() async {
    await _auth.signInAnonymously();
    notifyListeners();
  }

  // Elfelejtett jelszó
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Kijelentkezés
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Automatikus bejelentkezés (Emlékezzen rám funkció)
  Future<void> saveLoginState(bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }
}
