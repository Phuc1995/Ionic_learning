import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:get/get.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/page/user_info_edit_page/widget/user_info_edit_widget.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoEditPage extends StatelessWidget {
  const UserInfoEditPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    UserStoreController userStoreController = Get.put(UserStoreController());
    return Scaffold(
      backgroundColor: Colors.white,
      primary: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.light,
        title: Container(
            child: Text(
              "edit_user_info_title".tr,
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
            final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
            _accountInfoApi.fetchProfile().then((data) {
              data.fold((l) => null, (res) {
                if (res.data != null) {
                  userStoreController.profile.value = ProfileResponseDto.fromMap(res.data);
                } else {
                  userStoreController.profile.value = new ProfileResponseDto();
                }
              });
            });
            Modular.to.pop();
          },
        ),
      ),
      body: SafeArea(
          child: DeviceUtils.buildWidget(context, _buildBody(userStoreController.profile.value, userStoreController, context))),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody(ProfileResponseDto profile, UserStoreController userStoreController, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildMainContent(profile, userStoreController, context),
        ],
      ),
    );
  }

  Widget _buildMainContent(ProfileResponseDto profile, UserStoreController userStoreController, BuildContext context) {
    final df = new DateFormat('dd-MM-yyyy');
    userStoreController.avatarEdit.value = profile.imageUrl ?? '';
    userStoreController.gliveIdEdit.value = profile.gId??"";
    userStoreController.gliveIdEdit.value = profile.gId??"";
    userStoreController.fullNameEdit.value = profile.fullName??"";
    userStoreController.editGender.value = _convertGender(profile.gender??0).tr;
    userStoreController.editBirthday.value = profile.birthdate == null || profile.birthdate == "" ? "" :formatDate(profile.birthdate??"").toString();
    userStoreController.editIntro.value =  profile.intro??"";
    userStoreController.editAddress.value =  profile.province??"";
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Obx(
                () => Container(
                    height: 350.h,
                    child: _buildImage(userStoreController.avatarEdit.value, userStoreController)),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Obx(() => _buildMenuItem(
                      title: 'edit_user_info_nick_name'.tr,
                      text: userStoreController.gliveIdEdit.value,
                      visible: false,
                      onPressed: () {
                      },
                    ),
                  ),
                  Obx(() => _buildMenuItem(
                    title: 'edit_user_info_full_name'.tr,
                    text: userStoreController.fullNameEdit.value,
                    visible: true,
                    onPressed: () {
                      _showDialog(
                          context,
                          userStoreController,
                          isNotNull: true,
                          title: "edit_user_info_full_name_title".tr,
                          maxLength: 25,
                          data: userStoreController.fullNameEdit.value,
                          onSubmit: () async {
                            userStoreController.updateInfo(editField: userStoreController.fullNameEdit, field: "fullName");
                          }
                      );
                    },
                  ),
                  ),
                  Obx(() => _buildMenuItem(
                    title: 'edit_user_info_gender'.tr,
                    text: userStoreController.editGender.value,
                    visible: true,
                    onPressed: () {
                      _showGenderDialog(context, userStoreController, data: profile.gender!, onSubmit: (){});
                    },
                  ),),
                  Obx(()=> _buildMenuItem(
                    text: userStoreController.editBirthday.value,
                    visible: true,
                    title: 'edit_user_info_birthday'.tr,
                    onPressed: () async {
                      DateTime? nowDate = DateTime.now();
                      DateTime? date = new DateTime(nowDate.year - 18, nowDate.month, nowDate.day);
                      date = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          context: context,
                          initialDate: userStoreController.editBirthday.value != ''
                              ? DateFormat('dd-MM-yyyy').parse(userStoreController.editBirthday.value)
                              : new DateTime(nowDate.year - 15, nowDate.month, nowDate.day),
                          firstDate: DateTime(1900, 1, 1),
                          lastDate: new DateTime(nowDate.year - 15, nowDate.month, nowDate.day));
                      userStoreController.editBirthday.value = df.format(date!);
                      var inputFormat = DateFormat("dd-MM-yyyy");
                      var birthdate = inputFormat.parse(userStoreController.editBirthday.value);
                      String tmp = DateFormat('yyyy-MM-dd').parse('$birthdate').toString();
                      await userStoreController.updateViewerInfo(field: "birthdate", content: tmp);
                    },
                  ),),
                  Obx(() => _buildMenuItem(
                    title: 'edit_user_info_introduce'.tr,
                    text: userStoreController.editIntro.value,
                    visible: true,
                    onPressed: () {
                      _showDialog(
                          context,
                          userStoreController,
                          isNotNull: false,
                          title: "edit_user_info_introduce".tr + ":",
                          maxLength: 80,
                          data: userStoreController.editIntro.value,
                          onSubmit: () async {
                            userStoreController.updateInfo(editField: userStoreController.editIntro, field: "intro");
                          }
                      );
                    },
                  ),
                  ),
                  Obx(() => _buildMenuItem(
                    title: 'edit_user_info_country'.tr,
                    text: userStoreController.editAddress.value,
                    visible: true,
                    onPressed: () {
                      _showDialog(
                          context,
                          userStoreController,
                          isNotNull: false,
                          title: "edit_user_info_country".tr + ":",
                          maxLength: 50,
                          data: userStoreController.editAddress.value,
                          onSubmit: () async {
                            userStoreController.updateInfo(editField: userStoreController.editAddress, field: "address");
                          }
                      );
                    },
                  ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatDate(String dateServer) {
    var parsedDate = DateTime.parse(dateServer);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(parsedDate);
  }

  Widget _buildMenuItem({
    required String title,
    required String text,
    required bool visible,
    bool isInfo = false,
    String info = '',
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextUtils.textStyle(FontWeight.w400, 17.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 200.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: Colors.black26)
                        ),
                      ),
                    ),
                    Visibility(
                      visible: visible,
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.whiteSmoke,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            height: 2.h,
          )
        ],
      ),
      onPressed: onPressed,
    );
  }

  String _convertGender(int gender) {
    String result = "";
    switch (gender) {
      case 0:
        result = "account_verify_female";
        break;
      case 1:
        result = "account_verify_male";
        break;
      case 2:
        result = "account_verify_other";
        break;
      default:
        result = "account_verify_male";
        break;
    }
    return result;
  }

  Widget _buildImage(String urlAvata, UserStoreController userStoreController) {
    userStoreController.getAvatarUrl(urlAvata);
    return urlAvata == ''
        ? Center(
            child: Image.asset(Assets.defaultRoomAvatar),
          )
        : Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0.r),
              child: CachedNetworkImage(
                  imageUrl: userStoreController.avartarUrl.value,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                      height: 125.h,
                      width: 125.w,
                      child: Center(
                        child: Image.asset(Assets.defaultRoomAvatar),
                      ),
                  ),
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
          );
  }

  void _showDialog(BuildContext context, UserStoreController controller, {required String title, required int maxLength, required String data, required Function onSubmit, required bool isNotNull}){
    TextEditingController textController = TextEditingController();
    textController.text = data;
    controller.editValue.value = data;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title, style: TextUtils.textStyle(FontWeight.w500, 14.sp),),
            content: TextField(
              minLines: 1,
              maxLines: 6,
              maxLength: maxLength,
              controller: textController,
              onChanged: (value){
                controller.editValue.value = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('edit_user_info_button_cancel'.tr)),
              Obx(()=> TextButton(
                onPressed: (controller.editValue.value.trim() == "" && isNotNull)? null : (){
                  onSubmit();
                },
                child: Text('edit_user_info_button_save'.tr),
              ))
            ],
          );
        });
  }

  void _showGenderDialog(BuildContext context, UserStoreController controller, {required int data, required Function onSubmit}){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserInfoEditWidget().genderItem(0,"account_verify_male", context, false),
                  UserInfoEditWidget().genderItem(1,"account_verify_female", context, false),
                  UserInfoEditWidget().genderItem(2,"account_verify_other", context, true),
              ],),
            ),
          );
        });
  }


}
