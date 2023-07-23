import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import 'api_helper.dart';

class AuthRepo {
  static final AuthRepo instance = AuthRepo();
  final String authPath = '/auth';

  Future<void> signUp({
    required String phone,
    required String password,
  }) async {
    try {
      final data = {
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
    return executeSafely(() async {
      final data = {
        'phone': phone,
        'password': password,
      };
      final Request request = Request('${authPath}/login', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200) {
        log('response: ${response.data}');
        final UserModel user = UserModel.fromMap(response.data['data']);
        return user;
      } else {
        throw response.data['message'];
      }
    });
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      final data = {
        'phone': phone,
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

  Future<void> forgotPassword(String phone) async {
    return executeSafely(() async {
      final data = {
        'phone': phone,
      };
      final Request request = Request('${authPath}/forgot-password', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw response.data['message'];
      }
    });
  }

  Future<void> resetPassword({
    required String phone,
    required String password,
    required String otp,
  }) async {
    return executeSafely(() async {
      final data = {
        'phone': phone,
        'password': password,
        'otp': otp,
      };
      final Request request = Request('${authPath}/reset-password', data);
      final Response response = await request.post(baseUrl);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw response.data['message'];
      }
    });
  }
}
