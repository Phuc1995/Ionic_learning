export 'live_stream_service.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'live_stream_service.dart';

List<Bind> services = [
  Bind<LiveStreamService>((_) => LiveStreamService()),
];
