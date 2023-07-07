enum SearchType { name, ic, phone, address }

extension SearchTypeExtension on SearchType {
  String get name => toString().split('.').last.toUpperCase();
}

enum AuthType { register, forgotPassword }
