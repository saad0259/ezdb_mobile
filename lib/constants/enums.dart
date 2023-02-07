enum SearchType { ic, name, phone, address }

extension SearchTypeExtension on SearchType {
  String get name => toString().split('.').last.toUpperCase();
}

enum AuthType { login, register }
