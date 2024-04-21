class TickWasReadNotificationParamDto {
  final int id;
  final bool read;

  TickWasReadNotificationParamDto({required this.id, required this.read});

  Map<String, dynamic> toJson() => {
    "read": read,
  };

}