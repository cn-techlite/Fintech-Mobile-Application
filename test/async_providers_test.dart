import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/savings_plan.dart';
import 'package:fintech_mobile_application/providers/auth_provider.dart';
import 'package:fintech_mobile_application/providers/savings_provider.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:fintech_mobile_application/repositories/savings_repository.dart';
import 'package:fintech_mobile_application/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'AuthController exposes loading and authenticated AsyncValue states',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      final login = container
          .read(authControllerProvider.notifier)
          .login(
            email: AppConstants.mockEmail,
            password: AppConstants.mockPassword,
          );

      expect(container.read(authControllerProvider).isLoading, isTrue);
      expect(await login, isTrue);
      expect(
        container.read(authControllerProvider).value?.isAuthenticated,
        isTrue,
      );
    },
  );

  test('SavingsController persists a plan through AsyncNotifier', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);

    await container.read(savingsControllerProvider.future);
    final creation = container
        .read(savingsControllerProvider.notifier)
        .createPlan(
          name: 'New Car',
          productType: 'Target Savings',
          targetAmount: 500000,
          monthlyContribution: 50000,
          durationMonths: 12,
        );

    expect(container.read(savingsControllerProvider).isLoading, isTrue);
    expect(await creation, isTrue);
    expect(
      container.read(savingsControllerProvider).value?.createdPlans.single.name,
      'New Car',
    );
  });

  test('SavingsController can retry after a persistence failure', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = _FailOnceSavingsRepository(
      LocalStorageService(preferences),
    );
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        savingsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(savingsControllerProvider.future);
    final controller = container.read(savingsControllerProvider.notifier);

    final firstAttempt = await controller.createPlan(
      name: 'Emergency Fund',
      productType: 'Target Savings',
      targetAmount: 120000,
      monthlyContribution: 20000,
      durationMonths: 6,
    );

    expect(firstAttempt, isFalse);
    expect(container.read(savingsControllerProvider).hasError, isTrue);

    final retry = await controller.createPlan(
      name: 'Emergency Fund',
      productType: 'Target Savings',
      targetAmount: 120000,
      monthlyContribution: 20000,
      durationMonths: 6,
    );

    expect(retry, isTrue);
    expect(repository.savedPlans, hasLength(1));
    expect(
      container.read(savingsControllerProvider).value?.createdPlans,
      hasLength(1),
    );
  });
}

class _FailOnceSavingsRepository extends SavingsRepository {
  _FailOnceSavingsRepository(super.storageService);

  bool _shouldFail = true;
  List<SavingsPlan> savedPlans = const [];

  @override
  List<SavingsPlan> loadCreatedPlans() => const [];

  @override
  Future<void> saveCreatedPlans(List<SavingsPlan> plans) async {
    if (_shouldFail) {
      _shouldFail = false;
      throw StateError('Simulated storage failure');
    }
    savedPlans = plans;
  }
}
