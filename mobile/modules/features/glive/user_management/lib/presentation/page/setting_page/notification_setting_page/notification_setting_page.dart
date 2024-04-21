import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingPageState createState() => _NotificationSettingPageState();
}


class _NotificationSettingPageState extends State<NotificationSettingPage> {
  UserStoreController _userStoreController = Get.put(UserStoreController());
  var isNotifyLiveSwitched = false.obs;
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
  ProfileResponseDto _profile = new ProfileResponseDto();
  @override
  void initState() {
    _userStoreController.fetchProfile();
    isNotifyLiveSwitched.value = _sharedPrefsHelper.getNotificationLive;
  }

  @override
  Widget build(BuildContext context) {
    AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarCommonWidget.build("setting_notification_app_bar".tr,  (){
        Modular.to.pop();
      }),
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 4.w,
            color: AppColors.whiteSmoke2,
          ),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 25.h, bottom: 25.h),
                  child: Text("setting_notification_all".tr, style: TextUtils.textStyle(FontWeight.w400, 17.sp),),
                ),
                Obx(() => Container(
                  padding: EdgeInsets.only(right: 10.w),
                  height: 30.h,
                  child: FlutterSwitch(
                    width: 50.w,
                    toggleSize: 20.sp,
                    activeColor: AppColors.pink1,
                    value: _userStoreController.isAllSwitched.value,
                    onToggle: (value) async {
                      _userStoreController.isAllSwitched.value = value;
                      var response = await _userStoreController.updateViewerInfo(field: "receiveNotification", content: _userStoreController.isAllSwitched.value);
                      response.fold((failure) {}, (success) {
                        _userStoreController.isAllSwitched.value = value;
                      });
                    },
                  ),
                ),),
              ],
            ),
          ),
          Obx(() => Visibility(
            visible: _userStoreController.isAllSwitched.value,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 5.h),
                        child: Text("setting_notification_live".tr, style: TextUtils.textStyle(FontWeight.w400, 17.sp),),
                      ),
                      Obx(() => Container(
                        padding: EdgeInsets.only(right: 10.w),
                        height: 30.h,
                        child: FlutterSwitch(
                          width: 50.w,
                          toggleSize: 20.sp,
                          activeColor: AppColors.pink1,
                          value: isNotifyLiveSwitched.value,
                          onToggle: (value) async {
                            isNotifyLiveSwitched.value = value;
                            _sharedPrefsHelper.setNotificationLive(isNotifyLiveSwitched.value);
                          },
                        ),
                      ),),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w, bottom: 20.h),
                    child: Text("setting_notification_title_detail".tr, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.whiteSmoke9)),
                  )
                ],
              ),
            ),
          )),

        ],
      ),
    );
  }
}
