  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/foundation.dart';

  class FirebaseAuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Future<User?> signUpWithEmailAndPassword(
        String email, String password) async {
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        return credential.user;
      } catch (e) {
        if (kDebugMode) {
          print("some eror occured");
        }
      }
      return null;
    }

    Future<User?> signInWithEmailAndPassword(
        String email, String password, {required String }) async {
      try {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return credential.user;
      } catch (e) {
        if (kDebugMode) {
          print("some eror occured");
        }
      }
      return null;
    }
  }
