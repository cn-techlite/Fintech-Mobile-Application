import 'package:fintech_mobile_application/models/savings_tip.dart';
import 'package:fintech_mobile_application/providers/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savingsTipsProvider = FutureProvider<List<SavingsTip>>(
  (ref) => ref.watch(tipsRepositoryProvider).fetchTips(),
);
