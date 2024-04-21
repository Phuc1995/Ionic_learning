export 'level_policy_repository.dart';

import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'level_policy_repository.dart';

List<Bind> repositories = [
  Bind<LevelPolicyRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return LevelPolicyRepository(_dioClient);
  }),
];
