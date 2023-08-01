import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../repo/auth_repo.dart';
import '../utils/prefs.dart';

class AuthState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  set passwordVisible(bool value) {
    _passwordVisible = value;
    notifyListeners();
  }

  UserModel? _user;
  UserModel? get user => _user;
  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> login(String phone, String password) async {
    try {
      final UserModel? userdata =
          await AuthRepo.instance.signIn(phone: phone, password: password);
      user = userdata;

      await prefs.authToken.save(user?.token ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      final UserModel? userdata = await AuthRepo.instance.verifyOtp(phone, otp);
      user = userdata;

      await prefs.authToken.save(user?.token ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String id) async {
    try {
      final UserModel? userData = await AuthRepo.instance.getUserById(id);
      this.user = userData;
    } catch (e) {
      rethrow;
    }
  }

  //stream that updates user data every 5 seconds if user.isExpired
  Stream<void> get userStream => Stream.periodic(
        const Duration(seconds: 5),
        (i) {
          log('userStream: $i');
          if (user?.isExpired ?? true) {
            log('userStream: isExpired');
            updateUser((user?.id ?? '').toString());
          } else {
            log('userStream: isNotExpired');
            userStream.drain();
          }
        },
      );

  Future<void> forgotPassword(String phone) async {
    try {
      await AuthRepo.instance.forgotPassword(phone);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String password,
    required String otp,
  }) async {
    try {
      log('resetPassword');
      await AuthRepo.instance.resetPassword(
        phone: phone,
        password: password,
        otp: otp,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await prefs.authToken.clear();
      reset();
    } catch (e) {
      throw e.toString();
    }
  }

  void reset() {
    _isLoading = false;
    _user = null;
    notifyListeners();
  }
}
