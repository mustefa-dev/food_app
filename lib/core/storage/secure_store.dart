import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStore {
  static const _s = FlutterSecureStorage();
  static const _kAccess='access_token', _kRefresh='refresh_token';
  static Future<void> save(String a, String r) async { await _s.write(key:_kAccess,value:a); await _s.write(key:_kRefresh,value:r); }
  static Future<String?> access()=>_s.read(key:_kAccess);
  static Future<String?> refresh()=>_s.read(key:_kRefresh);
  static Future<void> clear() async { await _s.delete(key:_kAccess); await _s.delete(key:_kRefresh); }
}
