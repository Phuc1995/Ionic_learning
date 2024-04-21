class Gift {
  late String idMessage;
  late String quantity;
  late String giftName;
  late String giftImage;
  late String giftAnimation;
  late String userName;
  late bool? iShow;
  late String size;

  Gift({
    required this.idMessage,
    required this.quantity,
    required this.giftName,
    required this.giftImage,
    required this.userName,
    required this.giftAnimation,
    required this.size,
    this.iShow = false,
  });
  Gift.empty();

  bool checkIfAnyIsNull() {
    return [giftImage].contains(null);
  }

}
