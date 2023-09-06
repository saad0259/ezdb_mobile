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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'token': token,
      'membershipExpiry': memberShipExpiry.toIso8601String(),
    };
  }
}

class UserSearch {
  final String searchType;
  final String searchValue;
  final String limit;
  final String offset;
  final DateTime createdAt;
  final String userId;

  UserSearch({
    required this.searchType,
    required this.searchValue,
    required this.limit,
    required this.offset,
    required this.createdAt,
    required this.userId,
  });

  UserSearch.fromMap(Map<String, dynamic> map)
      : searchType = map['searchType'].toString(),
        searchValue = map['searchValue'].toString(),
        limit = map['limit'].toString(),
        offset = map['offset'].toString(),
        createdAt = map['createdAt'] == null
            ? DateTime.now()
            : DateTime.parse(map['createdAt'].toString()),
        userId = map['userId'].toString();
}

class UserMembershipLog {
  final int id;
  final int userId;
  final DateTime membershipExpiry;
  final DateTime createdAt;

  UserMembershipLog({
    required this.id,
    required this.userId,
    required this.membershipExpiry,
    required this.createdAt,
  });

  factory UserMembershipLog.fromMap(Map<String, dynamic> map) {
    return UserMembershipLog(
      id: int.tryParse(map['id'].toString()) ?? 0,
      userId: int.tryParse(map['userId'].toString()) ?? 0,
      membershipExpiry: map['membershipExpiry'] == null
          ? DateTime.now()
          : DateTime.parse(map['membershipExpiry'].toString()),
      createdAt: map['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(map['createdAt'].toString()),
    );
  }
}
