import 'package:fintech_mobile_application/models/savings_plan.dart';
import 'package:fintech_mobile_application/models/savings_product.dart';
import 'package:fintech_mobile_application/services/local_storage_service.dart';

class SavingsRepository {
  const SavingsRepository(this._storageService);

  final LocalStorageService _storageService;

  static const products = <SavingsProduct>[
    SavingsProduct(
      name: 'Target Savings',
      interestRate: 12,
      duration: '12 Months',
      description: 'Save consistently toward a personal financial target.',
      minimumDeposit: 5000,
    ),
    SavingsProduct(
      name: 'Fixed Deposit',
      interestRate: 18,
      duration: '6 Months',
      description: 'Lock away funds and earn our highest fixed return.',
      minimumDeposit: 50000,
    ),
    SavingsProduct(
      name: 'Education Savings',
      interestRate: 10,
      duration: 'Flexible',
      description: 'Build a reliable fund for tuition and school expenses.',
      minimumDeposit: 10000,
    ),
    SavingsProduct(
      name: 'Vacation Savings',
      interestRate: 8,
      duration: 'Flexible',
      description: 'Plan your next trip with convenient monthly deposits.',
      minimumDeposit: 5000,
    ),
  ];

  List<SavingsPlan> loadCreatedPlans() => _storageService.readSavingsPlans();

  Future<void> saveCreatedPlans(List<SavingsPlan> plans) =>
      _storageService.saveSavingsPlans(plans);
}
