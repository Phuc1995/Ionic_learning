import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/user_management_module.dart';

//Extends form core_module to reuse code for both glive and glive_idol
class AppModule extends Module  {
  static Logger _logger = Logger();

// Provide a list of dependencies to inject into your project
@override
List<Bind> get binds => [
  AsyncBind((_) => SharedPreferences.getInstance(),),
  Bind<Logger>((_) => _logger),
];

// Provide all the routes for your module
@override
List<ModularRoute> get routes => [
  ModuleRoute("/", module: UserManagementModule(), guards: [UserManagementGuard('/')]),

];}

class UserManagementGuard extends RouteGuard {
  UserManagementGuard(String? guardedRoute) : super();

  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    await Modular.isModuleReady<AppModule>();
    return true;
  }
}
