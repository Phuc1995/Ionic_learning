import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/page/account_verify/step1/widget/birth_date_field_verify.dart';
import 'package:user_management/presentation/page/account_verify/step1/widget/country_dropdown.dart';
import 'package:user_management/presentation/page/account_verify/step1/widget/gender_radio_button_verify.dart';
import 'package:user_management/presentation/page/account_verify/step1/widget/identity_number_verify.dart';
import 'package:user_management/presentation/page/account_verify/widget/common_verify.dart';
import 'package:user_management/presentation/page/account_verify/step1/widget/province_verify.dart';
import 'package:user_management/presentation/page/account_verify/step1/widget/username_verify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

class AccountVerifyStep1Home extends StatefulWidget {
  @override
  _AccountVerifyStep1HomeState createState() => _AccountVerifyStep1HomeState();
}

class _AccountVerifyStep1HomeState extends State<AccountVerifyStep1Home> {
  final _formKey = GlobalKey<FormState>();
  AccountVerifyStoreController _accountVerifyStoreController =
      Get.put(AccountVerifyStoreController());
  final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
  late Future<void> _initializeControllerFuture;
  ProfileResponse _profile = new ProfileResponse();
  bool _showPhoneInput = true;

  @override
  initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([
      fetchData(),
    ]);
  }

  Future fetchData() async {
    var responses = await _accountInfoApi.fetchProfile();
    responses.fold((l) => null, (res) {
      setState(() {
        if (res.data != null) {
          _profile = ProfileResponse.fromMap(res.data);
          _accountVerifyStoreController.mobileController.value = _profile.mobile;
          _showPhoneInput = _profile.username == _profile.mobile;
        } else {
          _profile = new ProfileResponse();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: DeviceUtils.buildWidget(context, _buildBody(context)),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        }
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
            onPressed: () => {Get.resetCustom(), Modular.to.navigate(IdolRoutes.user_management.home)},
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final logger = Modular.get<Logger>();

    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CommonVerify().titleField(
                    title: 'account_verify_title', subTitle: 'account_verify_sub_title'),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: ContryDropdown(
                    accountVerifyStoreController: _accountVerifyStoreController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: IdentityNumberVerify(
                      accountVerifyStoreController: _accountVerifyStoreController),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: UsernameVerify(
                    accountVerifyStoreController: _accountVerifyStoreController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GenderRadioButton(
                    accountVerifyStoreController: _accountVerifyStoreController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: BirthDateVerify(),
                ),
                new Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: ProvinceVerify(
                    accountVerifyStoreController: _accountVerifyStoreController,
                  ),
                ),
                SizedBox(height: 24.h),
                CommonVerify().nextButton(
                    context: context,
                    submit: () {
                          try {
                            if (_formKey.currentState!.validate()) {
                              logger.i(
                                  "identityNumberController: ${_accountVerifyStoreController.identityNumberController.value} \n"
                                      "fullNameController: ${_accountVerifyStoreController.fullNameController.value} \n"
                                      "genderController: ${_accountVerifyStoreController.genderController.value} \n"
                                      "birthdateController: ${_accountVerifyStoreController.birthdateController.value} \n"
                                      "provinceController: ${_accountVerifyStoreController.provinceController.value} \n"
                                      "mobileController: ${_accountVerifyStoreController.mobileController.value} \n"
                                      "typeController: ${_accountVerifyStoreController.typeController.value} \n"
                                      "photoFrontController: ${_accountVerifyStoreController.photoFrontController.value} \n"
                                      "photoBackController: ${_accountVerifyStoreController.photoBackController.value} \n");
                              Modular.to.pushNamed(IdolRoutes.user_management.accountVerifyStep2Screen);
                            }
                          } catch (err) {
                            String message = ('account_verify_error_unknown').tr;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(message)));
                          }
                    }),
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
                  child: CommonVerify().moreInfoTitle(),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
