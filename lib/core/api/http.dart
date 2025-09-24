import 'package:dio/dio.dart';

class Http {
  static final bool useMock = const bool.fromEnvironment('USE_MOCK_API', defaultValue: false);
  static Dio build() {
    final baseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.165.232.137:5152');
    final dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));
    return dio;
  }
}
