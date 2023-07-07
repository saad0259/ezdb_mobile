class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final memberShipExpiry;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberShipExpiry,
    required this.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      token: data['token'],
      memberShipExpiry: data['memberShipExpiry'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
      'membershipExpiry': memberShipExpiry,
    };
  }
}
