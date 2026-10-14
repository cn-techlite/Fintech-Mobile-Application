import 'package:fintech_mobile_application/providers/navigation_provider.dart';
import 'package:fintech_mobile_application/screens/dashboard_screen.dart';
import 'package:fintech_mobile_application/screens/products_screen.dart';
import 'package:fintech_mobile_application/screens/profile_screen.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.savings_outlined),
      selectedIcon: Icon(Icons.savings),
      label: 'Products',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final controller = ref.read(navigationIndexProvider.notifier);
    const screens = [DashboardScreen(), ProductsScreen(), ProfileScreen()];
    const titles = ['Dashboard', 'Savings Products', 'Profile'];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Re-initialize from the local constraints so split-screen and desktop
        // window resizing switch navigation modes immediately.
        SizeConfig.init(context);
        final wide = constraints.maxWidth >= SizeConfig.desktopBreakpoint;
        return Scaffold(
          appBar: AppBar(
            title: AppText(
              text: titles[selectedIndex],
              type: AppTextType.titleLarge,
              fontWeight: FontWeight.w800,
            ),
          ),
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: controller.select,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon,
                          label: AppText(
                            text: item.label,
                            type: AppTextType.labelMedium,
                          ),
                        ),
                      )
                      .toList(),
                ),
              Expanded(
                child: IndexedStack(index: selectedIndex, children: screens),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: controller.select,
                  destinations: _destinations,
                ),
        );
      },
    );
  }
}
