class GiftDto {
  late String idMessage;
  late String quantity;
  late String giftName;
  late String giftImage;
  late String giftAnimation;
  late String userName;
  late bool? iShow;
  late String size;
  late String userImage;

  GiftDto({
    required this.idMessage,
    required this.quantity,
    required this.giftName,
    required this.giftImage,
    required this.giftAnimation,
    required this.userName,
    required this.size,
    required this.userImage,
    this.iShow = false,
  });
  GiftDto.empty();

  bool checkIfAnyIsNull() {
    return [giftImage].contains(null);
  }

}
