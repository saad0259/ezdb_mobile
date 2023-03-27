import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/enums.dart';
import '../models/member.dart';
import '../repo/member_repo.dart';

class HomeState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    log('currentPage: $value');
    notifyListeners();
  }

  int _dataCount = 0;
  int get dataCount => _dataCount;
  set dataCount(int value) {
    _dataCount = value;
    notifyListeners();
  }

  int _pageSize = 10;
  int get pageSize => _pageSize;
  set pageSize(int value) {
    _pageSize = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  SearchType searchType = SearchType.name;
  String searchValue = '';

  List<MemberModel> _members = [];
  List<MemberModel> get members => _members;

  set members(List<MemberModel> value) {
    _members = value;
    notifyListeners();
  }

  void setSearchType(SearchType value) {
    searchType = value;
    notifyListeners();
  }

  Future<void> searchMembers() async {
    isLoading = true;

    try {
      final String uesrId = FirebaseAuth.instance.currentUser!.uid;

      final PaginatedMemberModel paginatedMembersData =
          await MemberRepo.instance.getMembers(
        searchBy: uesrId,
        searchType: searchType.name.toLowerCase(),
        searchValue: searchValue,
        limit: pageSize,
        offset: (currentPage) * pageSize,
      );

      this.members = paginatedMembersData.members;
      this.dataCount = paginatedMembersData.count;
    } catch (e) {
      // log('search error: $e');
    }
    isLoading = false;
  }

  reset() {
    _members = [];
    searchType = SearchType.name;
    searchValue = '';
    _currentPage = 0;
    _dataCount = 0;
    _pageSize = 10;

    notifyListeners();
  }
}
