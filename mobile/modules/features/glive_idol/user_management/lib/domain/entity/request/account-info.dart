class AccountDto {
  String fullName = '';
  String country = '';
  String province = '';
  String birthdate = '';
  String identityNumber = '';
  int gender = 1;
  String type = '';
  String photoFront = '';
  String photoBack = '';
  String portrait = '';

  List<String> imageUrl = [];

  AccountDto(
      {String fullName: '',
      String country: '',
      String birthdate: '',
      int gender: 1,
      String province: '',
      String identityNumber: '',
      String type: '',
      String photoFront: '',
      String photoBack: '',
      String portrait: ''}) {
    this.fullName = fullName;
    this.country = country;
    this.birthdate = birthdate;
    this.gender = gender;
    this.province = province;
    this.identityNumber = identityNumber;
    this.type = type;
    this.photoFront = photoFront;
    this.photoBack = photoBack;
    this.portrait = portrait;
  }

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "country": country,
        "birthdate": birthdate,
        "gender": gender,
        "province": province,
        "identityNumber": identityNumber,
        "type": type,
        "photoFront": photoFront,
        "photoBack": photoBack,
        "portrait": portrait,
      };
}
