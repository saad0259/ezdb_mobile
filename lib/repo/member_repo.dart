import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/member.dart';
import 'api_helper.dart';

class MemberRepo {
  static final MemberRepo instance = MemberRepo();

  Future<PaginatedMemberModel> getMembers({
    required String searchType,
    required String searchValue,
    required int searchBy,
    String? postcode,
    required int limit,
    required int offset,
  }) async {
    try {
      log('Request: ${'/records?searchType=$searchType&searchValue=$searchValue&userId=$searchBy&limit=$limit&offset=$offset${postcode != null ? '&postcode=$postcode' : ''}'}');
      final response = await Request(
              '/records?searchType=$searchType&searchValue=$searchValue&userId=$searchBy&limit=$limit&offset=$offset${postcode != null ? '&postcode=$postcode' : ''}',
              null)
          .get(baseUrl);

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
