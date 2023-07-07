import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import 'api_helper.dart';

class AuthRepo {
  static final AuthRepo instance = AuthRepo();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final String authPath = '/auth';

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final data = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      };
      final Request request = Request('${authPath}/register', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      // debugPrint(e.response?.data.toString());
      final String errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      log('Error: $errorMessage');

      throw errorMessage;
    } catch (e) {
      log('Error: $e');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> signIn(
      {required String phone, required String password}) async {
    try {
      final data = {
        'phone': phone,
        'password': password,
      };
      final Request request = Request('${authPath}/login', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200) {
        final UserModel user = UserModel.fromMap(response.data['data']);
        return user;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      // debugPrint(e.response?.data.toString());
      final String errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      log('Error: $errorMessage');

      throw errorMessage;
    } catch (e) {
      log('Error: $e');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final data = {
        'email': email,
        'otp': otp,
      };
      final Request request = Request('${authPath}/verify-otp', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200) {
        log('response: ${response.data}');
        return response.data;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      // debugPrint(e.response?.data.toString());
      final String errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      log('Error: $errorMessage');

      throw errorMessage;
    } catch (e) {
      log('Error: $e');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      final data = {
        'email': email,
      };
      final Request request = Request('${authPath}/resend-otp', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      // debugPrint(e.response?.data.toString());
      final String errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      log('Error: $errorMessage');

      throw errorMessage;
    } catch (e) {
      log('Error: $e');
      debugPrint(e.toString());
      rethrow;
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
