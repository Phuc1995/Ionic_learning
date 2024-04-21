class ExperienceDto {
  int currentExp;
  int maxExp;
  int minExp;
  String level;
  String medalUrl;
  String armorial;

  ExperienceDto({
    required this.currentExp,
    required this.maxExp,
    required this.minExp,
    required this.level,
    required this.medalUrl,
    required this.armorial,
});

  factory ExperienceDto.fromMap(Map<String, dynamic> json) => ExperienceDto(
    currentExp: json['exp'],
    maxExp: int.parse(json['maxExp']),
    minExp: int.parse(json['minExp']),
    level: json['level']['name'],
    medalUrl: json['level']['medal'],
    armorial: json['level']['armorial']
  );
}
