class LevelPolicyDto {
  String level;
  String medalUrl;
  String armorialUrl;
  int? maxExp;
  int minExp;

  LevelPolicyDto({
    required this.level,
    required this.medalUrl,
    required this.armorialUrl,
    required this.maxExp,
    required this.minExp,
  });

  factory LevelPolicyDto.fromMap(Map<String, dynamic> json) =>
      LevelPolicyDto(
        level: json['levelKey'],
        medalUrl: json['level']['medal'],
        armorialUrl: json['level']['armorial'],
        maxExp: json['maxExp'] == null ? null : int.parse(json['maxExp']),
        minExp: int.parse(json['minExp'])
      );
}
