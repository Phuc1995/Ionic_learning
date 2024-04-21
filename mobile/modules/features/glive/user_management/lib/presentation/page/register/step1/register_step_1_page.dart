import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/presentation/page/register/step1/widgets/confirm_button.dart';
import 'package:user_management/presentation/page/register/step1/widgets/user_id_field.dart';
import 'package:user_management/presentation/page/register/step1/widgets/password_register_field.dart';
import 'package:user_management/presentation/widgets/login_type_text.dart';
import 'package:user_management/presentation/widgets/main_title_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterStepFirstPage extends StatefulWidget {
  @override
  _RegisterStepFirstPageState createState() => _RegisterStepFirstPageState();
}

class _RegisterStepFirstPageState extends State<RegisterStepFirstPage> {
  List<bool> isSelected = [true, false];
  UserStoreController userStoreController = Get.put(UserStoreController());
  TextEditingController userIdTextController = TextEditingController();
  late Future<void> _initializeControllerFuture;
  TextEditingController _passwordController = TextEditingController();

  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);
  }
  Future<void> asyncInit() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Modular.to.navigate(ViewerRoutes.login);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(('login_btn_sign_in').tr,
                style: TextStyle(
                    color: Color.fromRGBO(255, 53, 133, 1),
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              Modular.to.pushReplacementNamed(ViewerRoutes.login);
            },
          )
        ],
      ),
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DeviceUtils.buildWidget(context, _bodyRegister(userStoreController));
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }

  Widget _bodyRegister(UserStoreController userStoreController) {
    return Stack(children: <Widget>[
      Center(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MainTitleWidget(title: ('register_step1').tr),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 80.h, 15.w, 0.h),
                  child: LoginTypeText(onPressed: () {
                    this.userStoreController.loginWithPhone.value = !this.userStoreController.loginWithPhone.value;
                    if (!this.userStoreController.loginWithPhone.value){
                      userStoreController.otpType.value = 'mail';
                    } else userStoreController.otpType.value = 'phone';
                    this.userIdTextController.text = '';
                    this.userStoreController.emailController.value = '';
                    this.userStoreController.phoneCodeController.value = '';
                    this.userStoreController.phoneController.value = '';
                    this.userStoreController.invalidEmailMsg.value = '';
                    this.userStoreController.isEnabledStep1Button.value = false;
                    this._passwordController.clear();
                    this.userStoreController.passwordController.value = '';
                  },
                    leftColorText: AppColors.suvaGrey,
                    rightColorText: AppColors.pinkLiveButtonCustom,
                    isRegister: true,
                  ),
                ),
                UserIdFieldRegister(
                  sharedPrefsHelper: _sharedPrefsHelper,
                  userStoreController: userStoreController,
                  textController: userIdTextController,
                ),
                PasswordRegisterField(userStoreController: userStoreController, passwordController: _passwordController,),
                SizedBox(height: 128.h),
                ConfirmButtonRegister(
                  userStoreController: userStoreController,
                ),
                _buildHintText()
              ],
            ),
          )),
      Obx(() => Visibility(
        visible: userStoreController.isLoading.value,
        child: CustomProgressIndicatorWidget(),
      ))
    ]);
  }

  Widget _buildHintText() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0.h, top: 8.h),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: ('register_password_hint').tr,
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF909090), height: 1.8.h),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
