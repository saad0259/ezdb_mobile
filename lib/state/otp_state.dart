import 'dart:async';

import 'package:flutter/foundation.dart';

class OtpState extends ChangeNotifier {
  List<String> otpChars = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _start = 60;
  int get start => _start;
  set start(int value) {
    _start = value;
    notifyListeners();
  }

  Timer _timer = Timer.periodic(Duration.zero, (timer) {});

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        _timer.cancel();
      } else {
        _start--;
        notifyListeners(); // Notify listeners when the timer value changes
      }
    });
  }

  void reset() {
    _timer.cancel();
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
