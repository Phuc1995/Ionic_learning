import 'package:common_module/common_module.dart';
import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/identityType.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/page/account_verify/step2/widget/input_list_box_verify2.dart';
import 'package:user_management/presentation/page/account_verify/widget/common_verify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountVerifyStep2Home extends StatelessWidget {
  const AccountVerifyStep2Home({Key? key}) : super(key: key);

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
    AccountVerifyStoreController accountVerifyStoreController =
    Get.put(AccountVerifyStoreController());
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CommonVerify().titleField(
                    title: 'account_verify_title_step2',
                    subTitle: 'account_verify_sub_title_step2'),
                SizedBox(height: 24.h),
                InputListBoxVerify2(
                  onFileChanged: (file) {
                    accountVerifyStoreController.typeController.value = file;
                  },
                ),
                SizedBox(height: 140.h),
                CommonVerify().nextButton(context: context, submit: _submit),
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
                  child: CommonVerify().moreInfoTitle(),
                ),
              ],
            ),
          ),
        ));
  }

  _submit() {
    AccountVerifyStoreController accountVerifyStoreController = Get.put(AccountVerifyStoreController());
    if (accountVerifyStoreController.typeController.isEmpty) {
      accountVerifyStoreController.typeController.value = IdentityType.identityCard;
    }
    Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep3Screen);
  }
}
