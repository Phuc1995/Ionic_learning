import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/controllers/reset_password_store_controller.dart';
import 'package:user_management/presentation/page/forgot_password/widget/confirm_button.dart';
import 'package:user_management/presentation/page/forgot_password/widget/forget_pass_type_text.dart';
import 'package:user_management/presentation/page/forgot_password/widget/main_title.dart';
import 'package:user_management/presentation/page/forgot_password/widget/new_password_field.dart';
import 'package:user_management/presentation/page/forgot_password/widget/password_info_field.dart';
import 'package:user_management/presentation/page/forgot_password/widget/user_id_field.dart';
import 'package:user_management/presentation/page/forgot_password/widget/verify_code_field.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  //controllers:-----------------------------------------------------------------
  late ResetPasswordStoreController _resetPasswordStoreController;
  TextEditingController userIdTextController = TextEditingController();
  late Future<void> _initializeControllerFuture;

  List<bool> isSelected = [true, false];

  ShowErrorMessage showErrorMessage = ShowErrorMessage();

  @override
  void initState() {
    _resetPasswordStoreController = Get.put(ResetPasswordStoreController());
    _initializeControllerFuture = Future.wait([asyncInit()]);
    super.initState();
  }
  Future<void> asyncInit() async {
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    setState(() {
      this.isSelected[0] = _resetPasswordStoreController.loginWithPhone.value;
      this.isSelected[1] = !_resetPasswordStoreController.loginWithPhone.value;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      primary: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
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
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(child: DeviceUtils.buildWidget(context, _buildBody()));
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
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
                visible: _resetPasswordStoreController.isLoading.value,
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
            MainTitleWidget(
              title: 'forgot_password_title'.tr,
              bottom: 24.h,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 50.h, 15.w, 0.h),
              child: ForgotPassText(onPressed: (){
                this._resetPasswordStoreController.loginWithPhone.value = !this._resetPasswordStoreController.loginWithPhone.value;
                this.userIdTextController.text = '';
                this._resetPasswordStoreController.emailController.value = '';
                this._resetPasswordStoreController.phoneCodeController.value = '';
                this._resetPasswordStoreController.phoneController.value = '';
                this._resetPasswordStoreController.invalidEmailMsg.value = '';
                this._resetPasswordStoreController.passwordController.value = '';
              },
                leftColorText: AppColors.suvaGrey,
                rightColorText: AppColors.pinkLiveButtonCustom,
              ),
            ),
            // LoginTypeButton(onPressed: (int index) {
            //   setState(() {
            //     bool oldValue = this._resetPasswordStoreController.loginWithPhone.value;
            //     for (var i = 0; i < this.isSelected.length; i++) {
            //       this.isSelected[i] = index == i;
            //       this._resetPasswordStoreController.loginWithPhone.value = index == 0;
            //     }
            //     if (this._resetPasswordStoreController.loginWithPhone.value != oldValue) {
            //       this.userIdTextController.text = '';
            //       this._resetPasswordStoreController.invalidEmailMsg.value = '';
            //       this._resetPasswordStoreController.emailController.value = '';
            //       this._resetPasswordStoreController.phoneCodeController.value = '';
            //       this._resetPasswordStoreController.phoneController.value = '';
            //     }
            //   });
            // }, isSelected: isSelected),
            UserIdFiled(
              textController: userIdTextController,
              resetPasswordStoreController: _resetPasswordStoreController,
            ),
            SizedBox(
              height: 16.h,
            ),
            VerifyCodeField(
              resetPasswordStoreController: _resetPasswordStoreController,
            ),
            NewPasswordField(
              resetPasswordStoreController: _resetPasswordStoreController,
            ),
            SizedBox(
              height: 50.h,
            ),
            ConfirmButton(
              resetPasswordStoreController: _resetPasswordStoreController,
            ),
            SizedBox(
              height: 15.h,
            ),
            PasswordInfoField(),
          ],
        ),
      ),
    );
  }
}
