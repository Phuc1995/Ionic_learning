import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/identityType.dart';
import 'package:user_management/domain/entity/request/account-info.dart';
import 'package:user_management/domain/usecase/auth/identify_idol.dart';

class AccountVerifyStoreController extends GetxController {
  late SharedPreferenceHelper _sharedPrefsHelper;

  AccountVerifyStoreController();

  var fullNameController = ''.obs;
  var countryController = ''.obs;
  var provinceController = ''.obs;
  var birthdateController = ''.obs;
  var identityNumberController = ''.obs;
  var genderController = 0.obs;
  var typeController = ''.obs;
  var photoFrontController = ''.obs;
  var photoBackController = ''.obs;
  var portraitController = ''.obs;
  var mobileController = ''.obs;

  var invalidFullNameMsg = ''.obs;
  var invalidCountryMsg = ''.obs;
  var invalidProvinceMsg = ''.obs;
  var invalidBirthdateMsg = ''.obs;
  var invalidIdentityNumberMsg = ''.obs;
  var invalidGenderMsg = ''.obs;
  var invalidTypeMsg = ''.obs;
  var invalidPhotoFrontMsg = ''.obs;
  var invalidPhotoBackMsg = ''.obs;
  var invalidPortraitMsg = ''.obs;
  var invalidMobileMsg = ''.obs;

  var isLoading = false.obs;
  var isSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) => _sharedPrefsHelper = value);
  }

  bool isPhotoIdentityBlank(BuildContext context, type) {
    if (photoFrontController.value.isEmpty) {
      return true;
    }
    if (type == IdentityType.identityCard && photoBackController.value.isEmpty) {
      return true;
    }
    return false;
  }

  void resetPhoto() {
    photoFrontController.value = '';
    photoBackController.value = '';
    portraitController.value = '';
  }

  Future<Either<Failure, bool>> identifyIdol() async {
    AccountDto accountDto = new AccountDto(
      birthdate: birthdateController.value,
      country: countryController.value,
      fullName: fullNameController.value,
      gender: genderController.value,
      identityNumber: identityNumberController.value,
      portrait: portraitController.value,
      photoBack: photoBackController.value,
      photoFront: photoFrontController.value,
      province: provinceController.value,
      type: typeController.value,
    );
    return await IdentifyIdol().call(accountDto);
  }
}
