export 'experience_repository.dart';

import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/repositories/experience_repository.dart';

List<Bind> repositories = [
  Bind<ExperienceRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return ExperienceRepository(_dioClient);
  }),
];
