import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  void signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful than just print an error message to improve UI/UX
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signOut() async {
    auth.signOut();
  }

  void signUp(String email, String password, String firstname, String lastname,
      String address, String birthday, String bio) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstname, lastname,
            address, birthday, bio);
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void saveUserToFirestore(String? uid, String email, String firstname,
      String lastname, String address, String birthday, String bio) async {
    try {
      await db.collection("users").doc(uid).set({
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "address": address,
        "birthday": birthday,
        "bio": bio
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
