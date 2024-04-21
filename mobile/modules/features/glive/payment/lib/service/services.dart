export 'transaction_history_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:payment/service/transaction_history_service.dart';
import 'package:payment/service/wc_session_service.dart';

List<Bind> services = [
  Bind<TopUpService>((_) => TopUpService()),

  Bind<TransactionHistoryService>((_) => TransactionHistoryService()),

  Bind<WcSessionService>((_) => WcSessionService()),
];
