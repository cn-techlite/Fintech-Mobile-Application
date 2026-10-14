import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label = 'Loading...'});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 24.responsiveSize),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 12.responsiveSize),
          AppText(text: label, type: AppTextType.bodyMedium),
        ],
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 24.responsiveSize),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 40.responsiveSize,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: 8.responsiveSize),
          AppText(
            text: message,
            type: AppTextType.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 20.responsiveSize),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 40.responsiveSize,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 8.responsiveSize),
          AppText(
            text: message,
            type: AppTextType.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.responsiveSize),
          AppButton(
            text: 'Retry',
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            variant: AppButtonVariant.text,
            compact: true,
          ),
        ],
      ),
    ),
  );
}
