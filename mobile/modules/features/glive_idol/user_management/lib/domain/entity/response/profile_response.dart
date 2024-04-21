class ProfileResponse {
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
  Counter? counter;
  String? imageUrl;
  String? intro;
  bool? receiveNotification;
  String? balance;
  String googleId;
  String facebookId;
  String appleId;
  String zaloId;
  int totalFollow;

  ProfileResponse({
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
    this.counter = null,
    this.passwordUpdatedDate = null,
    this.intro = '',
    this.receiveNotification,
    this.balance = '0',
    this.googleId = '',
    this.facebookId = '',
    this.appleId = '',
    this.zaloId = '',
    this.totalFollow = 0,
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

  factory ProfileResponse.fromMap(Map<String, dynamic> map) => ProfileResponse(
        uuid: map["uuid"],
        username: map["username"],
        passwordUpdatedDate: map["passwordUpdatedDate"] != null
            ? DateTime.tryParse(map["passwordUpdatedDate"])
            : null,
        country: map["country"],
        fullName: map["fullName"],
        gender: map["gender"],
        birthdate: map["birthdate"],
        province: map["province"],
        email: map["email"] ?? '',
        mobile: map["mobile"] ?? '',
        gId: map["gId"],
        imageUrl: map["imageUrl"],
        identity:
            map["identity"] != null ? Identity.fromMap(map["identity"]) : null,
        counter: Counter.fromMap(map["counter"]),
        intro: map["intro"],
        receiveNotification: map["receiveNotification"],
        balance: map["balance"],
        googleId: map["googleId"] ?? '',
        facebookId: map["facebookId"] ?? '',
        appleId: map["appleId"] ?? '',
        zaloId: map["zaloId"] ?? '',
        totalFollow: map["totalFollow"]??0,
      );
}

class Counter {
  int fans;
  int followers;
  int moments;

  Counter({
    this.fans = 0,
    this.followers = 0,
    this.moments = 0,
  });

  factory Counter.fromMap(Map<String, dynamic> map) => Counter(
        fans: map["fans"],
        followers: map["followers"],
        moments: map["moments"],
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
