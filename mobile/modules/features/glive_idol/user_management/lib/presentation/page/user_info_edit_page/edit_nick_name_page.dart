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

class EditNickNamePage extends StatefulWidget {
  final ProfileResponse profile;

  const EditNickNamePage({Key? key, required this.profile}) : super(key: key);

  @override
  _EditNickNamePageState createState() => _EditNickNamePageState();
}

class _EditNickNamePageState extends State<EditNickNamePage> {
  UserStoreController _userStoreController = Get.put(UserStoreController());
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userStoreController.isLoading.value = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        title: Center(
            child: Text(
          "edit_user_info_nick_name_title".tr,
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
    _textEditingController.text = widget.profile.gId == null ? "" : widget.profile.gId.toString();
    return Stack(children: <Widget>[
      Container(
        color: ConvertCommon().hexToColor("#E5E5E5"),
        child: Column(
          children: <Widget>[
            TextFieldWidget(
              filled: true,
              radiusCustom: BorderRadius.circular(5.r),
              contentPadding: EdgeInsets.fromLTRB(20.w, 16.h, 32.w, 16.h),
              fillColor: Colors.white,
              maxLength: 25,
              hint: 'edit_user_info_nick_name'.tr,
              padding: EdgeInsets.only(top: 5.0.h),
              textController: _textEditingController,
              inputType: TextInputType.text,
              errorStyle: TextStyle(color: Color(0xFFFF0000)),
              onChanged: (value) {},
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15.w, top: 20.h),
                child: Text(
                  "edit_user_info_nick_name_max_length".tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: ConvertCommon().hexToColor("#8A8A8A"),
                  ),
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
    if (("" + _textEditingController.text).trim() == "") {
      _textEditingController.text = ("" + _textEditingController.text).trim();
      ShowErrorMessage().show(context: context, message: "edit_user_info_nick_name_empty".tr);
    } else {
      userStoreController.isLoading.value = true;
      widget.profile.gId = _textEditingController.text.trim();
      final respone =
          await UpdateInfoIdol().call(InfoParams(field: "gId", content: widget.profile.gId!));
      respone.fold((failure) {
        userStoreController.isLoading.value = false;
        if (failure is DioFailure) {
          if (failure.messageCode == MessageCode.NICK_NAME_EXIST) {
            ShowErrorMessage().show(context: context, message: "edit_user_info_nick_name_exist".tr);
          } else {
            ShowErrorMessage().show(context: context, message: "edit_user_info_message_error".tr);
          }
        } else {
          ShowErrorMessage().show(context: context, message: "edit_user_info_message_error".tr);
        }
      }, (success) {
        userStoreController.isLoading.value = false;
        userStoreController.nickNameEdit.value = _textEditingController.text.trim();
        Modular.to.pop();
      });
    }
  }
}
