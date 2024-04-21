class FacebookInfoResponseDto {
  String id;
  String name;

  FacebookInfoResponseDto({
    this.name = '',
    this.id = '',
  });

  factory FacebookInfoResponseDto.fromMap(Map<String, dynamic> map) => FacebookInfoResponseDto(
    name: map['name'],
    id: map['id'],
  );
}
