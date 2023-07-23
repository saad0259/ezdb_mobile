class UserModel {
  final int id;
  final String phone;
  final DateTime memberShipExpiry;
  final String token;

  UserModel({
    required this.id,
    required this.phone,
    required this.memberShipExpiry,
    required this.token,
  });

  bool get isExpired => memberShipExpiry.isBefore(DateTime.now());

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: int.tryParse(data['id'].toString()) ?? 0,
      phone: data['phone'] ?? '',
      token: data['token'] ?? '',
      memberShipExpiry: data['membershipExpiry'] == null
          ? DateTime.now()
          : DateTime.parse(data['membershipExpiry']),
    );
  }
}
