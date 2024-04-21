class RegisterParamsDto {
  final bool loginWithPhone;
  final String email;
  final String phoneCode;
  final String phone;
  final String password;
  final String verifyCode;

  RegisterParamsDto({this.loginWithPhone = false, this.email = '', this.phoneCode = '', this.phone = '', required this.password, required this.verifyCode});
}
