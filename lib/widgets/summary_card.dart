import 'package:fintech_mobile_application/core/theme/app_theme.dart';
import 'package:fintech_mobile_application/utils/currency_formatter.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({required this.amount, super.key});

  final num amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.responsiveSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.responsiveSize),
        gradient: const LinearGradient(
          colors: [AppTheme.brand, Color(0xFF11966C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330B6E4F),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'Total Savings',
            type: AppTextType.bodyMedium,
            color: Colors.white70,
          ),
          SizedBox(height: 8.responsiveSize),
          AppText(
            text: formatNaira(amount),
            type: AppTextType.headlineLarge,
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
          SizedBox(height: 20.responsiveSize),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 18.responsiveSize,
              ),
              SizedBox(width: 6.responsiveSize),
              const Expanded(
                child: AppText(
                  text: 'Your savings are growing',
                  type: AppTextType.bodyMedium,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
