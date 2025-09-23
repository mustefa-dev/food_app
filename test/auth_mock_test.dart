import 'package:flutter_test/flutter_test.dart';
import 'package:savory_app/features/auth/data/mock_auth_data.dart' as mock_data;
import 'package:savory_app/features/auth/data/mock_auth_repository.dart' as auth_repo;
import 'package:savory_app/features/auth/models/auth_models.dart' as auth_models;

void main() {
  group('Mock Auth Data Tests', () {
    late auth_repo.MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = auth_repo.MockAuthRepository();
    });

    test('should validate correct credentials', () {
      expect(
        mock_data.MockAuthData.isValidCredentials('+1234567890', 'password123'),
        isTrue,
      );
      expect(
        mock_data.MockAuthData.isValidCredentials('+1234567890', 'wrongpassword'),
        isFalse,
      );
    });

    test('should return token for valid user', () {
      final token = mock_data.MockAuthData.getTokenForUser('+1234567890', 'password123');
      expect(token, equals('mock_jwt_token_john_doe'));
    });

    test('should validate OTP correctly', () {
      expect(mock_data.MockAuthData.isValidOtp('+1234567890', '123456'), isTrue);
      expect(mock_data.MockAuthData.isValidOtp('+1234567890', '000000'), isFalse);
    });

    test('should sign in with valid credentials', () async {
      final cmd = mock_data.MockAuthData.createMockSignInCommand();
      final token = await mockRepository.signIn(cmd);

      expect(token, isNotNull);
      expect(token, equals('mock_jwt_token_john_doe'));

      final isLoggedIn = await mockRepository.isLoggedIn();
      expect(isLoggedIn, isTrue);
    });

    test('should throw exception for invalid credentials', () async {
      final cmd = auth_models.SignInCommand(
        phoneNumber: '+1234567890',
        password: 'wrongpassword',
      );

      expect(
        () async => await mockRepository.signIn(cmd),
        throwsException,
      );
    });

    test('should verify phone with correct OTP', () async {
      final cmd = mock_data.MockAuthData.createMockVerifyPhoneCommand();
      final result = await mockRepository.verifyPhone(cmd);

      expect(result, isTrue);
    });

    test('should throw exception for invalid OTP', () async {
      final cmd = auth_models.VerifyPhoneCommand(
        phoneNumber: '+1234567890',
        otp: '000000',
      );

      expect(
        () async => await mockRepository.verifyPhone(cmd),
        throwsException,
      );
    });

    test('should register new user successfully', () async {
      final cmd = mock_data.MockAuthData.createMockRegisterCommand(
        phoneNumber: '+9999999999', // New phone number
      );

      final result = await mockRepository.register(cmd);
      expect(result, contains('Registration successful'));
    });

    test('should throw exception for existing phone number', () async {
      final cmd = mock_data.MockAuthData.createMockRegisterCommand(
        phoneNumber: '+1234567890', // Existing phone number
      );

      expect(
        () async => await mockRepository.register(cmd),
        throwsException,
      );
    });

    test('should sign out successfully', () async {
      // First sign in
      final signInCmd = mock_data.MockAuthData.createMockSignInCommand();
      await mockRepository.signIn(signInCmd);

      expect(await mockRepository.isLoggedIn(), isTrue);

      // Then sign out
      await mockRepository.signOut();
      expect(await mockRepository.isLoggedIn(), isFalse);
    });

    test('should get current user info', () async {
      final signInCmd = mock_data.MockAuthData.createMockSignInCommand();
      await mockRepository.signIn(signInCmd);

      final user = await mockRepository.getCurrentUser();
      expect(user, isNotNull);
      expect(user!['phoneNumber'], equals('+1234567890'));
      expect(user['fullName'], equals('John Doe'));
    });
  });

  group('Mock Data Scenarios', () {
    test('should provide different user types', () {
      final users = mock_data.MockAuthData.mockUsers;

      // Regular user
      expect(users[0]['phoneNumber'], equals('+1234567890'));
      expect(users[0]['isVerified'], isTrue);

      // Admin user
      expect(users[2]['fullName'], equals('Admin User'));

      // Unverified user
      expect(users[3]['isVerified'], isFalse);
    });

    test('should create mock commands easily', () {
      final signInCmd = mock_data.MockAuthData.createMockSignInCommand();
      expect(signInCmd.phoneNumber, equals('+1234567890'));
      expect(signInCmd.password, equals('password123'));

      final registerCmd = mock_data.MockAuthData.createMockRegisterCommand();
      expect(registerCmd.fullName, equals('New User'));
      expect(registerCmd.phoneNumber, equals('+3333333333'));
    });
  });
}
