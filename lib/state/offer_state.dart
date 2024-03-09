import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/offer_model.dart';
import '../repo/offer_repo.dart';
import '../repo/settings_repo.dart';

class OfferState extends ChangeNotifier {
  List<OfferModel> _offers = [];
  List<OfferModel> get offers =>
      _offers.where((element) => element.isActive).toList();
  set offers(List<OfferModel> offers) {
    _offers = offers;
    notifyListeners();
  }

  String _whatsappLink = '';
  String get whatsappLink => _whatsappLink;
  set whatsappLink(String contactUsLink) {
    _whatsappLink = contactUsLink;
    notifyListeners();
  }

  String _telegramLink = '';
  String get telegramLink => _telegramLink;
  set telegramLink(String contactUsLink) {
    _telegramLink = contactUsLink;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<void> loadData() async {
    isLoading = true;
    try {
      offers = await OfferRepo.instance.getOffers();
      final (link1, link2) = await SettingsRepo.instance.getLink();
      whatsappLink = link1;
      telegramLink = link2;
    } catch (e) {
      log(e.toString());
    }

    isLoading = false;
  }
}
