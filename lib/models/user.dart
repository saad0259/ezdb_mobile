class UserModel {
  final String name;
  final String email;
  final String phone;
  final memberShipExpiry;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.memberShipExpiry,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      memberShipExpiry: data['memberShipExpiry'],
    );
  }
}
