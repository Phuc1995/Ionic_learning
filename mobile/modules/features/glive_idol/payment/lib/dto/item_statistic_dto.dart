class ItemStatisticDto {
  String timeLine;
  int liveTime;
  int fan;
  int ruby;

  ItemStatisticDto({
    required this.timeLine,
    required this.liveTime,
    required this.fan,
    required this.ruby,
  });

  factory ItemStatisticDto.fromMap(Map<String, dynamic> json) => ItemStatisticDto(
    timeLine: json['timeLine'],
    liveTime: json['liveTime'],
    fan: json['fan'],
    ruby: json['ruby'],
  );
}
