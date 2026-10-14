import 'package:fintech_mobile_application/models/savings_product.dart';
import 'package:fintech_mobile_application/screens/create_savings_screen.dart';
import 'package:fintech_mobile_application/utils/currency_formatter.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SavingsDetailsScreen extends StatelessWidget {
  const SavingsDetailsScreen({required this.product, super.key});

  final SavingsProduct product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Savings Details',
          type: AppTextType.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.pagePadding,
            8.responsiveSize,
            SizeConfig.pagePadding,
            SizeConfig.pagePadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: SizeConfig.contentMaxWidth(
                  SizeConfig.formContentMaxWidth,
                ),
              ),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24.responsiveSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 34.responsiveSize,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        child: Icon(
                          Icons.savings_outlined,
                          size: 34.responsiveSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 20.responsiveSize),
                      AppText(
                        text: product.name,
                        type: AppTextType.headlineSmall,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w900,
                      ),
                      SizedBox(height: 8.responsiveSize),
                      AppText(
                        text: product.description,
                        type: AppTextType.bodyMedium,
                        textAlign: TextAlign.center,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 28.responsiveSize),
                      _DetailRow(
                        icon: Icons.percent,
                        label: 'Interest Rate',
                        value: '${product.interestRate.toStringAsFixed(0)}%',
                      ),
                      const Divider(height: 28),
                      _DetailRow(
                        icon: Icons.payments_outlined,
                        label: 'Minimum Deposit',
                        value: formatNaira(product.minimumDeposit),
                      ),
                      const Divider(height: 28),
                      _DetailRow(
                        icon: Icons.calendar_month_outlined,
                        label: 'Duration',
                        value: product.duration,
                      ),
                      SizedBox(height: 32.responsiveSize),
                      AppButton(
                        text: 'Create Savings',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                CreateSavingsScreen(initialProduct: product),
                          ),
                        ),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: Theme.of(context).colorScheme.primary),
      SizedBox(width: 12.responsiveSize),
      Expanded(
        child: AppText(text: label, type: AppTextType.bodyMedium),
      ),
      AppText(
        text: value,
        type: AppTextType.labelLarge,
        fontWeight: FontWeight.w800,
      ),
    ],
  );
}
