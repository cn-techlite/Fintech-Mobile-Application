import 'package:fintech_mobile_application/core/constants/app_constants.dart';
import 'package:fintech_mobile_application/core/theme/app_theme.dart';
import 'package:fintech_mobile_application/providers/auth_provider.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/utils/validators.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/app_snackbar.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:fintech_mobile_application/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final colors = Theme.of(context).colorScheme;

    ref.listen(authControllerProvider, (previous, next) {
      if (!next.hasError || previous?.error == next.error) return;
      AppSnackBar.showError(
        context,
        next.errorMessage ?? 'Unable to sign in. Please retry.',
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.pagePadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: SizeConfig.contentMaxWidth(460),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 34.responsiveSize,
                      backgroundColor: AppTheme.brand,
                      child: Icon(
                        Icons.savings_outlined,
                        color: Colors.white,
                        size: 34.responsiveSize,
                      ),
                    ),
                    SizedBox(height: 24.responsiveSize),
                    const AppText(
                      text: 'Welcome to Koins',
                      type: AppTextType.headlineMedium,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w900,
                    ),
                    SizedBox(height: 8.responsiveSize),
                    AppText(
                      text: 'Sign in to continue building your savings.',
                      type: AppTextType.bodyMedium,
                      textAlign: TextAlign.center,
                      color: colors.onSurfaceVariant,
                    ),
                    SizedBox(height: 32.responsiveSize),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: AppConstants.mockEmail,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    SizedBox(height: 16.responsiveSize),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Minimum 8 characters',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      onFieldSubmitted: (_) => _login(),
                      suffixIcon: AppIconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        text: 'Forgot Password?',
                        onPressed: () {},
                        variant: AppButtonVariant.text,
                        compact: true,
                      ),
                    ),
                    AppButton(
                      text: 'Login',
                      onPressed: _login,
                      isLoading: authState.isLoading,
                    ),
                    SizedBox(height: 12.responsiveSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(
                          text: "Don't have an account?",
                          type: AppTextType.bodyMedium,
                        ),
                        AppButton(
                          text: 'Register',
                          onPressed: () {},
                          variant: AppButtonVariant.text,
                          compact: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
