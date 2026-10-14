import 'dart:convert';

import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/savings_tip.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService(this._client);

  final http.Client _client;

  Future<List<SavingsTip>> fetchSavingsTips() async {
    try {
      final response = await _client
          .get(Uri.parse(AppConstants.tipsEndpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Request failed (${response.statusCode}).');
      }

      final payload = jsonDecode(response.body) as List<dynamic>;
      return payload
          .map((item) => SavingsTip.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'Unable to load savings insights. Check your connection and retry.',
      );
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
