import 'dart:async';

import 'package:fintech_mobile_application/models/user_model.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:fintech_mobile_application/repositories/auth_repository.dart';
import 'package:fintech_mobile_application/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState._({this.user});

  const AuthState.unauthenticated() : this._();

  const AuthState.authenticated(UserModel user) : this._(user: user);

  final UserModel? user;

  bool get isAuthenticated => user != null;
}

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _repository = ref.read(authRepositoryProvider);

  @override
  FutureOr<AuthState> build() {
    // Watching the dependency keeps the controller aligned with provider
    // overrides while the late field avoids repeated lookups in commands.
    ref.watch(authRepositoryProvider);
    final user = _repository.restoreUser();
    return user == null
        ? const AuthState.unauthenticated()
        : AuthState.authenticated(user);
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final user = await _repository.login(email: email, password: password);
      state = AsyncData(AuthState.authenticated(user));
      return true;
    } on AuthException catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await _repository.logout();
      state = const AsyncData(AuthState.unauthenticated());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

extension AuthAsyncValue on AsyncValue<AuthState> {
  UserModel? get user => value?.user;

  bool get isAuthenticated => value?.isAuthenticated ?? false;

  String? get errorMessage {
    final currentError = error;
    if (currentError == null) return null;
    if (currentError is AuthException) return currentError.message;
    return 'Something went wrong. Please retry.';
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
