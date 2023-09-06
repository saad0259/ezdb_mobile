import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../repo/auth_repo.dart';

class NotificationsState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int currentTabIndex = 0;
  int get getCurrentTabIndex => currentTabIndex;
  set setCurrentTabIndex(int value) {
    currentTabIndex = value;
    notifyListeners();
  }

  List<UserSearch> _userSearches = [];
  List<UserSearch> get userSearches => _userSearches;
  set userSearches(List<UserSearch> value) {
    _userSearches = value;
    log('userSearches: ${userSearches.length}');
    notifyListeners();
  }

  List<UserMembershipLog> _userMembershipLogs = [];
  List<UserMembershipLog> get userMembershipLogs => _userMembershipLogs;
  set userMembershipLogs(List<UserMembershipLog> value) {
    _userMembershipLogs = value;
    log('userMembershipLogs: ${userMembershipLogs.length}');
    notifyListeners();
  }

  Future<void> getUserSearches(String userId) async {
    try {
      isLoading = true;
      final List<UserSearch> userSearches =
          await AuthRepo.instance.getUserSearches(userId);
      this.userSearches = userSearches;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> getUserMembershipLogs(String userId) async {
    try {
      isLoading = true;
      final List<UserMembershipLog> userMembershipLogs =
          await AuthRepo.instance.getUserMembershipLogs(userId);
      this.userMembershipLogs = userMembershipLogs;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
    }
  }
}
