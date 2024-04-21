import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/presentation/page/login_page/widget/login_social_button.dart';
import 'package:user_management/presentation/page/login_page/widget/password_field.dart';
import 'package:user_management/presentation/page/login_page/widget/sign_in_button.dart';
import 'package:user_management/presentation/page/login_page/widget/sub_button.dart';
import 'package:user_management/presentation/page/login_page/widget/terms_field.dart';
import 'package:user_management/presentation/page/login_page/widget/title_field.dart';
import 'package:user_management/presentation/page/login_page/widget/user_id_field.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/widgets/login_type_text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  //controllers:-----------------------------------------------------------------
  UserStoreController userStoreController = Get.put(UserStoreController());
  TextEditingController userIdTextController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late Future<void> _initializeControllerFuture;

  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper= Modular.get<SharedPreferenceHelper>();

  ShowErrorMessage showErrorMessage = ShowErrorMessage();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);
  }

  Future<void> asyncInit() async {
    userStoreController.logout();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return Container(
        decoration: BoxDecoration(
          color: Color(0xFF80183E),
          image: DecorationImage(
            image: AssetImage(Assets.loginBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          primary: true,
          appBar: EmptyAppBar(),
          body: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SafeArea(child: DeviceUtils.buildWidget(context, _buildBody()));
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Center(child: _buildMainContent()),
          Obx(
            () => userStoreController.isSuccess.value
                ? navigate(context)
                : showErrorMessage.show(
                    context: context, message: userStoreController.errorMessage.value),
          ),
          Obx(() => userStoreController.isBan.value ? showDialogBox(context) : Container()),
          Obx(() => Visibility(
                visible: userStoreController.isLoading.value,
                child: CustomProgressIndicatorWidget(),
              )),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16.0.h),
            AppIconWidget(
              image: Assets.loginLogo,
              height: 100.h,
            ),
            SizedBox(height: 24.0.h),
            Visibility(visible: MediaQuery.of(context).size.height <= 640.h, child: TitleField()),
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 80.h, 15.w, 0.h),
              child: LoginTypeText(onPressed: (){
                this.userStoreController.loginWithPhone.value = !this.userStoreController.loginWithPhone.value;
                if (!this.userStoreController.loginWithPhone.value){
                  userStoreController.otpType.value = 'mail';
                } else userStoreController.otpType.value = 'phone';
                this.userStoreController.emailController.value = '';
                this.userStoreController.phoneCodeController.value = '';
                this.userStoreController.phoneController.value = '';
                this.userStoreController.invalidEmailMsg.value = '';
                this.userStoreController.passwordController.value = '';
                this.passwordController.text = '';
                this.userIdTextController.text = '';
              },),
            ),
            UserIdField(
              sharedPrefsHelper: _sharedPrefsHelper,
              userStoreController: userStoreController,
              textController: userIdTextController,
            ),
            PasswordField(userStoreController: userStoreController, passwordController: passwordController,),
            SignInButton(userStoreController: userStoreController),
            SubButton(userStoreController: userStoreController),
            LoginSocialButton(
              userStoreController: userStoreController,
            ),
            TermsField(),
          ],
        ),
      ),
    );
  }

  Widget navigate(BuildContext context) {
    _sharedPrefsHelper.setIsLoggedIn(true);
    String whereToGo = userStoreController.isNewUser.value ? ViewerRoutes.account_complete : ViewerRoutes.home;
    Modular.to.pushReplacementNamed(whereToGo,  arguments: {'currentPage' : 0});
    return Container();
  }

  Widget showDialogBox(BuildContext context) {
    return new CustomDialogBox(
      buttonText: ('button_close').tr,
      title: ('login_ban_message').tr,
      subTitle: ('login_ban_support'.tr) + _sharedPrefsHelper.supportEmail,
      onPressed: () => {
        userStoreController.isBan.value = false,
      },
      imgIcon: AppIconWidget(
        image: Assets.closeIcon,
        size: 155.sp,
        height: 150.h,
      )
    );
  }
}
