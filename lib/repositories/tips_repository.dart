import 'package:fintech_mobile_application/models/savings_tip.dart';
import 'package:fintech_mobile_application/services/api_service.dart';

class TipsRepository {
  const TipsRepository(this._apiService);

  final ApiService _apiService;

  Future<List<SavingsTip>> fetchTips() => _apiService.fetchSavingsTips();
}
