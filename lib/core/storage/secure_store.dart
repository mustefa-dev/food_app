import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kLastRestaurant = 'last_restaurant_id';
  static const _kAutoOpen = 'auto_open_last';

  static Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  static Future<(String?, String?)> readTokens() async => (
        await _storage.read(key: _kAccess),
        await _storage.read(key: _kRefresh),
      );

  static Future<void> clearTokens() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  static Future<void> setLastRestaurant(String id) => _storage.write(key: _kLastRestaurant, value: id);
  static Future<String?> getLastRestaurant() => _storage.read(key: _kLastRestaurant);

  static Future<void> setAutoOpenLast(bool v) => _storage.write(key: _kAutoOpen, value: v.toString());
  static Future<bool> getAutoOpenLast() async => (await _storage.read(key: _kAutoOpen)) != 'false';
}
