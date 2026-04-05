import 'dart:convert';

import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient(this._authStorage, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              headers: const {'Content-Type': 'application/json'},
            ),
          ) {
    _dio.interceptors.add(_AuthInterceptor(_authStorage));
    _dio.interceptors.add(const _ApiLogInterceptor());
  }

  final AuthStorage _authStorage;
  final Dio _dio;

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get<dynamic>(endpoint);
      return _normalizeResponseData(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<dynamic>(endpoint, data: body);
      return _normalizeResponseData(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put<dynamic>(endpoint, data: body);
      return _normalizeResponseData(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete<dynamic>(endpoint);
      return _normalizeResponseData(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  dynamic _normalizeResponseData(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return jsonDecode(data);
    }

    return data;
  }

  Exception _mapDioException(DioException error) {
    final data = _normalizeResponseData(error.response?.data);

    if (data is Map<String, dynamic>) {
      return Exception(data['message'] ?? 'Request failed');
    }

    final statusCode = error.response?.statusCode;
    return Exception('Request failed with status ${statusCode ?? 'unknown'}');
  }
}

class _AuthInterceptor extends Interceptor {
  const _AuthInterceptor(this._authStorage);

  final AuthStorage _authStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}

class _ApiLogInterceptor extends Interceptor {
  const _ApiLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('''
┌────────────────────────── REQUEST ──────────────────────────
│ METHOD : ${options.method}
│ URL    : ${options.uri}
│ HEADERS:
${_prettyMap(options.headers)}
│ BODY:
${_prettyData(options.data)}
└─────────────────────────────────────────────────────────────
''');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('''
┌────────────────────────── RESPONSE ─────────────────────────
│ STATUS : ${response.statusCode}
│ METHOD : ${response.requestOptions.method}
│ URL    : ${response.requestOptions.uri}
│ DATA:
${_prettyData(response.data)}
└─────────────────────────────────────────────────────────────
''');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        'Error [${err.response?.statusCode}] ${err.requestOptions.method} ${err.requestOptions.uri}',
      );
      debugPrint('Headers: ${err.requestOptions.headers}');
      debugPrint('Request: ${err.requestOptions.data}');
      debugPrint('Error data: ${err.response?.data}');
    }
    handler.next(err);
  }

  String _prettyMap(Map data) {
    return data.entries.map((e) => '│   ${e.key}: ${e.value}').join('\n');
  }

  String _prettyData(dynamic data) {
    if (data == null) return '│   null';

    try {
      if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        return data.toString().split('\n').map((e) => '│   $e').join('\n');
      } else {
        return '│   $data';
      }
    } catch (e) {
      return '│   $data';
    }
  }
}
