import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/page/register/step2/widget/register_button.dart';
import 'package:user_management/presentation/page/register/step2/widget/verify_code_field.dart';
import 'package:user_management/presentation/widgets/main_title_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterSecondPage extends StatelessWidget {
  const RegisterSecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserStoreController _userStoreController = Get.put(UserStoreController());

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(('login_btn_sign_in').tr,
                style: TextStyle(
                    color: Color.fromRGBO(255, 53, 133, 1),
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              Modular.to.navigate(IdolRoutes.user_management.login);
            },
          )
        ],
      ),
      body: DeviceUtils.buildWidget(context, _bodyRegister(_userStoreController)),
    );;
  }

  Widget _bodyRegister(UserStoreController userStoreController) {
    return Stack(children: <Widget>[
      Center(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(25),
          child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MainTitleWidget(title: ('register_step2').tr),
                  VerifyCodeRegister(userStoreController: userStoreController),
                  SizedBox(height: 180.h),
                  RegisterButton(userStoreController: userStoreController),
                ],
              )
          ),
        ),
      ),
      Obx(() => Visibility(
        visible: userStoreController.isLoading.value,
        child: CustomProgressIndicatorWidget(),
      )),
    ]);
  }


}
