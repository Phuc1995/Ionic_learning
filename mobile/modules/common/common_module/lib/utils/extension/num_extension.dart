import 'package:intl/intl.dart';

extension NumExtension on num {
  String formatCurrency({String pattern = "#,##0", String locale = "vi_VN"}) {
    final oCcy = new NumberFormat(pattern, locale);
    return oCcy.format(this);
  }
}
