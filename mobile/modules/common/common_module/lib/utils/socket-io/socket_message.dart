class SocketMessage {
  dynamic id;
  String title;
  String body;
  bool silent;
  String type;
  String? imageUrl;
  Map<String, dynamic>? data;

  SocketMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.silent,
    required this.type,
    this.imageUrl,
    this.data
  });

  factory SocketMessage.fromMap(Map<String, dynamic> map) {
    return SocketMessage(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      type: map['type'],
      silent: map['silent'],
      imageUrl: map['imageUrl'],
      data: map['data'],
    );
  }
}