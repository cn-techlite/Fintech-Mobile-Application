import 'dart:convert';

import 'package:fintech_mobile_application/core/app.dart';
import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/user_model.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:fintech_mobile_application/providers/tips_provider.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('login screen validates email and password', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const KoinsSavingsApp(),
      ),
    );

    expect(find.text('Welcome to Koins'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email Address'),
      'invalid',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'short',
    );
    await tester.tap(find.widgetWithText(AppButton, 'Login'));
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Password must be at least 8 characters.'),
      findsOneWidget,
    );
  });

  testWidgets('login failure is presented in a styled snackbar', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const KoinsSavingsApp(),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email Address'),
      'wrong@bank.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'Password123',
    );
    await tester.tap(find.widgetWithText(AppButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('logging in after logout opens the dashboard', (tester) async {
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
          savingsTipsProvider.overrideWith((ref) async => const []),
        ],
        child: const KoinsSavingsApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppButton, 'Logout'));
    await tester.pumpAndSettle();

    final confirmationButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(AppButton, 'Logout'),
    );
    await tester.tap(confirmationButton);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Welcome to Koins'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email Address'),
      AppConstants.mockEmail,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      AppConstants.mockPassword,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Login'));
    await tester.pumpAndSettle();

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 0);
    expect(find.text('Good Morning, John Doe'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
