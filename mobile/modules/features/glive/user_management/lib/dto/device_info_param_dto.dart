class DeviceInfoParamDto {
  final String deviceId;
  final String deviceModel;
  final String fcmToken;

  DeviceInfoParamDto({required this.deviceId, required this.deviceModel, required this.fcmToken});

  Map<String, dynamic> toJson() => {
    "id": deviceId,
    "token": fcmToken,
    "name": deviceModel,
  };
}