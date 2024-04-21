class RemoveInfoParamsDto {
  final String deviceId;

  RemoveInfoParamsDto({required this.deviceId});

  Map<String, dynamic> toJson() => {
    "id": deviceId,
  };
}