library payment_module;

import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/payment_routes.dart';
import 'package:payment/repositories/repositories.dart';
import 'package:payment/services/services.dart';

class PaymentModule extends Module {
  @override
  List<Bind> get binds => [
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
    ...paymentRoutes,
  ];
}

