import 'dart:convert';

import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient(this._authStorage, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final AuthStorage _authStorage;
  final http.Client _httpClient;

  Future<dynamic> get(String endpoint) async {
    final response = await _httpClient.get(
      _uri(endpoint),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _httpClient.post(
      _uri(endpoint),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await _httpClient.put(
      _uri(endpoint),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await _httpClient.delete(
      _uri(endpoint),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, String>> _headers() async {
    final token = await _authStorage.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _handleResponse(http.Response response) {
    final hasBody = response.body.trim().isNotEmpty;
    final dynamic data = hasBody ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      throw Exception(data['message'] ?? 'Request failed');
    }

    throw Exception('Request failed with status ${response.statusCode}');
  }

  Uri _uri(String endpoint) => Uri.parse('${ApiConstants.baseUrl}$endpoint');
}
