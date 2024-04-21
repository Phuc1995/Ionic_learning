class OtpDto {
  String type = '';
  String email = '';
  String phoneNumber = '';
  String phoneCode = '';
  String verifyCode = '';

  OtpDto({String type: '', String email: '', String phoneNumber: '', String phoneCode: '', String verifyCode: ''}){
    this.type = type;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.phoneCode = phoneCode;
    this.verifyCode = verifyCode;
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "email": email,
    "phoneNumber": phoneNumber,
    "phoneCode": phoneCode,
    "verifyCode": verifyCode,
  };
}
