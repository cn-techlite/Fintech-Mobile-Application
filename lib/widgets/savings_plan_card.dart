import 'package:fintech_mobile_application/models/savings_plan.dart';
import 'package:fintech_mobile_application/utils/currency_formatter.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SavingsPlanCard extends StatelessWidget {
  const SavingsPlanCard({required this.plan, super.key});

  final SavingsPlan plan;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.responsiveSize),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.responsiveSize,
              backgroundColor: colors.secondaryContainer,
              child: Icon(Icons.savings_outlined, color: colors.secondary),
            ),
            SizedBox(width: 14.responsiveSize),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: plan.name,
                    type: AppTextType.titleSmall,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: 4.responsiveSize),
                  AppText(
                    text: '${plan.productType} • Monthly',
                    type: AppTextType.bodyMedium,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.responsiveSize),
            AppText(
              text: formatNaira(plan.targetAmount),
              type: AppTextType.labelLarge,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    );
  }
}
