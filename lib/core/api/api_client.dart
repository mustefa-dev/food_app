import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'endpoints.dart';
import 'interceptors.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    final base = dotenv.env['API_BASE_URL'] ?? Endpoints.baseUrl;
    dio = Dio(BaseOptions(baseUrl: base, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));
    dio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(dio),
      PrettyDioLogger(requestHeader: false, requestBody: true, responseBody: false),
    ]);
  }
}
