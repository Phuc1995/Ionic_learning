export 'transaction_history_repository.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/repositories/top_up_repository.dart';
import 'package:payment/repositories/transaction_history_repository.dart';

List<Bind> repositories = [
  Bind<TopUpRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return TopUpRepository(_dioClient);
  }),

  Bind<TransactionHistoryRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return TransactionHistoryRepository(_dioClient);
  }),
];
