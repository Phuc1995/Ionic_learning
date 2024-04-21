import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/page/account_verify/step4/widget/Content.dart';
import 'package:user_management/presentation/page/account_verify/step4/widget/upload_image_portrait.dart';
import 'package:user_management/presentation/page/account_verify/widget/common_verify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountVerifyStep4Page extends StatelessWidget {
  const AccountVerifyStep4Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccountVerifyStoreController _accountVerifyStoreController =
        Get.put(AccountVerifyStoreController());
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Center(child: _buildBody(context, _accountVerifyStoreController)),
          Obx(() => Visibility(
                visible: _accountVerifyStoreController.isLoading.value,
                child: CustomProgressIndicatorWidget(),
              ))
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, AccountVerifyStoreController accountVerifyStoreController) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: DeviceUtils.buildWidget(
            context, _buildMainContent(context, accountVerifyStoreController)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => {
            accountVerifyStoreController.portraitController.value = '',
            Navigator.of(context).pop()
          },
        ),
        actions: <Widget>[
          TextButton(
              child: Text(('account_verify_ignore').tr,
                  style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () => {Get.resetCustom(), Modular.to.navigate(IdolRoutes.user_management.home)})
        ],
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context, AccountVerifyStoreController accountVerifyStoreController) {
    final _formKey = GlobalKey<FormState>();
    AccountVerifyStoreController accountVerifyStoreController =
        Get.put(AccountVerifyStoreController());
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CommonVerify().titleField(
                    title: 'account_verify_title_step4',
                    subTitle: 'account_verify_sub_title_step4'),
                SizedBox(height: 40.h),
                Obx(
                      () => UploadConfirmPortraitWidget(
                    accountVerifyStoreController: accountVerifyStoreController,
                    title: 'account_verify_sub_title_step4'.tr,
                    image: accountVerifyStoreController.portraitController.value,
                  ),
                ),
                SizedBox(height: 40.h),
                ContentStep4Verify(),
                SizedBox(height: 70.h),
                CommonVerify().nextButton(
                    context: context, submit: () => submit(context, accountVerifyStoreController)),
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
                  child: CommonVerify().moreInfoTitle(),
                ),
              ],
            ),
          ),
        ));
  }

  void submit(
      BuildContext context, AccountVerifyStoreController accountVerifyStoreController) async {
    ShowErrorMessage showErrorMessage = ShowErrorMessage();

    accountVerifyStoreController.isLoading.value = true;
    if (accountVerifyStoreController.portraitController.isNotEmpty) {
      var result = await accountVerifyStoreController.identifyIdol();
      result.fold((failure) {
        accountVerifyStoreController.isLoading.value = false;
        showErrorMessage.show(context: context, message: 'account_verify_error_unknown'.tr);
      }, (success) {
        accountVerifyStoreController.isLoading.value = false;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new CustomDialogBox(
                buttonText: ('button_close').tr,
                title: ('account_verify_complete').tr,
                onPressed: () =>
                    {Get.resetCustom(), Modular.to.navigate(IdolRoutes.user_management.favorite)},
                imgIcon: AppIconWidget(
                  image: Assets.shieldIcon,
                  size: 155.sp,
                  height: 150.h,
                )
              );
            });
      });
    } else {
      accountVerifyStoreController.isLoading.value = false;
      showErrorMessage.show(context: context, message: 'account_verify_port_empty'.tr);
    }
  }
}
