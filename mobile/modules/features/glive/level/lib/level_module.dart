library user_management;

import 'package:flutter_modular/flutter_modular.dart';
import 'package:level/presentation/pages/level_detail_page/level_detail_page.dart';
import 'package:level/repositories/repositories.dart';
import 'package:level/services/services.dart';

class LevelModule extends Module {
  @override
  // TODO: implement binds
  List<Bind> get binds => [
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/level-detail', child: (_, __) => LevelDetailPage()),
  ];
}

