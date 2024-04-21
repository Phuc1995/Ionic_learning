class IdolDetailDto{
  final String uuid;
  final String? fullName;
  final String? email;
  final String? imageUrl;
  final String? country;
  final int? gender;
  final String? birthdate;
  final String? province;
  final String? gId;
  final String? intro;
  final int? experiencePoint;
  final bool? isReceiveNotify;
  bool? isFollowed;
  String? latestLiveTime;
  String? currentTime;
  bool? isStreaming;
  final bool? isBanned;
  final LevelIdolEntity? level;
  final List<FollowIdolEntity>? follows;
  final List<SkillsIdolEntity>? skills;

  IdolDetailDto({
    required this.uuid,
    this.fullName,
    this.email,
    this.imageUrl,
    this.country,
    this.gender,
    this.birthdate,
    this.province,
    this.gId,
    this.experiencePoint,
    this.intro,
    this.isFollowed = true,
    this.level,
    this.follows,
    this.skills,
    this.isReceiveNotify,
    this.currentTime,
    this.isStreaming,
    this.isBanned,
    this.latestLiveTime,
  });

  factory IdolDetailDto.fromMap(dynamic json) {
    final entity = IdolDetailDto(uuid: json['uuid'],
        fullName: json['fullName']?? "",
        email: json['email']?? "",
        imageUrl: json['imageUrl']?? "",
        country: json['country']?? "",
        gender: json['gender']?? "",
        birthdate: json['birthdate']?? "",
        province: json['province']?? "",
        gId: json['gId']?? "",
        level: json['level'] != null ? LevelIdolEntity.fromMap(json['level']) : null,
        intro: json['intro']??"",
        currentTime: json['currentTime'],
        latestLiveTime: json['latestLiveTime'],
        isStreaming: json['isStreaming']??false,
        isBanned: json['bannedUsers'].length > 0 ? true : false,
        isReceiveNotify: json['viewerFollowed'] != null ? json['viewerFollowed']['notification']??false : false,
        skills: [],
        follows: [],
    );
    (json['skills']??[]).forEach((ex) {
      final skillsIDol = SkillsIdolEntity.fromMap(ex);
      entity.skills!.add(skillsIDol);
    });
    (json['follows']??[]).forEach((ex) {
      final follow = FollowIdolEntity.fromMap(ex);
      entity.follows!.add(follow);
    });
    return entity;
  }
}

class SkillsIdolEntity {
  String key;
  String name;
  String imageUrl;
  SkillsIdolEntity({required this.name, required this.imageUrl, required this.key});

  factory SkillsIdolEntity.fromMap(Map<String, dynamic> json) => SkillsIdolEntity(
    key: json['key'],
    name: json['name'],
    imageUrl: json['imageUrl'],
  );
}

class FollowIdolEntity {
  final String viewerUuid;
  FollowIdolEntity({required this.viewerUuid});

  factory FollowIdolEntity.fromMap(Map<String, dynamic> json) => FollowIdolEntity(
    viewerUuid: json['viewerUuid'],
  );
}

class LevelIdolEntity {
  String key;
  String name;
  String medal;
  LevelIdolEntity({required this.name, required this.medal, required this.key});

  factory LevelIdolEntity.fromMap(Map<String, dynamic> json) => LevelIdolEntity(
    key: json['key'],
    name: json['name'],
    medal: json['medal'],
  );
}
