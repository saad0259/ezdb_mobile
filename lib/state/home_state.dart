import 'package:flutter/foundation.dart';

import '../constants/enums.dart';

class HomeState extends ChangeNotifier {
  SearchType searchType = SearchType.ic;

  void setSearchType(SearchType value) {
    searchType = value;
    notifyListeners();
  }
}
