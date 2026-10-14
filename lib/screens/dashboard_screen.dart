import 'package:fintech_mobile_application/models/savings_plan.dart';
import 'package:fintech_mobile_application/models/savings_tip.dart';
import 'package:fintech_mobile_application/providers/auth_provider.dart';
import 'package:fintech_mobile_application/providers/navigation_provider.dart';
import 'package:fintech_mobile_application/providers/savings_provider.dart';
import 'package:fintech_mobile_application/providers/tips_provider.dart';
import 'package:fintech_mobile_application/screens/create_savings_screen.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:fintech_mobile_application/widgets/async_state_widgets.dart';
import 'package:fintech_mobile_application/widgets/quick_action_card.dart';
import 'package:fintech_mobile_application/widgets/savings_plan_card.dart';
import 'package:fintech_mobile_application/widgets/section_header.dart';
import 'package:fintech_mobile_application/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(savingsTipsProvider);
    try {
      await ref.read(savingsTipsProvider.future);
    } catch (_) {
      // The error state below gives the user a retry action.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      authControllerProvider.select((state) => state.user),
    );

    // During logout, AnimatedSwitcher keeps this screen alive briefly after
    // the auth state has already cleared the user.
    if (user == null) return const SizedBox.shrink();

    final savingsState = ref.watch(savingsControllerProvider);
    final tips = ref.watch(savingsTipsProvider);

    return RefreshIndicator(
      onRefresh: () => _refresh(ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          SizeConfig.pagePadding,
          8.responsiveSize,
          SizeConfig.pagePadding,
          32.responsiveSize,
        ),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: SizeConfig.contentMaxWidth(
                  SizeConfig.wideContentMaxWidth,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final useColumns =
                      constraints.maxWidth >= SizeConfig.twoColumnBreakpoint;
                  final quickActions = _QuickActions(ref: ref);
                  final recentSavings = _RecentSavings(
                    plans: savingsState.recentPlans,
                  );
                  final insights = _SavingsInsights(
                    tips: tips,
                    onRetry: () => ref.invalidate(savingsTipsProvider),
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Good Morning, ${user.fullName}',
                        type: AppTextType.headlineSmall,
                        fontWeight: FontWeight.w900,
                      ),
                      SizedBox(height: 6.responsiveSize),
                      AppText(
                        text: 'Here is how your money is doing today.',
                        type: AppTextType.bodyMedium,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 22.responsiveSize),
                      if (useColumns)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 3,
                              child: SummaryCard(amount: 850000),
                            ),
                            SizedBox(width: 20.responsiveSize),
                            Expanded(flex: 2, child: quickActions),
                          ],
                        )
                      else ...[
                        const SummaryCard(amount: 850000),
                        SizedBox(height: 28.responsiveSize),
                        quickActions,
                      ],
                      SizedBox(height: 28.responsiveSize),
                      if (useColumns)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: recentSavings),
                            SizedBox(width: 20.responsiveSize),
                            Expanded(child: insights),
                          ],
                        )
                      else ...[
                        recentSavings,
                        SizedBox(height: 20.responsiveSize),
                        insights,
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionHeader(title: 'Quick Actions'),
      SizedBox(height: 12.responsiveSize),
      Row(
        children: [
          QuickActionCard(
            icon: Icons.add_circle_outline,
            label: 'Create Savings',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CreateSavingsScreen(),
              ),
            ),
          ),
          SizedBox(width: 12.responsiveSize),
          QuickActionCard(
            icon: Icons.grid_view_outlined,
            label: 'View Products',
            onTap: () => ref.read(navigationIndexProvider.notifier).select(1),
          ),
        ],
      ),
    ],
  );
}

class _RecentSavings extends StatelessWidget {
  const _RecentSavings({required this.plans});

  final List<SavingsPlan> plans;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader(title: 'Recent Savings'),
      SizedBox(height: 12.responsiveSize),
      ...plans.map(
        (plan) => Padding(
          padding: EdgeInsets.only(bottom: 10.responsiveSize),
          child: SavingsPlanCard(plan: plan),
        ),
      ),
    ],
  );
}

class _SavingsInsights extends StatelessWidget {
  const _SavingsInsights({required this.tips, required this.onRetry});

  final AsyncValue<List<SavingsTip>> tips;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader(title: 'Savings Insights'),
      SizedBox(height: 6.responsiveSize),
      AppText(
        text: 'Live content from JSONPlaceholder',
        type: AppTextType.bodySmall,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      SizedBox(height: 10.responsiveSize),
      tips.when(
        loading: () => const LoadingState(label: 'Loading savings insights...'),
        error: (error, _) =>
            ErrorState(message: error.toString(), onRetry: onRetry),
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'No savings insights are available.')
            : Column(
                children: items
                    .map(
                      (tip) => Padding(
                        padding: EdgeInsets.only(bottom: 12.responsiveSize),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.lightbulb_outline),
                            title: AppText(
                              text: tip.title,
                              type: AppTextType.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: AppText(
                              text: tip.body,
                              type: AppTextType.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}
