class LiveRoomDto {
  String id;
  String name;
  String room;
  int? timestamp;
  String? avatar;
  bool? me;

  LiveRoomDto({
    this.id = '',
    this.name = '',
    this.room = '',
    this.timestamp = 0,
    this.avatar = '',
    this.me = false
  });
}
