// ...existing code...
class SignInCommand {
  final String phoneNumber;
  final String password;
  const SignInCommand({required this.phoneNumber, required this.password});
}

class VerifyPhoneCommand {
  final String phoneNumber;
  final String otp;
  const VerifyPhoneCommand({required this.phoneNumber, required this.otp});
}

class RegisterCommand {
  final String fullName;
  final String phoneNumber;
  final String password;
  const RegisterCommand({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
  });
}
// ...existing code...
