import 'package:fintech_mobile_application/core/theme/app_theme.dart';
import 'package:fintech_mobile_application/providers/auth_provider.dart';
import 'package:fintech_mobile_application/screens/home_shell.dart';
import 'package:fintech_mobile_application/screens/login_screen.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KoinsSavingsApp extends ConsumerWidget {
  const KoinsSavingsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      title: 'Koins Savings',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        SizeConfig.init(context);
        return child ?? const SizedBox.shrink();
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: authState.isAuthenticated
            ? const HomeShell(key: ValueKey('home'))
            : const LoginScreen(key: ValueKey('login')),
      ),
    );
  }
}
