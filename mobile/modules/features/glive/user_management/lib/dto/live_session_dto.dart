class LiveSessionDto {
  String deviceId = '';
  String userUuid = '';
  String roomName = '';
  String roomAvatar = '';
  String tags = '';

  LiveSessionDto({String deviceId: '', String userUuid: '', String roomName: '', String roomAvatar: '', String tags : ''}){
    this.deviceId = deviceId;
    this.userUuid = userUuid;
    this.roomName = roomName;
    this.roomAvatar = roomAvatar;
    this.tags = tags;
  }

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "userUuid": userUuid,
    "roomName": roomName,
    "roomAvatar": roomAvatar,
    "tags": tags,
  };
}
