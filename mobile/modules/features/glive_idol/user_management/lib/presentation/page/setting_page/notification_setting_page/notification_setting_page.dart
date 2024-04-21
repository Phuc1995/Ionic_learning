import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/domain/usecase/auth/update_info_idol.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingPageState createState() => _NotificationSettingPageState();
}


class _NotificationSettingPageState extends State<NotificationSettingPage> {
  late Future<void> _initializeControllerFuture;
  var isSwitched = false.obs;
  final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
  ProfileResponse _profile = new ProfileResponse();
  @override
  void initState() {
    // TODO: implement initState
    _initializeControllerFuture = Future.wait([asyncInit()]);

  }

  Future<void> asyncInit() async {
    final either = await _accountInfoApi.fetchProfile();
    either.fold((l) => null, (res) {
      if (res.data != null) {
        _profile = ProfileResponse.fromMap(res.data);
        isSwitched.value = _profile.receiveNotification!;
      }
    });
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
                  child: Text("setting_notification_title".tr, style: TextUtils.textStyle(FontWeight.w400, 17.sp),),
                ),
                Obx(() => Container(
                  padding: EdgeInsets.only(right: 10.w),
                  height: 30.h,
                  child: FlutterSwitch(
                    width: 50.w,
                    toggleSize: 20.sp,
                    activeColor: AppColors.pink1,
                    value: isSwitched.value,
                    onToggle: (value) async {
                      isSwitched.value = value;
                     var response = await UpdateInfoIdol().call(InfoParams(field: "receiveNotification", content: isSwitched.value));
                      response.fold((failure) {}, (success) {
                        isSwitched.value = value;
                      });
                    },
                  ),
                ),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
