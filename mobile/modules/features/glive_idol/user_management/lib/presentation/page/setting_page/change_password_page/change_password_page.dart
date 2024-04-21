import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/presentation/controller/user/change_password_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/page/setting_page/change_password_page/widget/confirm_button.dart';
import 'package:user_management/presentation/page/setting_page/change_password_page/widget/password_input_field.dart';

class ChangePasswordPage extends StatefulWidget {
  final bool isCreatePassword;

  ChangePasswordPage({Key? key, this.isCreatePassword = false}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //controllers:-----------------------------------------------------------------
  late ChangePasswordStoreController _changePasswordStoreController;

  TextEditingController userIdTextController = TextEditingController();

  late Future<void> _initializeControllerFuture;

  List<bool> isSelected = [true, false];

  ShowErrorMessage showErrorMessage = ShowErrorMessage();

  @override
  void initState() {
    _changePasswordStoreController = Get.put(ChangePasswordStoreController());
    _changePasswordStoreController.isCreatePassword.value = widget.isCreatePassword;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      primary: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => {
            DeviceUtils.hideKeyboard(context),
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: SafeArea(child: DeviceUtils.buildWidget(context, _buildBody())),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildMainContent(),
          Obx(() => Visibility(
            visible: _changePasswordStoreController.isLoading.value,
            child: CustomProgressIndicatorWidget(),
          )),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Text(
                _changePasswordStoreController.isCreatePassword.value ? 'change_password_title_create'.tr : 'change_password_title_change'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.sp),
                textAlign: TextAlign.left,
              ),
            ),
            Visibility(
              visible: !_changePasswordStoreController.isCreatePassword.value,
              child: PasswordInputField(
                hint: 'change_password_old_password'.tr,
                passwordController: _changePasswordStoreController.passwordController,
                invalidPasswordMsg: _changePasswordStoreController.invalidPasswordMsg,
                showPassword: _changePasswordStoreController.showPassword,
              )
            ),
            PasswordInputField(
              hint: 'change_password_new_password'.tr,
              passwordController: _changePasswordStoreController.newPasswordController,
              invalidPasswordMsg: _changePasswordStoreController.invalidNewPasswordMsg,
              showPassword: _changePasswordStoreController.showNewPassword,
            ),
            PasswordInputField(
              hint: 'change_password_confirm_password'.tr,
              passwordController: _changePasswordStoreController.confirmPasswordController,
              invalidPasswordMsg: _changePasswordStoreController.invalidConfirmPasswordMsg,
              showPassword: _changePasswordStoreController.showConfirmPassword,
            ),
            SizedBox(
              height: 15.h,
            ),
            ConfirmButton(
              changePasswordStoreController: _changePasswordStoreController,
            ),
          ],
        ),
      ),
    );
  }
}
