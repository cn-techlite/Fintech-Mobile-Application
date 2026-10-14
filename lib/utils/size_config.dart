import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Central responsive sizing values for the application.
///
/// Percentage helpers are useful for large containers. For padding, gaps,
/// icons and radii, use [responsive] so values remain sensible on tablets and
/// very small phones.
class SizeConfig {
  SizeConfig._();

  static const double mobileBreakpoint = 600;
  static const double twoColumnBreakpoint = 700;
  static const double desktopBreakpoint = 840;
  static const double wideContentMaxWidth = 1080;
  static const double formContentMaxWidth = 620;
  static const double _referenceWidth = 390;
  static const double _referenceHeight = 844;

  static late MediaQueryData _mediaQueryData;
  static double screenWidth = _referenceWidth;
  static double screenHeight = _referenceHeight;

  /// Refreshes the sizing information whenever the app's MediaQuery changes.
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static bool get isMobile => screenWidth < mobileBreakpoint;
  static bool get isTablet =>
      screenWidth >= mobileBreakpoint && screenWidth < desktopBreakpoint;
  static bool get isDesktop => screenWidth >= desktopBreakpoint;

  /// Whether content has enough room for a useful two-column presentation.
  /// Widgets should still check their local LayoutBuilder constraints because
  /// a navigation rail or split-screen window can reduce the available width.
  static bool get supportsTwoColumns => screenWidth >= twoColumnBreakpoint;

  static EdgeInsets get viewPadding => _mediaQueryData.padding;

  /// Adaptive page gutter shared by all top-level screens.
  static double get pagePadding => responsive(
    isDesktop
        ? 32
        : isTablet
        ? 28
        : 20,
  );

  /// Returns height as a percentage of the current viewport height.
  static double height(double percentage, {bool safeArea = false}) {
    var availableHeight = screenHeight;
    if (safeArea) {
      availableHeight -= viewPadding.vertical;
    }
    return availableHeight * percentage / 100;
  }

  /// Returns width as a percentage of the current viewport width.
  static double width(double percentage, {bool safeArea = false}) {
    var availableWidth = screenWidth;
    if (safeArea) {
      availableWidth -= viewPadding.horizontal;
    }
    return availableWidth * percentage / 100;
  }

  /// Scales a logical-pixel dimension with conservative limits.
  static double responsive(double logicalPixels) {
    final widthScale = screenWidth / _referenceWidth;
    final heightScale = screenHeight / _referenceHeight;
    final scale = math.min(widthScale, heightScale).clamp(0.88, 1.20);
    return logicalPixels * scale;
  }

  /// Applies modest width-based font scaling. Flutter applies the user's
  /// accessibility TextScaler afterwards, so it must not be applied here too.
  static double text(double fontSize) {
    final scale = (screenWidth / _referenceWidth).clamp(0.92, 1.15);
    return fontSize * scale;
  }

  /// Responsive logical-pixel image/icon size.
  static double image(double imageSize) => responsive(imageSize);

  /// Keeps content readable on wide displays while filling compact screens.
  static double contentMaxWidth(double preferredWidth) {
    return math.max(
      0,
      math.min(preferredWidth, screenWidth - (pagePadding * 2)),
    );
  }
}

extension SizeHelpers on num {
  double get heightAdjusted => SizeConfig.height(toDouble());
  double get widthAdjusted => SizeConfig.width(toDouble());
  double get heightSafeAdjusted =>
      SizeConfig.height(toDouble(), safeArea: true);
  double get widthSafeAdjusted => SizeConfig.width(toDouble(), safeArea: true);
  double get responsiveSize => SizeConfig.responsive(toDouble());
  double get textSize => SizeConfig.text(toDouble());
  double get imageSize => SizeConfig.image(toDouble());
}

class BoxSizer extends StatelessWidget {
  const BoxSizer({
    required this.child,
    super.key,
    this.widthPercent,
    this.heightPercent,
    this.safeArea = false,
  });

  final double? widthPercent;
  final double? heightPercent;
  final bool safeArea;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final requestedWidth = widthPercent == null
            ? double.infinity
            : SizeConfig.width(widthPercent!, safeArea: safeArea);
        final requestedHeight = heightPercent == null
            ? double.infinity
            : SizeConfig.height(heightPercent!, safeArea: safeArea);
        final width = constraints.hasBoundedWidth
            ? requestedWidth.clamp(0.0, constraints.maxWidth).toDouble()
            : requestedWidth;
        final height = constraints.hasBoundedHeight
            ? requestedHeight.clamp(0.0, constraints.maxHeight).toDouble()
            : requestedHeight;
        return SizedBox(width: width, height: height, child: child);
      },
    );
  }
}

/// Adds vertical spacing as a percentage of screen height.
Widget addVerticalSpacing(double heightPercent, {bool safeArea = false}) {
  return SizedBox(height: SizeConfig.height(heightPercent, safeArea: safeArea));
}

/// Adds horizontal spacing as a percentage of screen width.
Widget addHorizontalSpacing(double widthPercent, {bool safeArea = false}) {
  return SizedBox(width: SizeConfig.width(widthPercent, safeArea: safeArea));
}
