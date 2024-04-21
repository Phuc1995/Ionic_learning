class ChangePasswordParamsDto {
  String? currentPassword;
  String newPassword;

  ChangePasswordParamsDto({this.currentPassword, required this.newPassword});
}
