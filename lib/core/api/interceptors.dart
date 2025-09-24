import 'package:dio/dio.dart';
import '../storage/secure_store.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final (access, _) = await SecureStore.readTokens();
    if (access != null) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    super.onRequest(options, handler);
  }
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  RefreshTokenInterceptor(this.dio);

  bool _refreshing = false;
  final List<Function()> _queue = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_refreshing) {
      _refreshing = true;
      final (_, refresh) = await SecureStore.readTokens();
      try {
        if (refresh == null) throw Exception('No refresh');
        final resp = await dio.post('/auth/refresh', data: {'refreshToken': refresh});
        final access = resp.data['accessToken'] as String?;
        final newRefresh = resp.data['refreshToken'] as String? ?? refresh;
        if (access == null) throw Exception('No access');
        await SecureStore.saveTokens(access, newRefresh);
        for (final retry in _queue) retry();
        _queue.clear();
        _refreshing = false;
        return handler.resolve(await _retry(err.requestOptions));
      } catch (_) {
        _refreshing = false;
        await SecureStore.clearTokens();
        return handler.reject(err);
      }
    } else if (err.response?.statusCode == 401 && _refreshing) {
      _queue.add(() async => handler.resolve(await _retry(err.requestOptions)));
    }
    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions r) async {
    final options = Options(method: r.method, headers: r.headers);
    return dio.request(r.path, data: r.data, queryParameters: r.queryParameters, options: options);
  }
}
