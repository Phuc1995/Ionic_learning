export 'transaction_history_repository.dart';

import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/repositories/transaction_history_repository.dart';

List<Bind> repositories = [
  Bind<TransactionHistoryRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return TransactionHistoryRepository(_dioClient);
  }),
];
