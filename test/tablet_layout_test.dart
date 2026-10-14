import 'dart:convert';

import 'package:fintech_mobile_application/core/app.dart';
import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/savings_tip.dart';
import 'package:fintech_mobile_application/models/user_model.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:fintech_mobile_application/providers/tips_provider.dart';
import 'package:fintech_mobile_application/screens/create_savings_screen.dart';
import 'package:fintech_mobile_application/screens/login_screen.dart';
import 'package:fintech_mobile_application/screens/products_screen.dart';
import 'package:fintech_mobile_application/screens/profile_screen.dart';
import 'package:fintech_mobile_application/screens/savings_details_screen.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('primary screens adapt without overflow on an iPad viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(834, 1194));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    SharedPreferences.setMockInitialValues({
      AppConstants.userKey: jsonEncode(
        const UserModel(
          fullName: 'John Doe',
          email: AppConstants.mockEmail,
          phoneNumber: '+234 801 234 5678',
        ).toJson(),
      ),
    });
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          savingsTipsProvider.overrideWith(
            (ref) async => const [
              SavingsTip(
                id: 1,
                title: 'Automate your savings',
                body: 'Schedule a contribution every month.',
              ),
            ],
          ),
        ],
        child: const KoinsSavingsApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(ProductCard), findsNWidgets(4));
    expect(tester.takeException(), isNull);

    await tester.tap(find.widgetWithText(AppButton, 'View Details').first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsDetailsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.widgetWithText(AppButton, 'Create Savings'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateSavingsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1194, 834));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('login remains centered and overflow-free on an iPad', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(834, 1194));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const KoinsSavingsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1194, 834));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
