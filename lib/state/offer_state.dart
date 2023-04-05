import 'package:flutter/material.dart';

import '../models/offer_model.dart';
import '../repo/offer_repo.dart';
import '../repo/settings_repo.dart';

class OfferState extends ChangeNotifier {
  List<OfferModel> _offers = [];
  List<OfferModel> get offers => _offers;
  set offers(List<OfferModel> offers) {
    _offers = offers;
    notifyListeners();
  }

  String _contactUsLink = '';
  String get contactUsLink => _contactUsLink;
  set contactUsLink(String contactUsLink) {
    _contactUsLink = contactUsLink;
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
    Stream<List<OfferModel>> streamOffer = OfferRepo.instance.watchOffers();
    offers = await streamOffer.first;

    streamOffer.listen((List<OfferModel> offers) {
      this.offers = offers;
    });
    contactUsLink = await SettingsRepo.instance.getLink();

    isLoading = false;
  }
}
