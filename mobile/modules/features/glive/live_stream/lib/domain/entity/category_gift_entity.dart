class CategoryGift {
  late bool? activated;
  late String categoryId;
  late String idMessage;
  late String code;
  late String createdDate;
  late String? exchangePrice;
  late String? exposeImageUrl;
  late String id;
  late String? imageUrl;
  late bool? isDeleted;
  late String name;
  late int? order;
  late String price;
  late List? promotions;
  late String size;
  late String updatedDate;

  CategoryGift({
    this.activated,
    required this.categoryId,
    required this.idMessage,
    required this.code,
    required this.createdDate,
    this.exchangePrice,
    this.exposeImageUrl,
    required this.id,
    this.imageUrl,
    this.isDeleted,
    required this.name,
    this.order,
    required this.price,
    this.promotions,
    required this.size,
    required this.updatedDate,
  });

  factory CategoryGift.fromMap(Map<String, dynamic> json) =>
      CategoryGift(
        activated: json['activated'],
        categoryId: json['categoryId'],
        idMessage: json['idMessage'],
        code: json['code'],
        createdDate: json['createdDate'],
        exchangePrice: json['exchangePrice'],
        exposeImageUrl: json['exposeImageUrl'],
        id: json['id'],
        imageUrl: json['imageUrl'],
        isDeleted: json['isDeleted'],
        name: json['name'],
        order: json['order'],
        price: json['price'],
        promotions: json['promotions'],
        size: json['size'],
        updatedDate: json['updatedDate'],
      );
}
