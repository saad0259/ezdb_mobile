import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/prefs.dart';

// * Dio Start
enum Method { GET, POST, PATCH, DELETE }

const String baseUrl = kDebugMode
    ? 'https://10.0.2.2:5500/api/v1'
    : 'https://5.9.88.108:5500/api/v1';

class Request {
  final String _url;
  final dynamic _body;

  Request(
    this._url,
    this._body,
  );

  Future<Response<dynamic>> _sendRequest(Method method, String baseUrl) async {
    final dio = DioSingleton.instance.dio;
    try {
      final String token = await prefs.authToken.load();

      return await dio.request(
        baseUrl + _url,
        options: Options(
          method: _getMethodString(method),
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: _body,
      );
    } catch (e) {
      log('send request error : $e');
      return Future.error(e);
    }
  }

  String _getMethodString(Method method) {
    switch (method) {
      case Method.GET:
        return 'GET';
      case Method.POST:
        return 'POST';
      case Method.PATCH:
        return 'PATCH';
      case Method.DELETE:
        return 'DELETE';
    }
  }

  Future<Response> get(String baseUrl) => _sendRequest(Method.GET, baseUrl);

  Future<Response> post(String baseUrl) => _sendRequest(Method.POST, baseUrl);

  Future<Response> patch(String baseUrl) => _sendRequest(Method.PATCH, baseUrl);

  Future<Response> delete(String baseUrl) =>
      _sendRequest(Method.DELETE, baseUrl);
}

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio dio;
  static DioSingleton get instance => _instance;

  DioSingleton._internal() {
    const Duration timeout = Duration(seconds: 30);
    dio = Dio(BaseOptions(
      responseType: ResponseType.json,
      connectTimeout: timeout,
      receiveTimeout: timeout,
    ));
  }
}

// * Dio End

Future<T> executeSafely<T>(Future<T> Function() function) async {
  try {
    return await function();
  } on DioError catch (e) {
    final String errorMessage =
        e.response?.data['message'] ?? 'Something went wrong';
    log('Error: $errorMessage');
    throw errorMessage;
  } catch (e) {
    log('Error: $e');
    rethrow;
  }
}
