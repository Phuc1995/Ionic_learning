import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/link_account_widget.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/social_account_widget.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

class LinkAccountSettingPage extends StatefulWidget {

  const LinkAccountSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _LinkAccountSettingPageState createState() => _LinkAccountSettingPageState();
}

class _LinkAccountSettingPageState extends State<LinkAccountSettingPage> {
  UserStoreController userStoreController = Get.put(UserStoreController());
  late Future<void> _initializeControllerFuture;
  var isSwitched = false.obs;
  final UserInfoApiRepository _accountInfoApi =
      Modular.get<UserInfoApiRepository>();
  ProfileResponse profile = new ProfileResponse();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([fetchProfile()]);
  }

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
  Widget build(BuildContext context) {
    AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarCommonWidget.build('setting_link_account'.tr, () {
        Modular.to.pop();
      }),
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
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
                userStoreController: userStoreController,
                profile: profile,
                onBack: (value) async {
                  await fetchProfile();
                  bool isConfirm = false;
                  if (value != null) {
                    isConfirm = (value as Map)['isConfirm']??false;
                  }
                  if (isConfirm && profile.passwordUpdatedDate == null) {
                    Modular.to.pushNamed(IdolRoutes.user_management.settingChangePasswordPage,
                        arguments: {
                          'isCreatePassword': true,
                        });
                  }
                },
              ),
              SocialAccountWidget(userStoreController: userStoreController, profile: profile, onSuccess: fetchProfile,),
              Visibility(
                  visible: this.profile.needLinkAccount(),
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
          visible: userStoreController.isLoading.value,
          child: CustomProgressIndicatorWidget()
        )),
      ],
    );
  }
}
