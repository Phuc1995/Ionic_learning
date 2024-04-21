export 'auth_api_repository.dart';
export 'upload_image_api_repository.dart';
export 'follow_idol_api_repository.dart';
export 'idol_api_repository.dart';
export 'notification_api_repository.dart';
export 'social_id_repository.dart';
export 'user_info_api_repository.dart';

import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/repository/impl/live_api_repository_impl.dart';
import 'package:live_stream/repository/live_api_repository.dart';
import 'package:payment/repositories/top_up_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/repositorise/repositories.dart';

List<Bind> repositories = [
  Bind.singleton((_) {
    SharedPreferences _sharePre = Modular.get<SharedPreferences>();
    return SharedPreferenceHelper(_sharePre);
  }),
  Bind.singleton<DioClient>((_) {
    return DioClient();
  }),

  Bind<LiveApiRepository>((_) => LiveApiRepositoryImpl()),

  Bind<AuthApiRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return AuthApiRepository(_dioClient);
  }),

  Bind<UploadImageApiRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return UploadImageApiRepository(_dioClient);
  }),

  Bind<UserInfoApiRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return UserInfoApiRepository(_dioClient);
  }),

  Bind<SocialNetworkIdRepository>((_) {
    return SocialNetworkIdRepository();
  }),

  Bind<NotificationRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return NotificationRepository(_dioClient);
  }),

  Bind<FollowIdolRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return FollowIdolRepository(_dioClient);
  }),

  Bind<IdolRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return IdolRepository(_dioClient);
  }),


  Bind<TopUpRepository>((_) {
    DioClient _dioClient = Modular.get<DioClient>();
    return TopUpRepository(_dioClient);
  }),
];
