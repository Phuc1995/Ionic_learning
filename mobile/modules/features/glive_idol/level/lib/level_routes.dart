import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:level/presentation/pages/level_detail_page/level_detail_page.dart';

List<ModularRoute> levelRoutes = [
  ChildRoute(IdolRoutes.level.levelDetail, child: (_, __) => LevelDetailPage()),
];
