import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/offer_model.dart';

class OfferRepo {
  static final OfferRepo instance = OfferRepo();
  final CollectionReference _offerCollection =
      FirebaseFirestore.instance.collection('offers');

  Stream<List<OfferModel>> watchOffers() {
    return _offerCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OfferModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
