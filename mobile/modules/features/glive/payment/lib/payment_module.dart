import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/recharge_crypto_page.dart';
import 'package:payment/presentation/pages/recharge_crypto_support_page/recharge_crypto_support_page.dart';
import 'package:payment/presentation/pages/recharge_history_page/recharge_history_detail_page/recharge_history_detail_page.dart';
import 'package:payment/presentation/pages/recharge_history_page/recharge_history_page.dart';
import 'package:payment/presentation/pages/statistic_page/statistic_page.dart';
import 'package:payment/presentation/pages/transaction_history_page/transaction_history_page.dart';
import 'package:payment/repositories/repositories.dart';
import 'package:payment/service/services.dart';

import 'presentation/pages/recharge_infomation_page/recharge_infomation_page.dart';
class PaymentModule extends Module {
  @override
  // TODO: implement binds
  List<Bind> get binds => [
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
    // ChildRoute(ViewerRoutes.payment_momo.replaceFirst(ViewerRoutes.payment, ''), child: (_, __) => PaymentMomoPage()),
    ChildRoute(ViewerRoutes.payment_crypto.replaceFirst(ViewerRoutes.payment, ''), child: (_, __) => RechargeCryptoPage()),
    ChildRoute(ViewerRoutes.payment_recharge_history.replaceFirst(ViewerRoutes.payment, ''), child: (_, __) => RechargeHistoryPage()),
    ChildRoute(ViewerRoutes.payment_recharge_history_detail.replaceFirst(ViewerRoutes.payment, ''), child: (_, args) => RechargeHistoryDetailPage(entity: args.data['dto'],)),
    ChildRoute(ViewerRoutes.payment_information.replaceFirst(ViewerRoutes.payment, ''), child: (_, args) => RechargeInformationPage(rechargeInformation: args.data['information'],)),
    ChildRoute(ViewerRoutes.payment_recharge_crypto_support.replaceFirst(ViewerRoutes.payment, ''), child: (_, args) => RechargeCryptoSupportPage()),
    ChildRoute('/transaction-history', child: (_, __) => TransactionHistoryPage()),
    ChildRoute('/statistic', child: (_, __) => StatisticPage()),
  ];
}

