class AccountParamsDto {
  final bool loginWithPhone;
  final String phoneCode;
  final String phone;
  final String email;
  final String password;

  AccountParamsDto({this.loginWithPhone = false, this.phoneCode = '', this.phone = '', this.email = '', required this.password});
}
