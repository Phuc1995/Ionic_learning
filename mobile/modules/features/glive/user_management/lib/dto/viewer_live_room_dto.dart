class ViewerLiveRoomDto {
  String id;
  String name;
  int liveId;
  int? timestamp;
  String? gId;
  String? imageUrl;
  String? thumbnail;
  String? room;
  String? streamId;
  int? viewCount;
  int? ruby;
  String? hls;
  String? flv;
  String? tag;

  ViewerLiveRoomDto({
    this.id = '',
    this.name = '',
    this.liveId = 0,
    this.timestamp = 0,
    this.gId = '',
    this.imageUrl = '',
    this.thumbnail = '',
    this.room = '',
    this.streamId = '',
    this.viewCount = 0,
    this.ruby = 0,
    this.hls = '',
    this.flv = '',
    this.tag = '',
  });

  factory ViewerLiveRoomDto.fromMap(Map<dynamic, dynamic> map) => ViewerLiveRoomDto(
        id: map["id"],
        name: map["name"],
        liveId: int.tryParse(map["liveId"] != null ? map["liveId"].toString() : "0")??0,
        timestamp: map["timestamp"],
        gId: map["gId"],
        imageUrl: map["imageUrl"] == null ? "" : map["imageUrl"],
        thumbnail: map["thumbnail"] == null ? "" : map["thumbnail"],
        room: map["room"],
        streamId: map["streamId"],
        viewCount: map["view_count"]??0,
        ruby: map["ruby"]??0,
        hls: map["hls"],
        flv: map["flv"],
        tag: map["tags"]??"",
      );
}
