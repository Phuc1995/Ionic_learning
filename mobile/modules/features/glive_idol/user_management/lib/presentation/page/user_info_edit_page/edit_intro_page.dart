import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/domain/usecase/auth/update_info_idol.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditIntroPage extends StatefulWidget {
  final ProfileResponse profile;

  const EditIntroPage({Key? key, required this.profile}) : super(key: key);

  @override
  _EditIntroPageState createState() => _EditIntroPageState();
}

class _EditIntroPageState extends State<EditIntroPage> {
  UserStoreController _userStoreController = Get.put(UserStoreController());
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        title: Center(
            child: Text(
          "edit_user_info_edit_intro_title".tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Modular.to.pop();
          },
        ),
        actions: [
          TextButton(
              onPressed: () => _onPressed(_userStoreController),
              child: Text(
                "edit_user_info_button_save".tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ConvertCommon().hexToColor("#DD2863"),
                ),
              ))
        ],
      ),
      body: DeviceUtils.buildWidget(context, _buildBody(_userStoreController)),
    );
  }

  Widget _buildBody(UserStoreController userStoreController) {
    _textEditingController.text =
        widget.profile.intro == null ? '' : widget.profile.intro.toString();
    return Stack(children: <Widget>[
      Container(
        color: ConvertCommon().hexToColor("#E5E5E5"),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 5.h, 0, 0),
              color: Colors.white,
              child: Container(
                  margin: EdgeInsets.only(left: 20.w, top: 22.h),
                  child: Text("edit_user_info_introduce".tr)),
              width: double.infinity,
            ),
            Flexible(
              child: TextFieldWidget(
                maxLines: true,
                filled: true,
                radiusCustom: BorderRadius.circular(5.r),
                contentPadding: EdgeInsets.fromLTRB(20.w, 16.h, 32.w, 16.h),
                fillColor: Colors.white,
                maxLength: 80,
                padding: EdgeInsets.only(top: 0.0),
                textController: _textEditingController,
                inputType: TextInputType.text,
                errorText: (userStoreController.introEdit.value != '' &&
                        userStoreController.introEdit.value != widget.profile.intro)
                    ? null
                    : userStoreController.invalidEmailMsg.value,
                errorStyle: TextStyle(color: Color(0xFFFF0000)),
                onChanged: (value) {
                  userStoreController.introEdit.value = _textEditingController.text;
                },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15.w, top: 0),
                child: Text(
                  "edit_user_info_intro_max_length".tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: ConvertCommon().hexToColor("#8A8A8A")),
                ),
              ),
            )
          ],
        ),
      ),
      Obx(() => Visibility(
            visible: userStoreController.isLoading.value,
            child: CustomProgressIndicatorWidget(),
          )),
    ]);
  }

  void _onPressed(UserStoreController userStoreController) async {
    userStoreController.isLoading.value = true;
    widget.profile.intro = _textEditingController.text;
    final respone =
        await UpdateInfoIdol().call(InfoParams(field: "intro", content: widget.profile.intro!));
    respone.fold((failure) {
      userStoreController.isLoading.value = false;
      ShowErrorMessage().show(context: context, message: "edit_user_info_message_error".tr);
    }, (success) {
      userStoreController.editIntro.value = _textEditingController.text;
      userStoreController.isLoading.value = false;
      Modular.to.pop();
    });
  }
}
