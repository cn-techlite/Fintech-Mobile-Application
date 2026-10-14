import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationController extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;

  void reset() => state = 0;
}

final navigationIndexProvider = NotifierProvider<NavigationController, int>(
  NavigationController.new,
);
