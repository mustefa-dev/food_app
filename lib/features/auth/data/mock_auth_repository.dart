// ...existing code...
import '../models/auth_models.dart';
import 'mock_auth_data.dart';

class MockAuthRepository {
  String? _token;
  Map<String, dynamic>? _currentUser;

  Future<String> signIn(SignInCommand command) async {
    final token = MockAuthData.getTokenForUser(
      command.phoneNumber,
      command.password,
    );
    if (token == null) {
      throw Exception('Invalid credentials');
    }
    _token = token;
    _currentUser = MockAuthData.getUserByPhone(command.phoneNumber);
    return token;
  }

  Future<bool> verifyPhone(VerifyPhoneCommand command) async {
    final ok = MockAuthData.isValidOtp(command.phoneNumber, command.otp);
    if (!ok) {
      throw Exception('Invalid OTP');
    }
    return true;
  }

  Future<String> register(RegisterCommand command) async {
    final existing = MockAuthData.getUserByPhone(command.phoneNumber);
    if (existing != null) {
      throw Exception('Phone number already registered');
    }
    // Simulate registration by adding to the mock list
    MockAuthData.mockUsers.add({
      'phoneNumber': command.phoneNumber,
      'password': command.password,
      'fullName': command.fullName,
      'isVerified': false,
      'otp': '999999',
      'token': 'mock_jwt_token_${command.fullName.toLowerCase().replaceAll(' ', '_')}',
    });
    return 'Registration successful for ${command.phoneNumber}';
  }

  Future<void> signOut() async {
    _token = null;
    _currentUser = null;
  }

  Future<bool> isLoggedIn() async => _token != null;

  Future<Map<String, dynamic>?> getCurrentUser() async => _currentUser;
}
// ...existing code...
