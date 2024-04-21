export 'auth_api_service.dart';
export 'follow_idol_service.dart';
export 'idol_service.dart';
export 'notification_service.dart';
export 'upload_image_service.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:user_management/service/services.dart';

List<Bind> services = [
  Bind<AuthApiService>((_) => AuthApiService()),

  Bind<NotificationService>((_) => NotificationService()),

  Bind<TopUpService>((_) => TopUpService()),

  Bind<FollowIdolService>((_) => FollowIdolService()),

  Bind<IdolService>((_) => IdolService()),
];
