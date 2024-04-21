import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/image_controller.dart';
import 'package:user_management/controllers/account_complete_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/presentation/page/account_complete_page/widget/intro_verify.dart';
import 'package:user_management/presentation/widgets/avatar_widget.dart';
import 'widget/birth_date_field_verify.dart';
import 'widget/common_verify.dart';
import 'widget/gender_radio_button_verify.dart';
import 'widget/nickname_verify.dart';
import 'widget/country_verify.dart';

class AccountComplete extends StatefulWidget {
  @override
  _AccountCompleteState createState() => _AccountCompleteState();
}

class _AccountCompleteState extends State<AccountComplete> {
  final _formKey = GlobalKey<FormState>();
  AccountCompleteController _accountCompleteController = Get.put(AccountCompleteController());
  UserStoreController _userStoreController = Get.put(UserStoreController());
  ImageController imageController = Get.put(ImageController());
  String profileUrl = '';

  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;
  late Future<void> _initializeControllerFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  initState() {
    _initializeControllerFuture = Future.wait([_initSharedPrefs()]);
    super.initState();
  }

  Future<void> _initSharedPrefs() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
  }


  @override
  void dispose() {
    super.dispose();
  }


@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.navigate(ViewerRoutes.home,  arguments: {'currentPage' : 0});
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
              child: Text(('account_verify_ignore').tr,
                  style: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)),
              onPressed: () => {Get.resetCustom(), Modular.to.pushReplacementNamed(ViewerRoutes.home, arguments: {'currentPage' : 0})},
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CommonVerify()
                    .titleField(title: 'account_complete_title', subTitle: 'complete_your_info'),
                Center(
                  child: Container(
                    child: Obx(() => AvatarWidget(
                      storageUrl: _userStoreController.storageUrl.value,
                      fileUrl: profileUrl,
                      onChange: (String val) {
                        setState(() {
                          profileUrl = val;
                        });
                      },
                    ),
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: NicknameVerify(
                    accountCompleteController: _accountCompleteController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GenderRadioButton(
                    accountCompleteController: _accountCompleteController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: BirthDateVerify(),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: IntroVerify(
                    accountCompleteController: _accountCompleteController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: CountryVerify(
                    accountCompleteController: _accountCompleteController,
                  ),
                ),
                SizedBox(height: 24.h),
                CommonVerify().nextButton(
                    context: context,
                    submit: () {
                      try {
                        if (_formKey.currentState!.validate()) {
                          submit();
                        }
                      } catch (err) {
                        String message = ('account_verify_error_unknown').tr;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      }
                    }),
              ],
            ),
          ),
        ));
  }

  void submit() async {
    var result = await _accountCompleteController.accountProfile();
    result.fold((failure) {
      _accountCompleteController.isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(('account_verify_error_unknown').tr)));
    }, (success) {
      _accountCompleteController.isLoading.value = false;
      Modular.to.navigate(ViewerRoutes.hot_idol);
    });
  }
}
