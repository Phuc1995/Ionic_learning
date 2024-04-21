export 'level_policy_service.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:level/services/level_policy_service.dart';

List<Bind> services = [
  Bind<LevelPolicyService>((_) => LevelPolicyService()),
];
