import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/presentation/pages/statistic_page/statistic_page.dart';
import 'package:payment/presentation/pages/transaction_history_page/transaction_history_page.dart';

List<ModularRoute> paymentRoutes = [
  ChildRoute(IdolRoutes.payment.paymentTransactionHistory, child: (_, __) => TransactionHistoryPage()),
  ChildRoute(IdolRoutes.payment.paymentStatistic, child: (_, __) => StatisticPage()),
];

