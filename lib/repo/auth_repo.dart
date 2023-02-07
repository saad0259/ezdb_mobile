import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthRepo {
  static final AuthRepo instance = AuthRepo();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection;

  Future<void> signUp({
    required String verificationId,
    required String code,
    required String email,
    required String password,
  }) async {
    try {
      var user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await user.user?.updatePhoneNumber(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code));
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> checkIfPhoneExists(String phone) async {
    final QuerySnapshot result = await collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.any((doc) => doc['phone'] == phone)) {
      throw 'Phone number already exists';
    }
  }

  Future<void> signIn({
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (!(await checkIfUserExists(phone, email))) {
        throw 'User does not exist';
      }
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> passwordReset(String email, String phone) async {
    bool userExists = await checkIfUserExists(phone, email);
    log(userExists.toString());
    if (userExists) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } else {
      throw 'User does not exist';
    }
  }

  Future<void> createNewUser(
      {required String name,
      required String phone,
      required String email,
      required String password}) async {
    await collection('users').add({
      'name': name,
      'phone': phone,
      'email': email,
    });
  }

  Future<bool> checkIfUserExists(String phone, String email) async {
    log('checking $phone $email');
    final QuerySnapshot result = await collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents
        .any((doc) => doc['phone'] == phone && doc['email'] == email);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserModel> getUser() async {
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';
    final QuerySnapshot result = await collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;
    final DocumentSnapshot user = documents.firstWhere(
      (doc) => doc['email'] == email,
    );
    return UserModel.fromMap(user.data() as Map<String, dynamic>);
  }
}
