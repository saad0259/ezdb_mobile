import 'dart:developer';

import 'package:flutter/foundation.dart';

class OtpState extends ChangeNotifier {
  List<String> otpChars = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _timer = 60;
  int get timer => _timer;
  set timer(int value) {
    _timer = value;
    notifyListeners();
  }

  void startTimer() {
    log('Timer: $timer');
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (timer > 0) {
        timer = timer - 1;
        startTimer();
      } else {}
    });
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
