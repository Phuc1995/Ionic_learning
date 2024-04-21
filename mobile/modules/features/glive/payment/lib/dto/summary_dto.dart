class SummaryDto {
  int totalDate;
  int totalLiveTime;
  int totalFan;
  int totalRuby;

  SummaryDto(
      {
        required this.totalDate,
        required this.totalLiveTime,
        required this.totalFan,
        required this.totalRuby,
      });

  factory SummaryDto.fromMap(Map<String, dynamic> json) => SummaryDto(
    totalDate: json['totalDate'],
    totalLiveTime: json['totalLiveTime'],
    totalFan: json['totalFan'],
    totalRuby: json['totalRuby'],
  );
}
