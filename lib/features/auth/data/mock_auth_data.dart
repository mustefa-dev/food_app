// ...existing code...
import '../models/auth_models.dart';

class MockAuthData {
  static final List<Map<String, dynamic>> mockUsers = [
    {
      'phoneNumber': '+1234567890',
      'password': 'password123',
      'fullName': 'John Doe',
      'isVerified': true,
      'otp': '123456',
      'token': 'mock_jwt_token_john_doe',
    },
    {
      'phoneNumber': '+0987654321',
      'password': 'secret',
      'fullName': 'Jane Smith',
      'isVerified': true,
      'otp': '654321',
      'token': 'mock_jwt_token_jane_smith',
    },
    {
      'phoneNumber': '+1111111111',
      'password': 'adminpass',
      'fullName': 'Admin User',
      'isVerified': true,
      'otp': '121212',
      'token': 'mock_jwt_token_admin',
      'role': 'admin',
    },
    {
      'phoneNumber': '+2222222222',
      'password': 'password123',
      'fullName': 'Unverified User',
      'isVerified': false,
      'otp': '000999',
      'token': 'mock_jwt_token_unverified',
    },
  ];

  static bool isValidCredentials(String phoneNumber, String password) {
    return mockUsers.any((u) =>
        u['phoneNumber'] == phoneNumber && u['password'] == password);
  }

  static String? getTokenForUser(String phoneNumber, String password) {
    final user = mockUsers.firstWhere(
      (u) => u['phoneNumber'] == phoneNumber && u['password'] == password,
      orElse: () => {},
    );
    return user['token'] as String?;
  }

  static Map<String, dynamic>? getUserByPhone(String phoneNumber) {
    try {
      return mockUsers.firstWhere((u) => u['phoneNumber'] == phoneNumber);
    } catch (_) {
      return null;
    }
  }

  static bool isValidOtp(String phoneNumber, String otp) {
    final user = getUserByPhone(phoneNumber);
    if (user == null) return false;
    return user['otp'] == otp;
  }

  static SignInCommand createMockSignInCommand() {
    return const SignInCommand(
      phoneNumber: '+1234567890',
      password: 'password123',
    );
  }

  static VerifyPhoneCommand createMockVerifyPhoneCommand() {
    return const VerifyPhoneCommand(
      phoneNumber: '+1234567890',
      otp: '123456',
    );
  }

  static RegisterCommand createMockRegisterCommand({
    String fullName = 'New User',
    String phoneNumber = '+3333333333',
    String password = 'newpassword',
  }) {
    return RegisterCommand(
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}
// ...existing code...
