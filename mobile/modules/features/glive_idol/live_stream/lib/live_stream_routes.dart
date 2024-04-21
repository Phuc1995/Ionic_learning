import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/presentation/pages/live_end_information/live_end_information_page.dart';
import 'package:live_stream/presentation/pages/live_preview_page/live_preview_page.dart';

List<ModularRoute> liveStreamRoutes = [
  ChildRoute(IdolRoutes.live_stream.livePreview,
      transition: TransitionType.upToDown,
      child: (_, args) =>
          LivePreviewPage(profile: args.data['profile'], cameras: args.data['cameras'])),
  ChildRoute(IdolRoutes.live_stream.liveEnd,
      transition: TransitionType.upToDown,
      child: (_, args) => LiveEndInformationPage(
        profile: args.data['profile'],
        avatar: args.data['avatar'],
        viewCount: args.data['viewCount'],
        liveTime: args.data['liveTime'],
        fan: args.data['fan'],
        ruby: args.data['ruby'],
      ))
];
