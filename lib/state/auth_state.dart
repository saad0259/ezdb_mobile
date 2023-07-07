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
