class Idol {
  String name;
  int id;

  Idol({
    required this.name,
    required this.id,
  });

  factory Idol.fromMap(Map<String, dynamic> json) => Idol(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "id": id,
  };

}
