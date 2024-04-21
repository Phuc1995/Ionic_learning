library user_management;

import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/service/live_stream_service.dart';
import 'presentation/pages/live_channel_idol/live_channel_idol.dart';

class LiveStreamModule extends Module {
  @override
  // TODO: implement binds
  List<Bind> get binds => [
    Bind<LiveStreamService>((_) => LiveStreamService()),
  ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(ViewerRoutes.live_channel_idol.replaceFirst(ViewerRoutes.live, ''),
            transition: TransitionType.upToDown,
            child: (_, args) => LiveChannelIdolPage(roomData:args.data['roomData']),),
      ];
}
