class CategoryResponse {
  final String? icon;
  final String name;
  final String key;
  late bool isCheck;

  CategoryResponse({
    required this.name,
    required this.icon,
    required this.key,
    this.isCheck = false,
  });

  factory CategoryResponse.fromMap(Map<String, dynamic> map) => CategoryResponse(
    icon: map["imageUrl"],
    name: map["name"],
    key: map["key"],
  );
}
