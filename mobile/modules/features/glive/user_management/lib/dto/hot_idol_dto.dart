class HotIdolDto {
  String name;
  int id;

  HotIdolDto({
    required this.name,
    required this.id,
  });

  factory HotIdolDto.fromMap(Map<String, dynamic> json) => HotIdolDto(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "id": id,
  };

}
