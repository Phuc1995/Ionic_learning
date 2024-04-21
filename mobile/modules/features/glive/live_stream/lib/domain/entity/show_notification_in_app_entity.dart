class ShowNotificationInAppEntity {
  final String urlImage;
  final String nameIdol;
  final String uuidIdol;
  final bool isBell;

  ShowNotificationInAppEntity({
    required this.urlImage,
    required this.nameIdol,
    required this.uuidIdol,
    required this.isBell,
  });

  factory ShowNotificationInAppEntity.fromMap(Map<String, dynamic> json) => ShowNotificationInAppEntity(
    uuidIdol: json['data']['id'],
    nameIdol: json['data']['gId'],
    urlImage: json['data']['imageUrl'],
    isBell: json['data']['bell']??false,
  );

}
