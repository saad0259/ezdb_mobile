class OfferModel {
  String uid;
  String name;
  String price;
  String days;

  OfferModel({
    required this.uid,
    required this.name,
    required this.price,
    required this.days,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) {
    return OfferModel(
      uid: data['id'].toString(),
      name: data['name'].toString(),
      price: data['price'].toString(),
      days: data['days'].toString(),
    );
  }
}
