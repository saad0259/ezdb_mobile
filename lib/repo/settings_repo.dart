import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsRepo {
  static final SettingsRepo instance = SettingsRepo();
  final CollectionReference _settingsCollection =
      FirebaseFirestore.instance.collection('settings');

  Future<(String, String)> getLink() async {
    try {
      final doc = await _settingsCollection.doc('pricingLink').get();
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['whatsappLink'] as String, data['telegramLink'] as String);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
