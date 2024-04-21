import 'package:common_module/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/dto/account_info_dto.dart';
import 'package:user_management/service/auth_api_service.dart';
import '../presentation/page/account_complete_page/account_complete_page.dart';

class AccountCompleteController extends GetxController {
  AccountCompleteController();

  final _authService = Modular.get<AuthApiService>();
  var fullNameController = ''.obs;
  var addressController = ''.obs;
  var birthdateController = ''.obs;
  var genderController = 0.obs;
  var invalidFullNameMsg = ''.obs;
  var invalidCountryMsg = ''.obs;
  var invalidBirthdateMsg = ''.obs;
  var invalidGenderMsg = ''.obs;
  var introController = ''.obs;
  var introCountryMsg = ''.obs;

  var isLoading = false.obs;
  var isSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<Either<Failure, bool>> accountProfile() async {
    AccountDto accountDto = new AccountDto(
      birthdate: birthdateController.value,
      address: addressController.value,
      fullName: fullNameController.value,
      gender: genderController.value,
      intro: introController.value,
    );
    return await _authService.updateInfoViewer(account: accountDto);
  }
}
