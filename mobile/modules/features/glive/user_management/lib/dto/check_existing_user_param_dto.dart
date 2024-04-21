class CheckExistingUserParamsDto {
  final bool loginWithPhone;
  final String phoneCode;
  final String phone;
  final String email;

  CheckExistingUserParamsDto({this.loginWithPhone = false, this.phoneCode = '', this.phone = '', this.email = ''});
}
