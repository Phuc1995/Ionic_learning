import 'package:common_module/common_module.dart';
import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/constants/identityType.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/page/account_verify/step3/widget/main_title.dart';
import 'package:user_management/presentation/page/account_verify/step3/widget/upload_image_verify_back.dart';
import 'package:user_management/presentation/page/account_verify/widget/common_verify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/upload_image_verify_front.dart';

class AccountVerifyStep3Home extends StatelessWidget {
  const AccountVerifyStep3Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: DeviceUtils.buildWidget(context, _buildBody(context)),
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
          onPressed: () {
            final AccountVerifyStoreController accountVerifyStoreController =
                Get.put(AccountVerifyStoreController());
            accountVerifyStoreController.resetPhoto();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(('account_verify_ignore'.tr),
                style: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)),
            onPressed: () => {Get.resetCustom(), Modular.to.navigate(IdolRoutes.user_management.home)},
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final AccountVerifyStoreController accountVerifyStoreController =
        Get.put(AccountVerifyStoreController());
    final title = accountVerifyStoreController.typeController.value == IdentityType.identityCard
        ? 'account_verify_confirm_identity'
        : accountVerifyStoreController.typeController.value == IdentityType.passport
            ? 'account_verify_confirm_passport'
            : 'account_verify_confirm_driver';
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                MainTitleWidget(
                  title: title,
                  bottom: 24.h,
                ),
                Obx(
                  () => UploadConfirmFrontWidget(
                    accountVerifyStoreController: accountVerifyStoreController,
                    title: 'account_verify_upload_frontend'.tr,
                    icon: accountVerifyStoreController.typeController.value ==
                            IdentityType.identityCard
                        ? CustomIcons.cccd_front
                        : accountVerifyStoreController.typeController.value == IdentityType.passport
                            ? CustomIcons.passport_outline
                            : CustomIcons.driver_lic,
                    image: accountVerifyStoreController.photoFrontController.value,
                  ),
                ),
                Obx(() => Visibility(
                      visible: accountVerifyStoreController.typeController.value ==
                          IdentityType.identityCard,
                      child: UploadConfirmBackWidget(
                        accountVerifyStoreController: accountVerifyStoreController,
                        title: 'account_verify_upload_backend'.tr,
                        icon: CustomIcons.cccd_front,
                        image: accountVerifyStoreController.photoBackController.value,
                      ),
                    )),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'account_verify_image_valid'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                    height: accountVerifyStoreController.typeController.value ==
                            IdentityType.identityCard
                        ? 120.h
                        : 200.h),
                CommonVerify().nextButton(
                    context: context, submit: () => _submit(context, accountVerifyStoreController)),
              ],
            ),
          ),
        ));
  }

  _submit(BuildContext context, AccountVerifyStoreController accountVerifyStoreController) {
    if (accountVerifyStoreController.isPhotoIdentityBlank(
        context, accountVerifyStoreController.typeController.value)) {
      ShowErrorMessage showErrorMessage = ShowErrorMessage();
      showErrorMessage.show(context: context, message: 'account_verify_image_empty'.tr);
      return;
    }
    Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep4Screen);
  }
}
