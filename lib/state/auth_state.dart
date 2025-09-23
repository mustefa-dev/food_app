// ...existing code...
import 'package:flutter/material.dart';
import '../features/auth/data/mock_auth_repository.dart';
import '../features/auth/models/auth_models.dart';

class AuthState extends ChangeNotifier {
  final MockAuthRepository _repo = MockAuthRepository();

  bool _loggedIn = false;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isLoggedIn => _loggedIn;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  Future<void> signInMock(String phoneNumber, String password) async {
    final token = await _repo.signIn(SignInCommand(
      phoneNumber: phoneNumber,
      password: password,
    ));
    _token = token;
    _user = await _repo.getCurrentUser();
    _loggedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _token = null;
    _user = null;
    _loggedIn = false;
    notifyListeners();
  }
}
// ...existing code...
