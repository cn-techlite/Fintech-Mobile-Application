import 'dart:convert';
import 'dart:io';

import 'package:fintech_mobile_application/core/app.dart';
import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/models/savings_tip.dart';
import 'package:fintech_mobile_application/models/user_model.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:fintech_mobile_application/providers/tips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _generateScreenshots = bool.fromEnvironment('GENERATE_SCREENSHOTS');

void main() {
  if (_generateScreenshots) setUpAll(_loadAppFonts);

  testWidgets(
    'generate assessment screenshots',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      SharedPreferences.setMockInitialValues({});
      var preferences = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
          child: const KoinsSavingsApp(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(KoinsSavingsApp),
        matchesGoldenFile('../screenshots/login.png'),
      );

      await tester.pumpWidget(const SizedBox.shrink());
      SharedPreferences.setMockInitialValues({
        AppConstants.userKey: jsonEncode(
          const UserModel(
            fullName: 'John Doe',
            email: AppConstants.mockEmail,
            phoneNumber: '+234 801 234 5678',
          ).toJson(),
        ),
      });
      preferences = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(preferences),
            savingsTipsProvider.overrideWith(
              (ref) async => const [
                SavingsTip(
                  id: 1,
                  title: 'Automate your monthly savings',
                  body: 'Set a fixed contribution and pay yourself first.',
                ),
              ],
            ),
          ],
          child: const KoinsSavingsApp(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(KoinsSavingsApp),
        matchesGoldenFile('../screenshots/dashboard.png'),
      );

      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(KoinsSavingsApp),
        matchesGoldenFile('../screenshots/products.png'),
      );

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(KoinsSavingsApp),
        matchesGoldenFile('../screenshots/profile.png'),
      );
    },
    skip: !_generateScreenshots,
  );
}

Future<void> _loadAppFonts() async {
  var flutterRoot = File(Platform.resolvedExecutable).parent;
  for (var index = 0; index < 5; index++) {
    flutterRoot = flutterRoot.parent;
  }
  final fontDirectory = Directory(
    '${flutterRoot.path}/bin/cache/artifacts/material_fonts',
  );

  Future<ByteData> load(String name) async {
    final bytes = await File('${fontDirectory.path}/$name').readAsBytes();
    return ByteData.sublistView(bytes);
  }

  await Future.wait([
    (FontLoader('Roboto')..addFont(load('Roboto-Regular.ttf'))).load(),
    (FontLoader(
      'MaterialIcons',
    )..addFont(load('MaterialIcons-Regular.otf'))).load(),
  ]);
}
