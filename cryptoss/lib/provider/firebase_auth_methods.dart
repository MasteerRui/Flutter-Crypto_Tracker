import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sizer/sizer.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User get user => _auth.currentUser!;

  // STATE PERSISTENCE
  Stream<User?> get authState => _auth.authStateChanges();

  // EMAIL & PASSWORD SIGN UP
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
      await userCredential.user
          ?.updatePhotoURL('https://imgur.com/sfTdXmg.png');
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);
      final newUser = {
        "name": username,
        "idetifier": email,
        "accountCreatedAt": DateTime.now(),
        "profilepicture": 'https://imgur.com/sfTdXmg.png',
        "currency": 'eur'
      };
      await docUser.set(newUser);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    } on FirebaseAuthException catch (e) {
      Flushbar(
        icon: const Icon(
          Icons.email_outlined,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: const Color(0xFF0277BD),
        duration: const Duration(seconds: 4),
        message: "This email is already registered.",
        messageSize: 18,
        titleText: const Text("Flushbar with Icon.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ).show(context);
    }
  }

  // EMAIL & PASSWORD LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      if (email.isEmpty) {
        Flushbar(
          messageText: const Text(
            'Insert an email',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(20),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          reverseAnimationCurve: Curves.decelerate,
          isDismissible: false,
          maxWidth: 85.w,
          icon: const Icon(
            Icons.error,
            size: 25.0,
            color: Colors.blueAccent,
          ),
        ).show(context);
      } else if (password.isEmpty) {
        Flushbar(
          messageText: const Text(
            'Insert an password',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(20),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          reverseAnimationCurve: Curves.decelerate,
          isDismissible: false,
          maxWidth: 85.w,
          icon: const Icon(
            Icons.error,
            size: 25.0,
            color: Colors.blueAccent,
          ),
        ).show(context);
      }
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // CREATE A NEW CREDENTIAL
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            final docUser = FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid);
            final newUser = {
              "name": userCredential.user!.displayName,
              "idetifier": userCredential.user!.email,
              "profilepicture": userCredential.user!.photoURL,
              "accountCreatedAt": DateTime.now(),
              "currency": 'eur'
            };
            await docUser.set(newUser);
          }
        }
      }
    } on FirebaseException catch (e) {
      Flushbar(
        icon: const Icon(
          Icons.email_outlined,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: const Color(0xFF0277BD),
        duration: const Duration(seconds: 4),
        message: "This email is already registered.",
        messageSize: 18,
        titleText: const Text("Flushbar with Icon.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ).show(context);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      Flushbar(
        icon: const Icon(
          Icons.email_outlined,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: const Color(0xFF0277BD),
        duration: const Duration(seconds: 4),
        message: "This email is already registered.",
        messageSize: 18,
        titleText: const Text("Flushbar with Icon.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ).show(context);
    }
  }
}
