class AccessStatusResponse {
  BanData? banData;

  AccessStatusResponse({
    this.banData,
  });

  factory AccessStatusResponse.fromMap(Map<String, dynamic> map) => AccessStatusResponse(
    banData: BanData.fromMap(map['banData']),
  );
}
class BanData {
  DateTime createdDate;
  DateTime updatedDate;
  String userUuid;
  String reason;
  bool activated;
  DateTime from;
  DateTime to;

  BanData({
    required createdDate,
    required updatedDate,
    this.userUuid = '',
    this.reason = '',
    this.activated = false,
    required from,
    required to,
  }) : this.createdDate = createdDate ?? DateTime.now(),
   this.updatedDate = updatedDate ?? DateTime.now(),
   this.from = from ?? DateTime.now(),
   this.to = to ?? DateTime.now();

  factory BanData.fromMap(Map<String, dynamic> map) => BanData(
    createdDate: DateTime.parse(map['createdDate']),
    updatedDate: DateTime.parse(map['updatedDate']),
    userUuid: map['userUuid'],
    reason: map['reason'],
    activated: map['activated'],
    from: DateTime.parse(map['from']),
    to: DateTime.parse(map['to']),
  );
}