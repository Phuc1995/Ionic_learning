class ProfileResponseDto {
  String uuid;
  String username;
  DateTime? passwordUpdatedDate;
  String? country;
  String? fullName;
  int? gender;
  String? birthdate;
  String? province;
  String email;
  String mobile;
  String? gId;
  Identity? identity;
  String? imageUrl;
  String? intro;
  bool? receiveNotification;
  String? balance;
  String googleId;
  String facebookId;
  String appleId;
  String zaloId;
  Level? level;
  String? idolsFollowed;

  ProfileResponseDto({
    this.uuid = '',
    this.username = '',
    this.country = '',
    this.fullName = '',
    this.gender = 0,
    this.birthdate = '',
    this.province = '',
    this.email = '',
    this.mobile = '',
    this.gId = '',
    this.imageUrl = '',
    this.identity = null,
    // this.counter = null,
    this.passwordUpdatedDate = null,
    this.intro = '',
    this.receiveNotification,
    this.balance = '0',
    this.googleId = '',
    this.facebookId = '',
    this.appleId = '',
    this.zaloId = '',
    this.level,
    this.idolsFollowed,
  });

  bool needLinkAccount() {
    return !(mobile.isNotEmpty &&
        email.isNotEmpty &&
        (googleId.isNotEmpty ||
            facebookId.isNotEmpty ||
            appleId.isNotEmpty ||
            zaloId.isNotEmpty));
  }

  bool canChangePassword() {
    return mobile.isNotEmpty || email.isNotEmpty;
  }

  factory ProfileResponseDto.fromMap(Map<String, dynamic> map) => ProfileResponseDto(
        uuid: map["uuid"],
        username: map["username"]?? '',
        passwordUpdatedDate: map["passwordUpdatedDate"] != null
        ? DateTime.tryParse(map["passwordUpdatedDate"])
        : null,
        country: map["country"]?? '',
        fullName: map["fullName"]?? '',
        gender: map["gender"],
        birthdate: map["birthdate"],
        province: map["address"],
        email: map["email"]?? '',
        mobile: map["mobile"]?? '',
        gId: map["gId"]?? '',
        imageUrl: map["imageUrl"]?? '',
        identity: map["identity"] != null ? Identity.fromMap(map["identity"]) : null,
        // counter: Counter.fromMap(map["counter"]),
        intro: map["intro"],
        receiveNotification: map["receiveNotification"],
        balance: map["balance"],
        googleId: map["googleId"] ?? '',
        facebookId: map["facebookId"] ?? '',
        appleId: map["appleId"] ?? '',
        zaloId: map["zaloId"] ?? '',
        level: Level.fromMap(map["level"]),
        idolsFollowed: map["idolsFollowed"].toString(),
      );
}

class Identity {
  String statusVerify;
  String note;

  Identity({
    required this.statusVerify,
    required this.note,
  });

  factory Identity.fromMap(Map<String, dynamic> map) => Identity(
        statusVerify: map["statusVerify"],
        note: map["note"] ?? '',
      );


}

class Level {
  final String key;
  final String name;
  final String description;
  final String medal;
  final String armorial;

  Level({required this.key, required this.name, required this.description, required this.medal, required this.armorial});

  factory Level.fromMap(Map<String, dynamic> map) => Level(
    key: map["key"] ?? '',
    name: map["name"] ?? '',
    description: map["description"] ?? '',
    medal: map["medal"] ?? '',
    armorial: map["armorial"] ?? '',
  );

}
