class AccountDto {
  String fullName = '';
  String address = '';
  String birthdate = '';
  int gender = 1;
  String? intro = '';

  List<String> imageUrl = [];

  AccountDto({
    String fullName: '',
    String address: '',
    String birthdate: '',
    int gender: 1,
    String? intro = '',
  }) {
    this.fullName = fullName;
    this.address = address;
    this.birthdate = birthdate;
    this.gender = gender;
    this.intro = intro;
  }

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "address": address,
        "birthdate": birthdate,
        "gender": gender,
        "intro": intro,
      };
}
