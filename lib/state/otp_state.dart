import 'package:flutter/foundation.dart';

class OtpState extends ChangeNotifier {
  List<String> otpChars = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void add(String value) {
    if (otpChars.length < 6) {
      otpChars.add(value);
      notifyListeners();
    }
  }

  void clear() {
    otpChars = [];
    notifyListeners();
  }

  String getOtpString() {
    return otpChars.reduce((value, element) => value = "$value$element");
  }
}
