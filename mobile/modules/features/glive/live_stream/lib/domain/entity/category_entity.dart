class CategoryList {
  late String code;
  late String createdDate;
  late String id;
  late String name;
  late int? order;
  late String updatedDate;
  late List gifts;

  CategoryList({
    required this.code,
    required this.createdDate,
    required this.id,
    required this.name,
    this.order,
    required this.updatedDate,
    required this.gifts,
  });

  factory CategoryList.fromMap(Map<String, dynamic> json) => CategoryList(
        code: json['code'],
        createdDate: json['createdDate'],
        id: json['id'],
        name: json['name'],
        order: json['order'],
        updatedDate: json['updatedDate'],
        gifts: json['gifts'],
      );
}