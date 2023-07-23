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
      log(userdata.toString());
      user = userdata;

      log('user phone : ${user?.phone}');
      log('user token : ${user?.token}');
      log('user membership expiry : ${user?.memberShipExpiry}');

      await prefs.authToken.save(user?.token ?? '');
    } catch (e) {
      rethrow;
    }
  }

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
