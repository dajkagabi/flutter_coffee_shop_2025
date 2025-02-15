import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Bejelentkezés
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners(); // Értesíti a hallgatókat a változásról
    } on FirebaseAuthException {
      rethrow; // Hibát dob, ha a bejelentkezés sikertelen
    }
  }

  // Regisztráció
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners(); // Értesíti a hallgatókat a változásról
    } on FirebaseAuthException {
      rethrow; // Hibát dob, ha a regisztráció sikertelen
    }
  }

  // Vendég mód
  Future<void> signInAsGuest() async {
    try {
      await _auth.signInAnonymously();
      notifyListeners(); // Értesíti a hallgatókat a változásról
    } on FirebaseAuthException {
      rethrow; // Hibát dob, ha a vendég mód nem működik
    }
  }

  // Elfelejtett jelszó
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow; // Hibát dob, ha az email küldése sikertelen
    }
  }

  // Kijelentkezés
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners(); // Értesíti a hallgatókat a változásról
    } on FirebaseAuthException {
      rethrow; // Hibát dob, ha a kijelentkezés sikertelen
    }
  }

  // Emlékezz rám funkció
  Future<void> saveLoginState(bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }
}
