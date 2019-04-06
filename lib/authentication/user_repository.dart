import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<bool> isSignedIn() async {
    return (await _auth.currentUser()) != null;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<FirebaseUser> getUser() async {
    return _auth.currentUser();
  }
}