import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/presentation/page/account_verify/step3/step3_verify_page.dart';
import 'package:user_management/presentation/page/account_verify/step4/step4_verify_page.dart';
import 'package:user_management/presentation/page/favorite/favorite.dart';

import 'package:user_management/presentation/page/account_verify/step1/step1_verify_page.dart';
import 'package:user_management/presentation/page/account_verify/step2/step2_verify_page.dart';
import 'package:user_management/presentation/page/notification_page/notification_page.dart';
import 'package:user_management/presentation/page/register/step1/register_step_1_page.dart';
import 'package:user_management/presentation/page/register/step2/register_step_2_page.dart';
import 'package:user_management/presentation/page/report_page/report_page.dart';
import 'package:user_management/presentation/page/setting_page/change_password_page/change_password_page.dart';
import 'package:user_management/presentation/page/setting_page/link_account_phone_email/link_account_phone_email.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/link_account_setting_page.dart';
import 'package:user_management/presentation/page/setting_page/notification_setting_page/notification_setting_page.dart';
import 'package:user_management/presentation/page/setting_page/setting_page.dart';
import 'package:user_management/presentation/page/user_info_edit_page/edit_forte_page.dart';
import 'package:user_management/presentation/page/user_info_edit_page/edit_intro_page.dart';
import 'package:user_management/presentation/page/user_info_edit_page/edit_nick_name_page.dart';
import 'package:user_management/presentation/page/user_info_edit_page/user_info_edit_page.dart';
import 'package:user_management/presentation/page/account_complete/account_complete_page.dart';
import 'package:user_management/presentation/page/environment_page/environment_page.dart';
import 'package:user_management/presentation/page/forgot_password/forgot_password.dart';
import 'package:user_management/presentation/page/home_page/home_page.dart';
import 'package:user_management/presentation/page/login_page/login_page.dart';
import 'package:user_management/presentation/root_page.dart';

List<ModularRoute> userManagementRoutes = [
  ChildRoute(Modular.initialRoute, child: (_, __) => RootPage(),),
  ChildRoute(IdolRoutes.user_management.home, child: (_, __) => HomePage()),
  ChildRoute(IdolRoutes.user_management.login, child: (_, __) => LoginPage()),
  ChildRoute(IdolRoutes.user_management.accountComplete, child: (_, __) => AccountCompletePage()),
  ChildRoute(IdolRoutes.user_management.accountVerifyStep1Screen, child: (_, __) => AccountVerifyStep1Home()),
  ChildRoute(IdolRoutes.user_management.accountVerifyStep2Screen, child: (_, __) => AccountVerifyStep2Home()),
  ChildRoute(IdolRoutes.user_management.accountVerifyStep3Screen, child: (_, __) => AccountVerifyStep3Home()),
  ChildRoute(IdolRoutes.user_management.accountVerifyStep4Screen, child: (_, __) => AccountVerifyStep4Page()),
  ChildRoute(IdolRoutes.user_management.environment, child: (_, __) => EnvironmentPage()),
  ChildRoute(IdolRoutes.user_management.registerStep1, child: (_, __) => RegisterStepFirstPage()),
  ChildRoute(IdolRoutes.user_management.registerStep2, child: (_, __) => RegisterSecondPage()),
  ChildRoute(IdolRoutes.user_management.forgotPassword, child: (_, __) => ForgotPasswordPage()),
  ChildRoute(IdolRoutes.user_management.favorite, child: (_, args) => FavoritePage()),
  ChildRoute(IdolRoutes.user_management.accountInfoEdit, child: (_, args) => UserInfoEditPage(
    profile:  args.data['profile'],
  )),
  ChildRoute(IdolRoutes.user_management.accountEditNickName, child: (_, args) => EditNickNamePage(
    profile:  args.data['profile_to_edit'],
  )),
  ChildRoute(IdolRoutes.user_management.accountEditIntroPage, child: (_, args) => EditIntroPage(
    profile:  args.data['profile_to_edit'],
  )),
  ChildRoute(IdolRoutes.user_management.accountEditFortePage, child: (_, args) => EditFortePage()),
  ChildRoute(IdolRoutes.user_management.notificationPage, child: (_, __) => NotificationPage()),
  ChildRoute(IdolRoutes.user_management.settingPage, child: (_, args) => SettingPage(
    profile:  args.data['profile'],
  )),
  ChildRoute(IdolRoutes.user_management.settingNotificationPage, child: (_, __) => NotificationSettingPage()),
  ChildRoute(IdolRoutes.user_management.settingLinkAccountPage, child: (_, args) => LinkAccountSettingPage()),
  ChildRoute(IdolRoutes.user_management.settingLinkAccountPhoneEmailPage, child: (_, args) => LinkAccountPhoneEmailPage(
    isPhone: args.data['isPhone'],
  )),
  ChildRoute(IdolRoutes.user_management.settingChangePasswordPage, child: (_, args) => ChangePasswordPage(
    isCreatePassword: args.data['isCreatePassword'],
  )),
  // ChangePasswordPage

  ChildRoute(IdolRoutes.user_management.reportPage, child: (_, __) => ReportPage()),
];
