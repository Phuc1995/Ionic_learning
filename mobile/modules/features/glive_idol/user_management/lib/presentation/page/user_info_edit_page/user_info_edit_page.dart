import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/response/category_response.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/domain/usecase/skills/get_skills_idol.dart';
import 'package:user_management/presentation/controller/skills/skills_controller.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/page/user_info_page/widget/active_status.dart';
import 'package:user_management/repository/user_info_api_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoEditPage extends StatelessWidget {
  final ProfileResponse profile;

  const UserInfoEditPage({Key? key, required this.profile}) : super(key: key);

  Widget build(BuildContext context) {
    UserStoreController userStoreController = Get.put(UserStoreController());
    SkillsController _skillsController = Get.put(SkillsController());
    _getSkillDol(userStoreController, _skillsController);
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
            _accountInfoApi.fetchProfile();
            Modular.to.pop();
          },
        ),
      ),
      body: SafeArea(
          child: DeviceUtils.buildWidget(context, _buildBody(context, profile, userStoreController, _skillsController))),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody(BuildContext context, ProfileResponse profile, UserStoreController userStoreController, SkillsController _skillsController) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildMainContent(context, profile, userStoreController, _skillsController),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ProfileResponse profile, UserStoreController userStoreController, SkillsController _skillsController) {
    userStoreController.avataEdit.value = profile.imageUrl ?? '';
    profile.intro == null
        ? userStoreController.editIntro.value = ''
        : userStoreController.editIntro.value = profile.intro.toString();
    if (profile.gId == null) {
      userStoreController.nickNameEdit.value = '';
    } else {
      userStoreController.nickNameEdit.value = profile.gId.toString();
    }
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
                    child: Stack(
                      children: [
                        _buildImage(userStoreController.avataEdit.value, userStoreController),
                        Padding(
                          padding: EdgeInsets.fromLTRB(11.w, 11.h, 11.w, 11.h),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ActiveStatus(
                                isInfo: true,
                                status: profile.identity != null
                                    ? profile.identity!.statusVerify
                                    : null,
                                note: this.profile.identity != null
                                    ? this.profile.identity!.note
                                    : null),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  _buildMenuItem(
                    title: 'edit_user_info_full_name'.tr,
                    text: profile.fullName ?? '',
                    visible: false,
                    onPressed: () {},
                  ),
                  Obx(
                    () => _buildMenuItem(
                      title: 'edit_user_info_nick_name'.tr,
                      text: userStoreController.nickNameEdit.value,
                      visible: true,
                      onPressed: () {
                        Modular.to.pushNamed(IdolRoutes.user_management.accountEditNickName, arguments: {
                          'profile_to_edit': profile,
                        });
                      },
                    ),
                  ),
                  _buildMenuItem(
                    title: 'edit_user_info_gender'.tr,
                    text: _convertGender(profile.gender!).tr,
                    visible: false,
                    onPressed: () {},
                  ),
                  _buildMenuItem(
                    text: profile.birthdate == null ? "" : formatDate(profile.birthdate.toString()),
                    visible: false,
                    title: 'edit_user_info_birthday'.tr,
                    onPressed: () {},
                  ),
                  _buildMenuItem(
                    text: profile.country ?? "",
                    visible: false,
                    title: 'edit_user_info_country'.tr,
                    onPressed: () {},
                  ),
                  Obx(() => _buildMenuItem(
                      title: 'edit_user_info_introduce'.tr,
                      text: userStoreController.editIntro.value,
                      visible: true,
                      isInfo: true,
                      onPressed: () =>
                          Modular.to.pushNamed(IdolRoutes.user_management.accountEditIntroPage, arguments: {
                        'profile_to_edit': profile,
                      }),
                    ),
                  ),
                  Obx(() => _buildMenuItem(
                    title: 'edit_user_info_forte'.tr,
                    text: userStoreController.editForte.value,
                    visible: true,
                    onPressed: () {
                      SkillsController _skillsController = Get.put(SkillsController());
                      _getSkillDol(userStoreController, _skillsController);
                      Modular.to.pushNamed(IdolRoutes.user_management.accountEditFortePage);
                    },
                  ),)
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
    if (gender == 0) {
      return "account_verify_female";
    }
    return "account_verify_male";
  }

  Widget _buildImage(String urlAvata, UserStoreController userStoreController) {
    userStoreController.getAvataUrl(urlAvata);
    return urlAvata == ''
        ? Center(
            child: Image.asset(Assets.defaultRoomAvatar),
          )
        : Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0.r),
              child: Image.network(
                userStoreController.storageUrl.value,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          );
  }

  void _getSkillDol(UserStoreController userStoreController, SkillsController skillsController) async {
    List<String> listTranslate = [];
    await GetSkillsIdol().call(NoParams()).then((result) {
      result.fold((l) => null, (data) {
        skillsController.listSkillsSelected.value = data['selected'] ;
        skillsController.listAllSkills.value = data['options'] as List<CategoryResponse>;
      });
    });
    skillsController.listSkillsSelected.forEach((element) {
      int index = skillsController.listAllSkills.indexWhere((item) => item.key == element);
      skillsController.listAllSkills[index].isCheck = true;
      listTranslate.add(skillsController.listAllSkills[index].name);
    });
    skillsController.listSkillsSelected.refresh();
    userStoreController.editForte.value = listTranslate.join(", ");
  }
}
