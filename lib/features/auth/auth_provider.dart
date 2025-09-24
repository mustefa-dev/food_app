import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/http.dart';
import '../../core/storage/secure_store.dart';

class AuthUser { final String id; final String name; final String email;
  AuthUser({required this.id, required this.name, required this.email}); }

class AuthState {
  final bool loading; final bool authenticated; final AuthUser? user;
  const AuthState({required this.loading, required this.authenticated, this.user});
  AuthState copyWith({bool? loading, bool? authenticated, AuthUser? user}) => AuthState(loading: loading??this.loading, authenticated: authenticated??this.authenticated, user: user??this.user);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(): super(const AuthState(loading: true, authenticated: false)) { _init(); }

  Future<void> _init() async {
    final a = await SecureStore.access();
    if (a != null) {
      // Optionally, decode token to get user info, or store user info in SecureStore
      state = AuthState(loading:false, authenticated:true, user: AuthUser(id:'u1', name:'Demo User', email:'user@example.com'));
    } else {
      state = const AuthState(loading:false, authenticated:false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      final dio = Http.build();
      final response = await dio.post('/api/auth/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json-patch+json'}),
      );
      final data = response.data;
      await SecureStore.save(data['token'], ''); // Save token, no refresh token in response
      state = AuthState(
        loading: false,
        authenticated: true,
        user: AuthUser(
          id: data['id'] ?? '',
          name: data['fullName'] ?? '',
          email: data['email'] ?? '',
        ),
      );
    } catch (e) {
      state = state.copyWith(loading: false, authenticated: false);
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      final dio = Http.build();
      final response = await dio.post('/api/auth/register',
        data: {'fullName': name, 'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json-patch+json'}),
      );
      final data = response.data;
      await SecureStore.save(data['token'], '');
      state = AuthState(
        loading: false,
        authenticated: true,
        user: AuthUser(
          id: data['id'] ?? '',
          name: data['fullName'] ?? '',
          email: data['email'] ?? '',
        ),
      );
    } catch (e) {
      state = state.copyWith(loading: false, authenticated: false);
      rethrow;
    }
  }

  Future<void> logout() async { await SecureStore.clear(); state = const AuthState(loading:false, authenticated:false); }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref)=> AuthController());
