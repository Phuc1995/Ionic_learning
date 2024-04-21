part 'level_routes.dart';
part 'user_management_routes.dart';
part 'payment_routes.dart';
part 'live_stream_routes.dart';

class IdolRoutes {
  IdolRoutes._();

  //User Management Router
  static const _UserManagementRoutes user_management = _UserManagementRoutes();

  //Payment Router
  static const _PaymentRoutes payment = _PaymentRoutes();

  //Level Router
  static const _LevelRoutes level = _LevelRoutes();

  //Live Stream Router
  static const _LiveStreamRoutes live_stream = _LiveStreamRoutes();
}
