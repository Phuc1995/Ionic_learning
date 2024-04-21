import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/controllers/link_account_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/page/setting_page/link_account_phone_email/widget/confirm_button.dart';
import 'package:user_management/presentation/page/setting_page/link_account_phone_email/widget/user_id_field.dart';
import 'package:user_management/presentation/page/setting_page/link_account_phone_email/widget/verify_code_field.dart';

class LinkAccountPhoneEmailPage extends StatefulWidget {
  final bool isPhone;

  LinkAccountPhoneEmailPage({Key? key, this.isPhone = true}) : super(key: key);

  @override
  _LinkAccountPhoneEmailPageState createState() => _LinkAccountPhoneEmailPageState();
}

class _LinkAccountPhoneEmailPageState extends State<LinkAccountPhoneEmailPage> {
  late LinkAccountStoreController _storeController = Get.put(LinkAccountStoreController());
  TextEditingController userIdTextController = TextEditingController();
  late Future<void> _initializeControllerFuture;
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  ShowErrorMessage showErrorMessage = ShowErrorMessage();

  @override
  void initState() {
    _storeController.isPhone.value = widget.isPhone;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarCommonWidget.build(widget.isPhone ? 'link_account_connect_phone'.tr : 'link_account_connect_email'.tr, () {
        Modular.to.pop({
          'isConfirm': false,
        });
      }),
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(child: DeviceUtils.buildWidget(context, _buildBody()));
            } else {
              // Otherwise, display a loading indicator.
              return CustomProgressIndicatorWidget();
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
            visible: _storeController.isLoading.value,
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
            PhoneEmailFiled(
              storeController: _storeController,
              textController: userIdTextController,
            ),
            SizedBox(
              height: 16.h,
            ),
            VerifyCodeField(
              storeController: _storeController,
            ),
            SizedBox(
              height: 50.h,
            ),
            ConfirmButton(
              storeController: _storeController,
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
