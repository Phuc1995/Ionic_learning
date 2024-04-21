export 'experience_service.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/services/experience_service.dart';

List<Bind> services = [
  Bind<ExperienceService>((_) => ExperienceService()),
];
