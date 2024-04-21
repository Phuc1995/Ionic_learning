import 'package:common_module/common_module.dart';
import 'package:user_management/constants/assets.dart';

class NotificationDataEntity {
  String createdDate;
  String title;
  String content;
  String imageUrl;
  String type;
  bool read;
  int id;

  NotificationDataEntity(
      {
        required this.createdDate,
        required this.title,
        required this.content,
        required this.imageUrl,
        required this.type,
        required this.read,
        required this.id,
      });

  factory NotificationDataEntity.fromMap(Map<String, dynamic> json) => NotificationDataEntity(
    createdDate: ConvertCommon().convertDate(json['createdDate']),
    title: json['title'],
    content: json['content'],
    imageUrl: (json['imageUrl']??'').isEmpty ? Assets.appIcon : json['imageUrl'],
    type: json['type'],
    read: json['read'],
    id: int.parse(json['id'])
  );
}
