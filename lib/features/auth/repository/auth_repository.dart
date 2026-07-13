import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masrofy/core/service/firabase_service.dart';
import 'package:masrofy/features/auth/models/user_model.dart';

class AuthRepository {
  // call firestore , auth , google singin DONE

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _auth = auth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  // build signin fun
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Error: $e, StackTrace: ${e.stackTrace}');
      rethrow;
    } catch (e, stackTrace) {
      log('Error: $e, StackTrace: $stackTrace');
      rethrow;
    }
  }

  // get user state  auth false
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  // get user
  User? get currentUser => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _userCollection =>
      _firestore.collection('users');

  // save user to fireStore
  Future<void> _saveUserToFirestore(User user) async {
    final userModel = UserModel.fromFirestore(user);
    await _userCollection.doc(user.uid).set(userModel.toMap());
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);
