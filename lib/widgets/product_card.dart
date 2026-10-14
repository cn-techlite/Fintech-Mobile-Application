import 'package:fintech_mobile_application/models/savings_product.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onView, super.key});

  final SavingsProduct product;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.responsiveSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: colors.primary,
                  ),
                ),
                SizedBox(width: 12.responsiveSize),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: product.name,
                        type: AppTextType.titleMedium,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(height: 4.responsiveSize),
                      AppText(
                        text: product.description,
                        type: AppTextType.bodyMedium,
                        color: colors.onSurfaceVariant,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.responsiveSize),
            SizedBox(height: 18.responsiveSize),
            Wrap(
              spacing: 24.responsiveSize,
              runSpacing: 12.responsiveSize,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _ProductStat(
                  label: 'Interest',
                  value: '${product.interestRate.toStringAsFixed(0)}%',
                ),
                _ProductStat(label: 'Duration', value: product.duration),
                AppButton(
                  text: 'View Details',
                  onPressed: onView,
                  btnColor: colors.secondaryContainer,
                  textColor: colors.onSecondaryContainer,
                  compact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductStat extends StatelessWidget {
  const _ProductStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(
        text: label,
        type: AppTextType.labelSmall,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      SizedBox(height: 2.responsiveSize),
      AppText(
        text: value,
        type: AppTextType.labelLarge,
        fontWeight: FontWeight.w800,
      ),
    ],
  );
}
