import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';

enum AppSnackBarType { success, error, info }

abstract final class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message: message, type: AppSnackBarType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message: message, type: AppSnackBarType.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message: message, type: AppSnackBarType.info);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required AppSnackBarType type,
  }) {
    final colors = Theme.of(context).colorScheme;
    final (backgroundColor, foregroundColor, icon) = switch (type) {
      AppSnackBarType.success => (
        const Color(0xFF087A55),
        Colors.white,
        Icons.check_circle_outline,
      ),
      AppSnackBarType.error => (
        colors.error,
        colors.onError,
        Icons.error_outline,
      ),
      AppSnackBarType.info => (
        colors.inverseSurface,
        colors.onInverseSurface,
        Icons.info_outline,
      ),
    };
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          elevation: 8,
          margin: EdgeInsets.all(SizeConfig.pagePadding),
          padding: EdgeInsets.symmetric(
            horizontal: 16.responsiveSize,
            vertical: 14.responsiveSize,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.responsiveSize),
          ),
          duration: const Duration(seconds: 4),
          showCloseIcon: true,
          closeIconColor: foregroundColor,
          content: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 22.responsiveSize),
              SizedBox(width: 12.responsiveSize),
              Expanded(
                child: AppText(
                  text: message,
                  type: AppTextType.bodyMedium,
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
