part of 'idol_routes.dart';

class _PaymentRoutes {
  const _PaymentRoutes();
  final String root = '/payment';

  final String paymentTransactionHistory = '/transaction-history';
  String get paymentTransactionHistoryPage => root + paymentTransactionHistory;

  final String paymentStatistic = '/statistic';
  String get paymentStatisticPage => root + paymentStatistic;
}
