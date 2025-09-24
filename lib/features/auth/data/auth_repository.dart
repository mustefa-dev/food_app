import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/storage/secure_store.dart';
import '../../../core/utils/result.dart';
import 'models/auth_models.dart';

class AuthRepository {
  final ApiClient _client;
  AuthRepository(this._client);

  Future<Result<LoginResponse>> login(String email, String password) async {
    try {
      final res = await _client.dio.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json-patch+json'}),
      );
      final loginResponse = LoginResponse.fromJson(res.data);
      await SecureStore.saveTokens(loginResponse.token, ''); // Save only the JWT token
      return Ok(loginResponse);
    } catch (e) {
      return Err(e);
    }
  }

  Future<Result<LoginResponse>> register(String email, String password, String fullName) async {
    try {
      await _client.dio.post(
        Endpoints.register,
        data: {'email': email, 'password': password, 'fullName': fullName},
        options: Options(headers: {'Content-Type': 'application/json-patch+json'}),
      );
      return await login(email, password);
    } catch (e) {
      return Err(e);
    }
  }

  Future<void> logout() => SecureStore.clearTokens();
}
