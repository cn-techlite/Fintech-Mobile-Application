import 'dart:async';

import 'package:fintech_mobile_application/models/savings_plan.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:fintech_mobile_application/repositories/savings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavingsState {
  const SavingsState({this.createdPlans = const []});

  final List<SavingsPlan> createdPlans;

  List<SavingsPlan> get recentPlans {
    final samplePlans = [
      SavingsPlan(
        id: 'sample-emergency',
        name: 'Emergency Fund',
        productType: 'Target Savings',
        targetAmount: 120000,
        monthlyContribution: 20000,
        durationMonths: 12,
        createdAt: DateTime(2026, 9, 20),
      ),
      SavingsPlan(
        id: 'sample-education',
        name: 'School Fees',
        productType: 'Education Savings',
        targetAmount: 450000,
        monthlyContribution: 50000,
        durationMonths: 12,
        createdAt: DateTime(2026, 8, 12),
      ),
      SavingsPlan(
        id: 'sample-vacation',
        name: 'December Vacation',
        productType: 'Vacation Savings',
        targetAmount: 280000,
        monthlyContribution: 35000,
        durationMonths: 8,
        createdAt: DateTime(2026, 7, 5),
      ),
    ];
    return [...createdPlans, ...samplePlans].take(3).toList();
  }
}

class SavingsException implements Exception {
  const SavingsException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SavingsController extends AsyncNotifier<SavingsState> {
  late final SavingsRepository _repository = ref.read(
    savingsRepositoryProvider,
  );
  SavingsState _lastSuccessfulState = const SavingsState();

  @override
  FutureOr<SavingsState> build() {
    ref.watch(savingsRepositoryProvider);
    final initialState = SavingsState(
      createdPlans: _repository.loadCreatedPlans(),
    );
    _lastSuccessfulState = initialState;
    return initialState;
  }

  Future<bool> createPlan({
    required String name,
    required String productType,
    required double targetAmount,
    required double monthlyContribution,
    required int durationMonths,
  }) async {
    // AsyncError has no current value. Fall back to the last successfully
    // loaded/saved state so a failed persistence attempt can be retried.
    final current = state.value ?? _lastSuccessfulState;
    state = const AsyncLoading();

    final plan = SavingsPlan(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      productType: productType,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      durationMonths: durationMonths,
      createdAt: DateTime.now(),
    );
    final updatedPlans = [plan, ...current.createdPlans];

    try {
      await _repository.saveCreatedPlans(updatedPlans);
      final savedState = SavingsState(createdPlans: updatedPlans);
      _lastSuccessfulState = savedState;
      state = AsyncData(savedState);
      return true;
    } catch (_, stackTrace) {
      const error = SavingsException(
        'Could not save this plan. Please try again.',
      );
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

extension SavingsAsyncValue on AsyncValue<SavingsState> {
  List<SavingsPlan> get recentPlans =>
      value?.recentPlans ?? const SavingsState().recentPlans;

  bool get isSaving => isLoading;

  String? get errorMessage {
    final currentError = error;
    if (currentError is SavingsException) return currentError.message;
    return currentError == null ? null : 'Unable to create savings.';
  }
}

final savingsControllerProvider =
    AsyncNotifierProvider<SavingsController, SavingsState>(
      SavingsController.new,
    );
