import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:level/level_module.dart';
import 'package:live_stream/live_stream_module.dart';
import 'package:payment/payment_module.dart';
import 'package:user_management/presentation/page/account_complete_page/account_complete_page.dart';
import 'package:user_management/presentation/page/idol_detail_page/idol_detail_page.dart';
import 'package:user_management/presentation/page/register/step1/register_step_1_page.dart';
import 'package:user_management/presentation/page/setting_page/change_password_page/change_password_page.dart';
import 'package:user_management/presentation/page/setting_page/link_account_phone_email/link_account_phone_email.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/link_account_setting_page.dart';
import 'package:user_management/presentation/page/support_page/support_page.dart';
import 'package:user_management/presentation/page/user_info_edit_page/edit_nick_name_page.dart';
import 'package:user_management/presentation/page/user_info_edit_page/user_info_edit_page.dart';
import 'package:user_management/presentation/page/environment_page/environment_page.dart';
import 'package:user_management/presentation/page/forgot_password/forgot_password.dart';
import 'package:user_management/presentation/page/home_page/home_page.dart';
import 'package:user_management/presentation/page/login_page/login_page.dart';
import 'package:user_management/repositorise/repositories.dart';
import 'package:user_management/service/services.dart';

import 'presentation/page/hot_idol_page/hot_idol_page.dart';
import 'presentation/page/live_feed/live_feed_page.dart';
import 'presentation/page/notification_page/notification_page.dart';
import 'presentation/page/register/step2/register_step_2_page.dart';
import 'presentation/page/report_page/report_page.dart';
import 'presentation/page/setting_page/notification_setting_page/notification_setting_page.dart';
import 'presentation/page/setting_page/setting_page.dart';
import 'presentation/page/user_info_edit_page/edit_intro_page.dart';
import 'presentation/root_page.dart';

class UserManagementModule extends Module {
  @override
  // TODO: implement binds
  List<Bind> get binds => [
    ...repositories,
    ...services,
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(ViewerRoutes.live, module: LiveStreamModule(), guards: []),
    ModuleRoute(ViewerRoutes.payment, module: PaymentModule(), guards: []),
    ModuleRoute(ViewerRoutes.level, module: LevelModule(), guards: []),

    ChildRoute(Modular.initialRoute, child: (_, __) => RootPage(),),
    ChildRoute(ViewerRoutes.home, child: (_, args) => HomePage(currentPage: args.data['currentPage'])),
    ChildRoute(ViewerRoutes.login, child: (_, __) => LoginPage()),
    ChildRoute(ViewerRoutes.support, child: (_, __) => SupportPage()),
    ChildRoute(ViewerRoutes.account_complete, child: (_, __) => AccountComplete()),
    ChildRoute(ViewerRoutes.hot_idol, child: (_, __) => HotIdolPage()),
    ChildRoute(ViewerRoutes.environment, child: (_, __) => EnvironmentPage()),
    ChildRoute(ViewerRoutes.register_step_1, child: (_, __) => RegisterStepFirstPage()),
    ChildRoute(ViewerRoutes.register_step_2, child: (_, __) => RegisterSecondPage()),
    ChildRoute(ViewerRoutes.forgot_password, child: (_, __) => ForgotPasswordPage()),
    ChildRoute(ViewerRoutes.account_info_edit, child: (_, args) => UserInfoEditPage()),
    ChildRoute(ViewerRoutes.account_edit_nick_name, child: (_, args) => EditNickNamePage(
      profile:  args.data['profile_to_edit'],
    )),
    ChildRoute(ViewerRoutes.account_edit_intro_page, child: (_, args) => EditIntroPage(
      profile:  args.data['profile_to_edit'],
    )),
    ChildRoute(ViewerRoutes.notification_page, child: (_, __) => NotificationPage()),
    ChildRoute(ViewerRoutes.setting_page, child: (_, args) => SettingPage(
      profile:  args.data['profile'],
    )),
    ChildRoute(ViewerRoutes.setting_notification_page, child: (_, __) => NotificationSettingPage()),
    ChildRoute(ViewerRoutes.setting_link_account_page, child: (_, args) => LinkAccountSettingPage()),
    ChildRoute(ViewerRoutes.setting_link_account_phone_email_page, child: (_, args) => LinkAccountPhoneEmailPage(
      isPhone: args.data['isPhone'],
    )),
    ChildRoute(ViewerRoutes.setting_change_password_page, child: (_, args) => ChangePasswordPage(
      isCreatePassword: args.data['isCreatePassword'],
    )),
    ChildRoute(ViewerRoutes.report_page, child: (_, __) => ReportPage()),
    ChildRoute(ViewerRoutes.live_feed, child: (_, __) => LiveFeedSPage(),),
    ChildRoute(ViewerRoutes.idol_detail, child: (_, args) => IdolDetailPage(uuidIdol: args.data['uuidIdol'], isBanned: args.data['isBanned']),),

  ];
}
