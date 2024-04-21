import 'package:badges/badges.dart';
import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/dialog/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/domain/usecase/auth/remove_device_info.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

class SettingPage extends StatefulWidget {
  final ProfileResponse profile;

  const SettingPage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SharedPreferenceHelper _sharedPrefsHelper =
      Modular.get<SharedPreferenceHelper>();
  AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
  UserStoreController userStoreController = Get.put(UserStoreController());
  final UserInfoApiRepository _accountInfoApi =
  Modular.get<UserInfoApiRepository>();
  ProfileResponse profile = new ProfileResponse();

  Future<void> fetchProfile() async {
    final either = await _accountInfoApi.fetchProfile();
    userStoreController.isLoading.value = true;
    either.fold((l) => userStoreController.isLoading.value = false, (res) {
      userStoreController.isLoading.value = false;
      setState(() {
        if (res.data != null) {
          profile = ProfileResponse.fromMap(res.data);
        }
      });
    });
  }

  @override
  void initState() {
    this.profile = widget.profile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarCommonWidget.build("setting_app_bar_title".tr, () {
        Modular.to.pop();
      }),
      backgroundColor: AppColors.whiteSmoke5,
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                _buildMenuItem(
                  text: 'setting_link_account'.tr,
                  badgeContent: profile.needLinkAccount() ? '!' : '',
                  onPressed: () {
                    Modular.to.pushNamed(IdolRoutes.user_management.settingLinkAccountPage,
                        arguments: {
                          'profile': profile,
                        }).then((value) => fetchProfile());
                  }
                ),
                Visibility(
                  visible: profile.canChangePassword(),
                  child: _buildMenuItem(
                    badgeContent: profile.passwordUpdatedDate == null ? '!' : '',
                    text: profile.passwordUpdatedDate == null ? 'setting_create_password'.tr : 'setting_change_password'.tr,
                    onPressed: () {
                      Modular.to.pushNamed(IdolRoutes.user_management.settingChangePasswordPage,
                          arguments: {
                            'isCreatePassword': profile.passwordUpdatedDate == null,
                          }).then((value) => fetchProfile());
                    },
                  )
                ),
                _buildMenuItem(
                  text: 'setting_notification'.tr,
                  onPressed: () {
                    Modular.to.pushNamed(IdolRoutes.user_management.settingNotificationPage);
                  },
                ),
                _buildMenuItem(
                  text: 'setting_private_permissions'.tr,
                  onPressed: () {
                    // this.onPressed(IdolRoutes.transaction_history);
                  },
                ),
              ],
            ),
          ),
          _buildLogOutItem(
            text: 'setting_logout'.tr,
            onPressed: () {
              ShowDialog().showMessage(
                  context,
                  "logout_message".tr,
                  "setting_logout".tr,
                  () async {
                    final deviceInfo = await DeviceUtils.getDeviceId();
                    await RemoveDeviceInfo().call(RemoveInfoParams(deviceId: deviceInfo.deviceId));
                    _sharedPrefsHelper.clearAll();
                    userStoreController.logout();
                    userStoreController.isLoading.value = false;
                    Modular.to.navigate(IdolRoutes.user_management.login);
                  },
                  textButton2: "cancel".tr,
                  onButton2: () {
                    Modular.to.pop();
                  });
            },
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {required String text,
      required VoidCallback onPressed,
      String badgeContent = ''}) {
    return InkWell(
      onTap: () {
            onPressed();
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
        padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2.w,
              color: text == ('setting_private_permissions').tr
                  ? Colors.white
                  : AppColors.whiteSmoke5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextUtils.textStyle(FontWeight.w400, 17.sp,
                  color: AppColors.grayCustom),
            ),
            badgeContent.isNotEmpty
                ? SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Badge(
                          elevation: 0,
                          shape: BadgeShape.circle,
                          badgeColor: Colors.red,
                          padding: EdgeInsets.all(5),
                          badgeContent: Text(
                            badgeContent,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.chevron_right,
                            color: AppColors.whiteSmoke,
                          ),
                        ),
                      ],
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: AppColors.whiteSmoke,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOutItem({
    required String text,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        height: 60.h,
        margin: EdgeInsets.only(top: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white,
        ),
        child: Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
          padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextUtils.textStyle(
                FontWeight.w400,
                17.sp,
                color: AppColors.grayCustom,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
