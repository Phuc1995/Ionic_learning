export 'live_session_repository.dart';
export 'message_repository.dart';
export 'privacy_repository.dart';

import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'live_session_repository.dart';
import 'message_repository.dart';
import 'privacy_repository.dart';

List<Bind> repositories = [
  Bind<LiveStreamRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return LiveStreamRepository(_dioClient);
  }),
  Bind<MessageRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return MessageRepository(_dioClient);
  }),
  Bind<PrivacyRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return PrivacyRepository(_dioClient);
  }),
];
