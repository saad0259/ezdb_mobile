class OfferModel {
  String uid;
  String name;
  int price;
  int days;
  bool isActive;

  OfferModel({
    required this.uid,
    required this.name,
    required this.price,
    required this.days,
    required this.isActive,
  });

  bool get isFreeTrial => price == 0;

  OfferModel.fromMap(Map<String, dynamic> data)
      : uid = data['id'].toString(),
        name = data['name'] ?? '',
        price = int.tryParse(data['price'].toString()) ?? 0,
        days = int.tryParse(data['days'].toString()) ?? 0,
        isActive = data['isActive'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': name,
      'price': price,
      'days': days,
      'isFreeTrial': isFreeTrial,
    };
  }
}
