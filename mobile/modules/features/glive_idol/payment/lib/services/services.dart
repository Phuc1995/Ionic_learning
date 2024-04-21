export 'transaction_history_service.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/services/transaction_history_service.dart';

List<Bind> services = [
  Bind<TransactionHistoryService>((_) => TransactionHistoryService()),
];
