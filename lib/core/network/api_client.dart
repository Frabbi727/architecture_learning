import 'dart:convert';

import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/core/utils/resource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

typedef JsonMap = Map<String, dynamic>;
typedef JsonParser<T> = T Function(JsonMap json);

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

  Future<T> get<T>(
    String endpoint, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.get<dynamic>(endpoint);
      final data = _normalizeResponseData(response.data);
      return parser(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.post<dynamic>(endpoint, data: body);
      final data = _normalizeResponseData(response.data);
      return parser(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<T> put<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.put<dynamic>(endpoint, data: body);
      final data = _normalizeResponseData(response.data);
      return parser(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<T> delete<T>(
    String endpoint, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(endpoint);
      final data = _normalizeResponseData(response.data);
      return parser(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<T> getModel<T>(
    String endpoint, {
    required JsonParser<T> parser,
  }) {
    return get<T>(
      endpoint,
      parser: (data) => parser(_asJsonMap(data)),
    );
  }

  Future<T> postModel<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required JsonParser<T> parser,
  }) {
    return post<T>(
      endpoint,
      body,
      parser: (data) => parser(_asJsonMap(data)),
    );
  }

  Future<T> putModel<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required JsonParser<T> parser,
  }) {
    return put<T>(
      endpoint,
      body,
      parser: (data) => parser(_asJsonMap(data)),
    );
  }

  Future<List<T>> getList<T>(
    String endpoint, {
    required JsonParser<T> itemParser,
    String dataKey = 'data',
  }) {
    return get<List<T>>(
      endpoint,
      parser: (data) {
        final list = _extractJsonList(data, dataKey: dataKey);
        return list.map(itemParser).toList(growable: false);
      },
    );
  }

  Future<void> deleteVoid(String endpoint) {
    return delete<void>(
      endpoint,
      parser: (_) {},
    );
  }

  Future<Resource<T>> getResource<T>(
    String endpoint, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final result = await get<T>(endpoint, parser: parser);
      return Resource<T>(
        status: ResourceStatus.success,
        model: result,
        code: 200,
      );
    } catch (error) {
      return Resource<T>(
        status: ResourceStatus.error,
        message: _normalizeError(error),
      );
    }
  }

  Future<Resource<T>> getModelResource<T>(
    String endpoint, {
    required JsonParser<T> parser,

  }) {
    return getResource<T>(
      endpoint,
      parser: (data) => parser(_asJsonMap(data)),
    );
  }

  Future<Resource<T>> postResource<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final result = await post<T>(
        endpoint,
        body,
        parser: parser,
      );
      return Resource<T>(
        status: ResourceStatus.success,
        model: result,
        code: 200,
      );
    } catch (error) {
      return Resource<T>(
        status: ResourceStatus.error,
        message: _normalizeError(error),
      );
    }
  }

  Future<Resource<T>> postModelResource<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required JsonParser<T> parser,
  }) {
    return postResource<T>(
      endpoint,
      body,
      parser: (data) => parser(_asJsonMap(data)),
    );
  }

  Future<Resource<T>> putResource<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final result = await put<T>(
        endpoint,
        body,
        parser: parser,
      );
      return Resource<T>(
        status: ResourceStatus.success,
        model: result,
        code: 200,
      );
    } catch (error) {
      return Resource<T>(
        status: ResourceStatus.error,
        message: _normalizeError(error),
      );
    }
  }

  Future<Resource<T>> putModelResource<T>(
    String endpoint,
    Map<String, dynamic> body, {
    required JsonParser<T> parser,
  }) {
    return putResource<T>(
      endpoint,
      body,
      parser: (data) => parser(_asJsonMap(data)),
    );
  }

  Future<Resource<List<T>>> getListResource<T>(
    String endpoint, {
    required JsonParser<T> itemParser,
    String dataKey = 'data',
  }) {
    return getResource<List<T>>(
      endpoint,
      parser: (data) {
        final list = _extractJsonList(data, dataKey: dataKey);
        return list.map(itemParser).toList(growable: false);
      },
    );
  }

  Future<Resource<void>> deleteResource(String endpoint) async {
    try {
      await deleteVoid(endpoint);
      return Resource<void>(
        status: ResourceStatus.success,
        code: 200,
      );
    } catch (error) {
      return Resource<void>(
        status: ResourceStatus.error,
        message: _normalizeError(error),
      );
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

  String _normalizeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }

  JsonMap _asJsonMap(dynamic data) {
    if (data is JsonMap) {
      return data;
    }

    throw Exception('Response format was invalid');
  }

  List<JsonMap> _extractJsonList(dynamic data, {required String dataKey}) {
    if (data is List<dynamic>) {
      return data.whereType<JsonMap>().toList(growable: false);
    }

    if (data is JsonMap) {
      final nested = data[dataKey];
      if (nested is List<dynamic>) {
        return nested.whereType<JsonMap>().toList(growable: false);
      }
    }

    throw Exception('Response list format was invalid');
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

  String _prettyMap(Map<dynamic, dynamic> data) {
    return data.entries.map((e) => '│   ${e.key}: ${e.value}').join('\n');
  }

  String _prettyData(dynamic data) {
    if (data == null) {
      return '│   null';
    }

    try {
      if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(data).split('\n').map((e) => '│   $e').join('\n');
      }

      return '│   $data';
    } catch (_) {
      return '│   $data';
    }
  }
}
