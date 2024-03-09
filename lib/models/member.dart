class MemberModel {
  final int id;
  final String name;
  final String ic;
  final String tel1;
  final String tel2;
  final String tel3;
  final String postcode;
  final String address;

  MemberModel({
    required this.id,
    required this.name,
    required this.ic,
    required this.tel1,
    required this.tel2,
    required this.tel3,
    required this.postcode,
    required this.address,
  });

  factory MemberModel.fromMap(Map<String, dynamic> data) {
    return MemberModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? 'N/A',
      ic: data['ic'] ?? 'N/A',
      tel1: data['tel1'] ?? 'N/A',
      tel2: data['tel2'] ?? 'N/A',
      tel3: data['tel3'] ?? 'N/A',
      postcode: data['postcode'] ?? '',
      address: data['address'] ?? 'N/A',
    );
  }
}

class PaginatedMemberModel {
  final List<MemberModel> members;
  final int count;

  PaginatedMemberModel({
    required this.members,
    required this.count,
  });

  factory PaginatedMemberModel.fromMap(Map<String, dynamic> data) {
    final List<dynamic> members = data['data'];
    return PaginatedMemberModel(
      members: members.map((e) => MemberModel.fromMap(e)).toList(),
      count: data['count'] ?? 0,
    );
  }
}
