import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsRepo {
  static final SettingsRepo instance = SettingsRepo();
  final CollectionReference _settingsCollection =
      FirebaseFirestore.instance.collection('settings');

  Stream<(String, String)> watchUrl() {
    return _settingsCollection.doc('pricingLink').snapshots().map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['whatsappLink'] as String, data['telegramLink'] as String);
    }).handleError((e) {
      log(e.toString());
      throw e;
    });
  }
}
