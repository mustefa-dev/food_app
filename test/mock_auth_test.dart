import 'package:flutter_test/flutter_test.dart';
import 'package:savory_app/features/auth/data/mock_auth_data.dart';
import 'package:savory_app/features/auth/data/mock_auth_repository.dart';
import 'package:savory_app/features/auth/data/auth_repository_factory.dart';
import 'package:savory_app/features/auth/models/auth_models.dart';

void main() {
  group('Mock Auth System Tests', () {
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
    });

    test('should validate correct credentials', () {
      expect(
        MockAuthData.isValidCredentials('+1234567890', 'password123'),
        isTrue,
      );
      expect(
        MockAuthData.isValidCredentials('+1234567890', 'wrongpassword'),
        isFalse,
      );
    });

    test('should return token for valid user', () {
      final token = MockAuthData.getTokenForUser('+1234567890', 'password123');
      expect(token, equals('mock_jwt_token_john_doe'));
    });

    test('should validate OTP correctly', () {
      expect(MockAuthData.isValidOtp('+1234567890', '123456'), isTrue);
      expect(MockAuthData.isValidOtp('+1234567890', '000000'), isFalse);
    });

    test('should sign in with valid credentials', () async {
      final cmd = MockAuthData.createMockSignInCommand();
      final token = await mockRepository.signIn(cmd);

      expect(token, isNotNull);
      expect(token, equals('mock_jwt_token_john_doe'));

      final isLoggedIn = await mockRepository.isLoggedIn();
      expect(isLoggedIn, isTrue);
    });

    test('should throw exception for invalid credentials', () async {
      final cmd = SignInCommand(
        phoneNumber: '+1234567890',
        password: 'wrongpassword',
      );

      expect(
        () async => await mockRepository.signIn(cmd),
        throwsException,
      );
    });

    test('factory should create mock repository when configured', () {
      final repository = AuthRepositoryFactory.create();
      expect(repository, isA<MockAuthRepository>());
    });

    test('should verify phone with correct OTP', () async {
      final cmd = MockAuthData.createMockVerifyPhoneCommand();
      final result = await mockRepository.verifyPhone(cmd);

      expect(result, isTrue);
    });

    test('should register new user successfully', () async {
      final cmd = MockAuthData.createMockRegisterCommand(
        phoneNumber: '+9999999999', // New phone number
      );

      final result = await mockRepository.register(cmd);
      expect(result, contains('Registration successful'));
    });

    test('should sign out successfully', () async {
      // First sign in
      final signInCmd = MockAuthData.createMockSignInCommand();
      await mockRepository.signIn(signInCmd);

      expect(await mockRepository.isLoggedIn(), isTrue);

      // Then sign out
      await mockRepository.signOut();
      expect(await mockRepository.isLoggedIn(), isFalse);
    });
  });

  group('Mock Data Scenarios', () {
    test('should provide different user types', () {
      final users = MockAuthData.mockUsers;

      // Regular user
      expect(users[0]['phoneNumber'], equals('+1234567890'));
      expect(users[0]['isVerified'], isTrue);

      // Admin user
      expect(users[2]['fullName'], equals('Admin User'));

      // Unverified user
      expect(users[3]['isVerified'], isFalse);
    });

    test('should create mock commands easily', () {
      final signInCmd = MockAuthData.createMockSignInCommand();
      expect(signInCmd.phoneNumber, equals('+1234567890'));
      expect(signInCmd.password, equals('password123'));

      final registerCmd = MockAuthData.createMockRegisterCommand();
      expect(registerCmd.fullName, equals('New User'));
      expect(registerCmd.phoneNumber, equals('+3333333333'));
    });
  });
}
