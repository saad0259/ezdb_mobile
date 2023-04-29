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
  String postcode = '';

  List<MemberModel> _members = [];
  List<MemberModel> get members => _members;

  set members(List<MemberModel> value) {
    _members = value;
    notifyListeners();
  }

  void setSearchType(SearchType value) {
    searchType = value;
    members = [];
    currentPage = 0;
    searchValue = '';
    postcode = '';
    dataCount = 0;
    notifyListeners();
  }

  Future<List<MemberModel>> searchMembers() async {
    final PaginatedMemberModel paginatedMembersData = PaginatedMemberModel(
      members: [],
      count: 0,
    );

    try {
      if (searchValue.isEmpty) {
        return [];
      }
      final String uesrId = FirebaseAuth.instance.currentUser!.uid;

      final PaginatedMemberModel paginatedMembersData =
          await MemberRepo.instance.getMembers(
        searchBy: uesrId,
        postcode: searchType == SearchType.address ? postcode : null,
        searchType: searchType.name.toLowerCase(),
        searchValue: searchValue,
        limit: pageSize,
        offset: (currentPage) * pageSize,
      );

      this.members.addAll(paginatedMembersData.members);
      this.dataCount = paginatedMembersData.count;
      return paginatedMembersData.members;
    } catch (e) {
      log('search error: $e');
      if (e.toString().contains('invalid status code of 500')) {
        await searchMembers();
      }
    }
    return paginatedMembersData.members;
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
