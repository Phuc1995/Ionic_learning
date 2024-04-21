class LiveViewerDto {
  String id;
  String name;
  int? timestamp;
  String? avatar;
  bool? me;

  LiveViewerDto({
    this.id = '',
    this.name = '',
    this.timestamp = 0,
    this.avatar = '',
    this.me = false
  });
}
