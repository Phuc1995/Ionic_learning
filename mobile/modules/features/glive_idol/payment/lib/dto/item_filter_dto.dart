class ItemFilterDto {
  int? id;
  String? typeName;

  ItemFilterDto({
    this.id,
    this.typeName
  });

  factory ItemFilterDto.fromJson(dynamic item) => ItemFilterDto(
    id: item['id'],
    typeName: item['type'],
  );
}
