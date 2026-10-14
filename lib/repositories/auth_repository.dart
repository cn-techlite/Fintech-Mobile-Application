import 'package:fintech_mobile_application/models/user_model.dart';
import 'package:fintech_mobile_application/services/auth_service.dart';
import 'package:fintech_mobile_application/services/local_storage_service.dart';

class AuthRepository {
  const AuthRepository(this._authService, this._storageService);

  final AuthService _authService;
  final LocalStorageService _storageService;

  UserModel? restoreUser() => _storageService.readUser();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final user = await _authService.login(email: email, password: password);
    await _storageService.saveUser(user);
    return user;
  }

  Future<void> logout() => _storageService.clearUser();
}
