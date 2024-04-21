class GiftDto {
  late String id;
  late int price;
  late int promotionPrice;
  late int quantity;
  late String receiverId;
  late String streamId;

  GiftDto({
    required this.id,
    required this.price,
    required this.promotionPrice,
    required this.quantity,
    required this.receiverId,
    required this.streamId,
  });
}
