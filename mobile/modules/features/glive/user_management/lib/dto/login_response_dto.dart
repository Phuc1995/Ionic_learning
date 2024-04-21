class LoginResponseDto {
  String username;
  String accessToken;
  String refreshToken;
  bool? isNewUser;

  LoginResponseDto({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    this.isNewUser,
  });

  factory LoginResponseDto.fromMap(Map<String, dynamic> map) => LoginResponseDto(
    username: map["username"],
    accessToken: map["accessToken"],
    refreshToken: map["refreshToken"],
    isNewUser: map["isNew"],
  );
}
