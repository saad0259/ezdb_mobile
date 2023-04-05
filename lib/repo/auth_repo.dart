import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthRepo {
  static final AuthRepo instance = AuthRepo();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
    final QuerySnapshot result = await usersCollection.get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.any((doc) => doc['phone'] == phone)) {
      throw 'Phone number already exists';
    }
  }

  Future<void> signIn({required String phone, required String password}) async {
    try {
      final String email = await getEmailByPhone(phone);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      log(e.code);
      throw e.message!;
    }
  }

  Future<void> passwordReset(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> createNewUser(
      {required String name,
      required String phone,
      required String email,
      required String password}) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    await usersCollection.doc(userId).set({
      'name': name,
      'phone': phone,
      'email': email,
      'memberShipExpiry': DateTime.now().add(const Duration(days: 30)),
      'memberShipStart': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'isBlocked': false,
    });
  }

  Future<String> getEmailByPhone(String phone) async {
    final QuerySnapshot result =
        await usersCollection.where('phone', isEqualTo: phone).get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      throw 'User not found';
    }
    //check if user's memberShipExpiry is not expired
    final DateTime memberShipExpiry =
        (documents.first['memberShipExpiry'] as Timestamp).toDate();
    if (memberShipExpiry.isBefore(DateTime.now())) {
      throw 'Your membership has expired';
    } else if ((documents.first['isBlocked'] ?? false) == true) {
      throw 'Your account has been blocked';
    }
    return documents.first['email'];
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<UserModel> getUser() async {
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';
    final QuerySnapshot result = await usersCollection.get();
    final List<DocumentSnapshot> documents = result.docs;
    final DocumentSnapshot user = documents.firstWhere(
      (doc) => doc['email'] == email,
    );
    return UserModel.fromMap(user.data() as Map<String, dynamic>);
  }
}
