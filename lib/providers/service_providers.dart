import 'package:fintech_mobile_application/repositories/auth_repository.dart';
import 'package:fintech_mobile_application/repositories/savings_repository.dart';
import 'package:fintech_mobile_application/repositories/tips_repository.dart';
import 'package:fintech_mobile_application/services/api_service.dart';
import 'package:fintech_mobile_application/services/auth_service.dart';
import 'package:fintech_mobile_application/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw StateError('SharedPreferences must be overridden in main.'),
);

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(ref.watch(sharedPreferencesProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) =>
      AuthRepository(AuthService(), ref.watch(localStorageServiceProvider)),
);

final savingsRepositoryProvider = Provider<SavingsRepository>(
  (ref) => SavingsRepository(ref.watch(localStorageServiceProvider)),
);

final tipsRepositoryProvider = Provider<TipsRepository>(
  (ref) => TipsRepository(ApiService(ref.watch(httpClientProvider))),
);
