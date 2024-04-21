class FacebookInfoResponse {
  String id;
  String name;

  FacebookInfoResponse({
    this.name = '',
    this.id = '',
  });

  factory FacebookInfoResponse.fromMap(Map<String, dynamic> map) => FacebookInfoResponse(
    name: map['name'],
    id: map['id'],
  );
}
