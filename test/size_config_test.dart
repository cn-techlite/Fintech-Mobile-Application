import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SizeConfig adapts across mobile and desktop widths', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Future<void> pumpAt(Size size) async {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: size),
            child: Builder(
              builder: (context) {
                SizeConfig.init(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      await tester.pump();
    }

    await pumpAt(const Size(320, 568));
    expect(SizeConfig.isMobile, isTrue);
    expect(SizeConfig.pagePadding, lessThan(20));
    expect(SizeConfig.contentMaxWidth(460), lessThanOrEqualTo(320));

    await pumpAt(const Size(1024, 768));
    expect(SizeConfig.isDesktop, isTrue);
    expect(SizeConfig.supportsTwoColumns, isTrue);
    expect(SizeConfig.pagePadding, greaterThan(20));
    expect(SizeConfig.contentMaxWidth(760), 760);

    await pumpAt(const Size(834, 1194));
    expect(SizeConfig.isTablet, isTrue);
    expect(SizeConfig.supportsTwoColumns, isTrue);
    expect(
      SizeConfig.contentMaxWidth(SizeConfig.wideContentMaxWidth),
      lessThan(834),
    );
  });
}
