import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/member.dart';
import 'api_helper.dart';

class MemberRepo {
  static final MemberRepo instance = MemberRepo();

  String _baseUrl = 'http://5.9.88.108:3000/api/v1';
  // String _baseUrl = 'http://10.0.2.2:5000/api/v1';

  Future<PaginatedMemberModel> getMembers({
    required String searchType,
    required String searchValue,
    required String searchBy,
    String? postcode,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await Request(
              '/users?searchType=$searchType&searchValue=$searchValue&userId=$searchBy&limit=$limit&offset=$offset${postcode != null ? '&postcode=$postcode' : ''}',
              null)
          .get(_baseUrl);

      log('Request: ${'/users?searchType=$searchType&searchValue=$searchValue&userId=$searchBy&limit=$limit&offset=$offset${postcode != null ? '&postcode=$postcode' : ''}'}');

      if (response.statusCode == 200) {
        final data = response.data;
        return PaginatedMemberModel.fromMap(data);
      } else {
        throw Exception('Failed to load members');
      }
    } on DioError catch (e) {
      log('Dio Error: ${e.response?.data}');
      throw Exception(e.message);
    }
  }
}
