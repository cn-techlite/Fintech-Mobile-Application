import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            text: title,
            type: AppTextType.titleLarge,
            fontWeight: FontWeight.w800,
          ),
        ),
        ?action,
      ],
    );
  }
}
