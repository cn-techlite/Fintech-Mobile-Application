import 'package:fintech_mobile_application/providers/auth_provider.dart';
import 'package:fintech_mobile_application/providers/navigation_provider.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Log out?', type: AppTextType.headlineSmall),
        content: const AppText(
          text: 'You will return to the login screen.',
          type: AppTextType.bodyMedium,
        ),
        actions: [
          AppButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context, false),
            variant: AppButtonVariant.text,
            compact: true,
          ),
          AppButton(
            text: 'Logout',
            onPressed: () => Navigator.pop(context, true),
            compact: true,
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // Navigation state outlives the authenticated shell. Reset it before
      // logout so the next successful login always starts on Dashboard.
      ref.read(navigationIndexProvider.notifier).reset();
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      authControllerProvider.select((state) => state.user),
    );

    // The authenticated shell remains mounted for the exit animation after
    // logout clears the user, so this transient state must be null-safe.
    if (user == null) return const SizedBox.shrink();

    return ListView(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.pagePadding,
        16.responsiveSize,
        SizeConfig.pagePadding,
        32.responsiveSize,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: SizeConfig.contentMaxWidth(
                SizeConfig.formContentMaxWidth,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 46.responsiveSize,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: AppText(
                    text: 'JD',
                    type: AppTextType.headlineMedium,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 24.responsiveSize),
                Card(
                  child: Column(
                    children: [
                      _ProfileTile(
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: user.fullName,
                      ),
                      const Divider(height: 1),
                      _ProfileTile(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user.email,
                      ),
                      const Divider(height: 1),
                      _ProfileTile(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: user.phoneNumber,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.responsiveSize),
                AppButton(
                  text: 'Logout',
                  onPressed: () => _logout(context, ref),
                  icon: const Icon(Icons.logout),
                  variant: AppButtonVariant.outlined,
                  textColor: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: AppText(text: label, type: AppTextType.titleMedium),
    subtitle: AppText(text: value, type: AppTextType.bodyMedium),
  );
}
