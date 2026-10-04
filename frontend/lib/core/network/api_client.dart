

import 'package:dio/dio.dart';
import 'package:frontend/core/error/exceptions.dart';

/// Small wrapper around Dio: sends requests and turns server errors into [ServerException].
class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio;

  /// Needed by the SSE client to build the stream url.
  String get baseUrl => _dio.options.baseUrl;

  Future<dynamic> get(String path) {
    return _request(() => _dio.get(path));
  }

  Future<dynamic> post(String path, {required Object body}) {
    return _request(() => _dio.post(path, data: body));
  }

  Future<dynamic> patch(String path, {Map<String, String>? query}) {
    return _request(() => _dio.patch(path, queryParameters: query));
  }

  Future<dynamic> _request(Future<Response<dynamic>> Function() call) async {
    try {
      final response = await call();
      return response.data;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw ServerException(_errorMessage(response));
      }
      // Timeout or no connection: the repository turns this into a NetworkFailure.
      rethrow;
    }
  }

  String _errorMessage(Response<dynamic> response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return 'Server error (${response.statusCode})';
  }
}