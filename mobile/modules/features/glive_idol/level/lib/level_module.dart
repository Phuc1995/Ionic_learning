library level_module;

import 'package:flutter_modular/flutter_modular.dart';
import 'package:level/level_routes.dart';
import 'package:level/repositories/repositories.dart';
import 'package:level/services/services.dart';

class LevelModule extends Module {
  @override
  List<Bind> get binds => [
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
    ...levelRoutes
  ];
}

