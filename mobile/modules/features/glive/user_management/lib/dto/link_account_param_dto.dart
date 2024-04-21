class LinkAccountParamsDto {
  final bool isPhone;
  final String phoneCode;
  final String phoneNumber;
  final String email;
  final String verifyCode;

  LinkAccountParamsDto({this.isPhone = false, this.phoneCode = '', this.phoneNumber = '', this.email = '', this.verifyCode = ''});
}
