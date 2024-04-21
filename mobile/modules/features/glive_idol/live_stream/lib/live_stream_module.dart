library live_stream;

import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/live_stream_routes.dart';
import 'package:live_stream/repositories/repositories.dart';
import 'package:live_stream/services/services.dart';

class LiveStreamModule extends Module {
  @override
  List<Bind> get binds => [
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
     ...liveStreamRoutes,
  ];
}
