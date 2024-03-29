import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum Method { GET, POST, PATCH, DELETE }

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
      return await dio.request(baseUrl + _url,
          options: Options(method: _getMethodString(method)), data: _body);
    } catch (e) {
      debugPrint('Dio Error: $e');
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
    const Duration timeout = Duration(seconds: 60);
    dio = Dio(BaseOptions(
      responseType: ResponseType.json,
      connectTimeout: timeout,
      receiveTimeout: timeout,
    ));
  }
}
