import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/offer_model.dart';
import 'api_helper.dart';

class OfferRepo {
  static final OfferRepo instance = OfferRepo();
  final String offerPath = '/offers';
  Future<List<OfferModel>> getOffers() {
    return executeSafely(() async {
      final Request request = Request(offerPath, null);
      final Response response = await request.get(baseUrl);

      if (response.statusCode == 200) {
        final List<OfferModel> offers = [];
        response.data.forEach((offer) {
          log(offer.toString());
          offers.add(OfferModel.fromMap(offer));
        });
        return offers;
      } else {
        throw response.data['message'];
      }
    });
  }
}
