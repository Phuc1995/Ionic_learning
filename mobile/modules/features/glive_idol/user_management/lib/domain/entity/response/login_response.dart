class LoginResponse {
  String username;
  String accessToken;
  String refreshToken;
  bool? isNew;

  LoginResponse({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    this.isNew,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) => LoginResponse(
    username: map['username'],
    accessToken: map["accessToken"],
    refreshToken: map["refreshToken"],
    isNew: map["isNew"],
  );
}
