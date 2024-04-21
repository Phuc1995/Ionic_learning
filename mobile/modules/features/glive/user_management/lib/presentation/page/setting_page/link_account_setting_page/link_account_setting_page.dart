import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/profile_response_dto.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/link_account_widget.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/social_account_widget.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';

class LinkAccountSettingPage extends StatefulWidget {

  const LinkAccountSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _LinkAccountSettingPageState createState() => _LinkAccountSettingPageState();
}

class _LinkAccountSettingPageState extends State<LinkAccountSettingPage> {
  UserStoreController _userStoreController = Get.put(UserStoreController());
  var isSwitched = false.obs;

  @override
  void initState() {
    super.initState();
    _userStoreController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarCommonWidget.build('setting_link_account'.tr, () {
        Modular.to.pop();
      }),
      body: FutureBuilder<void>(
          future: _userStoreController.fetchProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(child: DeviceUtils.buildWidget(context, _buildBody()));
            } else {
              // Otherwise, display a loading indicator.
              return const CustomProgressIndicatorWidget();
            }
          }
        ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 4.w,
                  color: AppColors.whiteSmoke2,
                ),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinkAccountWidget(
                userStoreController: _userStoreController,
                profile: _userStoreController.profile.value,
                onBack: (value) async {
                  _userStoreController.fetchProfile();
                  bool isConfirm = false;
                  if (value != null) {
                    isConfirm = (value as Map)['isConfirm']??false;
                  }
                  if (isConfirm && _userStoreController.profile.value.passwordUpdatedDate == null) {
                    Modular.to.pushNamed(IdolRoutes.user_management.settingChangePasswordPage,
                        arguments: {
                          'isCreatePassword': true,
                        });
                  }
                },
              ),
              SocialAccountWidget(userStoreController: _userStoreController, profile: _userStoreController.profile.value, onSuccess: _userStoreController.fetchProfile,),
              Visibility(
                  visible: _userStoreController.profile.value.needLinkAccount(),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('link_account_warning_text'.tr,
                        style: TextUtils.textStyle(FontWeight.w400, 15.sp,
                            color: Colors.red)),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: Text('link_account_hint_text'.tr,
                    style: TextUtils.textStyle(FontWeight.w600, 15.sp)),
              ),
            ],
          ),
        ),
        Obx(() => Visibility(
          visible: _userStoreController.isLoading.value,
          child: CustomProgressIndicatorWidget()
        )),
      ],
    );
  }
}
