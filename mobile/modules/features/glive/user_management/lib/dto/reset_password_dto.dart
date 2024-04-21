class ResettingPasswordDto {
  String email = '';
  String phoneCode = '';
  String phoneNumber = '';
  String verifyCode = '';
  String password = '';

  ResettingPasswordDto({String phoneCode: '', String phoneNumber: '', String password: '', String email: '', String verifyCode: ''}){
    this.password = password;
    this.email = email;
    this.verifyCode = verifyCode;
    this.phoneCode = phoneCode;
    this.phoneNumber = phoneNumber;
  }

  Map<String, dynamic> toJson() => {
    "password": password,
    "email": email,
    "verifyCode": verifyCode,
    "phoneNumber": phoneNumber,
    "phoneCode": phoneCode,
  };
}
