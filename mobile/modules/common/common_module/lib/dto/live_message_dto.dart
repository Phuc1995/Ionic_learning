import 'dart:convert';

class LiveMessageDto {
  String id;
  String? level;
  String name;
  String content;
  int? timestamp;
  bool me;
  String? type;
  String? giftImage;
  String? giftName;
  String? giftAnimation;
  String armorial;
  String medal;

  int? quantitySent;
  String? key;
  String? size;
  String gId;
  String imageUrl;
  bool isManager;
  bool isLocked;
  bool isSystem;
  dynamic permission;

  LiveMessageDto({
    this.id = '',
    this.level = "1",
    this.name = '',
    this.content = '',
    this.timestamp = 0,
    this.type = '',
    this.me = false,
    this.giftImage,
    this.giftName,
    this.giftAnimation,
    this.quantitySent,
    this.key,
    this.size = 'SMALL',
    this.gId = '',
    this.imageUrl = '',
    this.isManager = false,
    this.isLocked = false,
    this.isSystem = false,
    this.permission,
    required this.armorial,
    required this.medal,
  });

  factory LiveMessageDto.fromMap(Map<String, dynamic> map) => LiveMessageDto(
    id: map["id"],
    level: map["level"]??"1",
    name: map["name"]??"",
    content: map["content"]??"",
    timestamp: map["timestamp"],
    type: map["type"],
    giftImage: map["giftImage"],
    giftAnimation: map["giftAnimation"],
    giftName: map["giftName"],
    quantitySent: map["quantitySent"],
    size: map["size"],
    gId: map["gId"]??"",
    imageUrl: map["imageUrl"] == null ? "" : map["imageUrl"],
    permission: map["permission"] != null ? json.decode(map["permission"]) : null,
    isManager: map["permission"] != null ? json.decode(map["permission"]).contains("LIVE_ROOM_MANAGER") : false,
    isLocked: map["permission"] != null ? json.decode(map["permission"]).contains("LIVE_ROOM_LOCKED_CHAT") : false,
    me: false,
    armorial: map["armorial"],
    medal: map["medal"],
  );
}

class LiveMessageTypes {
  LiveMessageTypes(_);
  static const String join = 'join';
  static const String message = 'message';
  static const String leave = 'leave';
  static const String gift = 'gift';
  static const String ban = 'ban';
  static const String follow = 'follow';
  static const String level_up = 'level_up';
}
