library user_management;

import 'package:level/level_module.dart' as level_module;
import 'package:live_stream/live_stream_module.dart' as live_stream_module;
import 'package:payment/payment_module.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/domain/service/skills_idol_service.dart';
import 'package:user_management/repositories/repositories.dart';
import 'package:user_management/repository/auth_api_repository.dart';
import 'package:user_management/repository/impl/auth_api_impl.dart';
import 'package:user_management/repository/impl/social_id_repository_impl.dart';
import 'package:user_management/repository/impl/upload_image_api_impl.dart';
import 'package:user_management/repository/impl/user_info_api_impl.dart';
import 'package:user_management/repository/social_network_id_repository.dart';
import 'package:user_management/repository/upload_image_api_repository.dart';
import 'package:user_management/repository/user_info_api_repository.dart';
import 'package:user_management/services/services.dart';
import 'package:user_management/user_management_routes.dart';

import 'domain/service/auth_api_service.dart';
import 'domain/service/notification_service.dart';
import 'repository/impl/notification_api_impl.dart';
import 'repository/notification_api_repository.dart';

class UserManagementModule extends Module {
  @override
  // TODO: implement binds
  List<Bind> get binds => [
    Bind.singleton((_) {
      SharedPreferences _sharePre = Modular.get<SharedPreferences>();
      return SharedPreferenceHelper(_sharePre);
    }),
    Bind.singleton<DioClient>((_) {
      return DioClient();
    }),
    Bind<AuthApiRepository>((_) {
      DioClient _dioClient = Modular.get<DioClient>();
      return AuthApiImpl(_dioClient);
    }),
    Bind<AuthApiService>((_) => AuthApiService()),

    Bind<UploadImageApiRepository>((_) {
      DioClient _dioClient = Modular.get<DioClient>();
      return UploadImageApiImpl(_dioClient);
    }),
    Bind<UserInfoApiRepository>((_) {
      DioClient _dioClient = Modular.get<DioClient>();
      return UserInfoApiImpl(_dioClient);
    }),

    Bind<SocialNetworkIdRepository>((_) {
      return SocialNetworkIdRepositoryImpl();
    }),

    //notification module
    Bind<NotificationRepository>((_) {
      DioClient _dioClient = Modular.get<DioClient>();
      return NotificationImpl(_dioClient);
    }),
    Bind<NotificationService>((_) => NotificationService()),

    Bind<SkillsIdolService>((_) => SkillsIdolService()),
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
    ...userManagementRoutes,
    ModuleRoute(IdolRoutes.live_stream.root, module: live_stream_module.LiveStreamModule(), guards: []),
    ModuleRoute(IdolRoutes.payment.root, module: PaymentModule(), guards: []),
    ModuleRoute(IdolRoutes.level.root, module: level_module.LevelModule(), guards: []),
  ];
}
