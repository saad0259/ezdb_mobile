import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/member.dart';
import 'api_helper.dart';

class MemberRepo {
  static final MemberRepo instance = MemberRepo();

  String _baseUrl = 'https://mega-middleware.vercel.app/api/v1';
  // String _baseUrl = 'http://10.0.2.2:5000/api/v1';

  Future<PaginatedMemberModel> getMembers({
    required String searchType,
    required String searchValue,
    required String searchBy,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await Request(
              '/users?searchType=$searchType&searchValue=$searchValue&userId=$searchBy&limit=$limit&offset=$offset',
              null)
          .get(_baseUrl);

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
