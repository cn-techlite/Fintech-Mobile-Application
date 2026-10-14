import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.responsiveSize),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.responsiveSize,
              vertical: 18.responsiveSize,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: Icon(icon, color: colors.onPrimaryContainer),
                ),
                SizedBox(height: 10.responsiveSize),
                AppText(
                  text: label,
                  type: AppTextType.labelLarge,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
