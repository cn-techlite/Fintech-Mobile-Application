import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/user_model.dart';

class AuthService {
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (email.trim().toLowerCase() != AppConstants.mockEmail ||
        password != AppConstants.mockPassword) {
      throw const AuthException('Incorrect email or password.');
    }

    return UserModel(
      fullName: 'John Doe',
      email: AppConstants.mockEmail,
      phoneNumber: '+234 801 234 5678',
    );
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
