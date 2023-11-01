import 'package:flutter/foundation.dart';

class DashboardState extends ChangeNotifier {
  int _currentIndex = kDebugMode ? 0 : 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void reset() {
    _currentIndex = 0;
    notifyListeners();
  }
}
