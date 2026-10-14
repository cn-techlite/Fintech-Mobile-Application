import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.widthPercent = 100,
    this.heightPercent = 6,
    this.btnColor,
    this.isLoading = false,
    this.textColor,
    this.fontSize = 14,
    this.fontFamily,
    this.borderRadius = 14,
    this.safeArea = false,
    this.gradientColors = const [Color(0xFF0B6E4F), Color(0xFF11966C)],
    this.isGradient = false,
    this.child,
    this.icon,
    this.variant = AppButtonVariant.filled,
    this.compact = false,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  final String text;
  final VoidCallback? onPressed;
  final double widthPercent;
  final double heightPercent;
  final Color? btnColor;
  final bool isLoading;
  final Color? textColor;
  final double fontSize;
  final String? fontFamily;
  final double borderRadius;
  final bool safeArea;
  final List<Color> gradientColors;
  final bool isGradient;
  final Widget? child;
  final Widget? icon;
  final AppButtonVariant variant;
  final bool compact;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null && !isLoading;
    final effectiveButtonColor = _buttonColor(colorScheme, isDisabled);
    final effectiveTextColor = _textColor(colorScheme, isDisabled);
    final effectiveBorderColor = _borderColor(colorScheme, isDisabled);

    final button = DecoratedBox(
      decoration: BoxDecoration(
        color: isGradient && variant == AppButtonVariant.filled
            ? null
            : effectiveButtonColor,
        gradient:
            isGradient && variant == AppButtonVariant.filled && !isDisabled
            ? LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius.responsiveSize),
        border: effectiveBorderColor == null
            ? null
            : Border.all(color: effectiveBorderColor, width: borderWidth),
      ),
      child: CupertinoButton(
        onPressed: isLoading ? null : onPressed,
        padding: compact
            ? EdgeInsets.symmetric(
                horizontal: 14.responsiveSize,
                vertical: 10.responsiveSize,
              )
            : EdgeInsets.zero,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(borderRadius.responsiveSize),
        color: Colors.transparent,
        disabledColor: Colors.transparent,
        pressedOpacity: .78,
        child: Center(
          widthFactor: compact ? 1 : null,
          heightFactor: compact ? 1 : null,
          child: _content(effectiveTextColor),
        ),
      ),
    );

    if (compact) {
      return IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 40.responsiveSize),
          child: button,
        ),
      );
    }

    final height = SizeConfig.height(
      heightPercent,
      safeArea: safeArea,
    ).clamp(44.responsiveSize, 60.responsiveSize);

    return FractionallySizedBox(
      widthFactor: (widthPercent / 100).clamp(0.0, 1.0),
      child: SizedBox(height: height, child: button),
    );
  }

  Color _buttonColor(ColorScheme colors, bool isDisabled) {
    if (variant != AppButtonVariant.filled) return Colors.transparent;
    if (isDisabled) return colors.surfaceContainerHighest;
    return btnColor ?? colors.primary;
  }

  Color _textColor(ColorScheme colors, bool isDisabled) {
    if (isDisabled) return colors.onSurfaceVariant;
    if (textColor != null) return textColor!;
    return switch (variant) {
      AppButtonVariant.filled => colors.onPrimary,
      AppButtonVariant.outlined => colors.onSurface,
      AppButtonVariant.text => colors.primary,
    };
  }

  Color? _borderColor(ColorScheme colors, bool isDisabled) {
    if (variant != AppButtonVariant.outlined) return null;
    if (isDisabled) return colors.outlineVariant;
    return borderColor ?? colors.outline;
  }

  Widget _content(Color effectiveTextColor) {
    if (isLoading) {
      return SizedBox.square(
        dimension: 18.responsiveSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: effectiveTextColor,
        ),
      );
    }

    if (child != null) {
      return IconTheme(
        data: IconThemeData(color: effectiveTextColor),
        child: child!,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(
              color: effectiveTextColor,
              size: 18.responsiveSize,
            ),
            child: icon!,
          ),
          SizedBox(width: 8.responsiveSize),
        ],
        AppText(
          text: text,
          type: AppTextType.labelLarge,
          textAlign: TextAlign.center,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          color: effectiveTextColor,
        ),
      ],
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.iconSize,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      iconSize: iconSize,
      style: backgroundColor == null
          ? null
          : IconButton.styleFrom(backgroundColor: backgroundColor),
      icon: icon,
    );
  }
}
