import 'offer_model.dart';

class PaymentModel {
  final String uid;
  final int userId;
  final OfferModel offer;
  final String status;
  final DateTime createdAt;
  final bool isFreeTrial;

  PaymentModel({
    required this.userId,
    required this.offer,
  })  : uid = '',
        createdAt = DateTime.now(),
        status = 'pending',
        isFreeTrial = false;

  PaymentModel.fromJson(Map<String, dynamic> json)
      : uid = json['id'] ?? '',
        userId = json['userId'] ?? '',
        offer = OfferModel.fromMap(json['offer'] ??
            {'price': json['offerPrice'], 'days': json['offerDays']}),
        status = json['status'] ?? '',
        createdAt = DateTime.parse(json['createdAt']),
        isFreeTrial = json['isFreeTrial'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'offer': offer.toMap(),
      'status': 'pending',
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
