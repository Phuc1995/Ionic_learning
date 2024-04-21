import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/dialog/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:badges/badges.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';

class SettingPage extends StatefulWidget {
  final ProfileResponseDto profile;

  const SettingPage({Key? key, required this.profile}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
  UserStoreController _userStoreController = Get.put(UserStoreController());
  ProfileResponseDto profile = new ProfileResponseDto();

  Future<void> fetchProfile() async {
    await _userStoreController.fetchProfile();
    this.profile = _userStoreController.profile.value;
  }

  @override
  void initState() {
    this.profile = widget.profile;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarCommonWidget.build("setting_app_bar_title".tr,  (){
        Modular.to.pop();
      }),
      backgroundColor: AppColors.whiteSmoke5,
      body: Padding(
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
                        Modular.to.pushNamed(ViewerRoutes.setting_link_account_page,
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
                          Modular.to.pushNamed(ViewerRoutes.setting_change_password_page,
                              arguments: {
                                'isCreatePassword': profile.passwordUpdatedDate == null,
                              }).then((value) => fetchProfile());
                        },
                      )
                  ),
                  _buildMenuItem(
                    text: 'setting_account_verify'.tr,
                    onPressed: () {
                    },
                  ),
                  _buildMenuItem(
                    text: 'setting_black_list'.tr,
                    onPressed: () {
                    },
                  ),
                  _buildMenuItem(
                    text: 'setting_notification'.tr,
                    onPressed: () {
                      Modular.to.pushNamed(ViewerRoutes.setting_notification_page);
                    },
                  ),
                  _buildMenuItem(
                    text: 'setting_private_permissions'.tr,
                    onPressed: () {
                      // this.onPressed(IdolRoutes.transaction_history);
                    },
                  ),
                  _buildMenuItem(
                    text: 'setting_about_glive'.tr,
                    onPressed: () {
                      // this.onPressed(IdolRoutes.transaction_history);
                    },
                  ),
                  _buildMenuItem(
                    text: 'setting_language'.tr,
                    onPressed: () {
                      // this.onPressed(IdolRoutes.transaction_history);
                    },
                  ),
                ],
              ),
            ),
            _buildLogOutItem(text: 'setting_logout'.tr,
              onPressed: () {
                ShowDialog().showMessage(context, "logout_message".tr, "setting_logout".tr, () async {
                  _userStoreController.removeDeviceInfo();
                }, textButton2: "cancel".tr, onButton2: (){
                  Modular.to.pop();
                });
              },),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required VoidCallback onPressed,
    String badgeContent = ''}) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2.w,
            color: text == ('setting_language').tr ? Colors.white : AppColors.whiteSmoke5,
          ),
        ),
      ),
      child: InkWell(
        onTap: () async {
          onPressed();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextUtils.textStyle(FontWeight.w400, 17.sp, color: AppColors.grayCustom),
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
                color: AppColors.gainsboro,
              ),
            ],
          ),
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
              style: TextUtils.textStyle(FontWeight.w400, 17.sp, color: AppColors.grayCustom,), textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}

