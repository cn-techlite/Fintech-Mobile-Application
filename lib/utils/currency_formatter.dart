import 'package:intl/intl.dart';

final _nairaFormatter = NumberFormat.currency(
  locale: 'en_NG',
  symbol: '₦',
  decimalDigits: 0,
);

String formatNaira(num amount) => _nairaFormatter.format(amount);
