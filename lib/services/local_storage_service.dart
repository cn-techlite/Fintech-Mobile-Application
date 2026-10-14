import 'dart:convert';

import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/savings_plan.dart';
import 'package:fintech_mobile_application/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  const LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  UserModel? readUser() {
    final value = _preferences.getString(AppConstants.userKey);
    if (value == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _preferences.setString(
      AppConstants.userKey,
      jsonEncode(user.toJson()),
    );
  }

  Future<void> clearUser() async {
    await _preferences.remove(AppConstants.userKey);
  }

  List<SavingsPlan> readSavingsPlans() {
    final value = _preferences.getString(AppConstants.savingsPlansKey);
    if (value == null) return const [];

    try {
      final items = jsonDecode(value) as List<dynamic>;
      return items
          .map((item) => SavingsPlan.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return const [];
    } on TypeError {
      return const [];
    }
  }

  Future<void> saveSavingsPlans(List<SavingsPlan> plans) async {
    await _preferences.setString(
      AppConstants.savingsPlansKey,
      jsonEncode(plans.map((plan) => plan.toJson()).toList()),
    );
  }
}
